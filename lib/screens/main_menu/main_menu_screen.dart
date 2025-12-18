import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../core/constants/game_constants.dart';
import '../game_mode/game_mode_popup.dart';
import '../mission/mission_screen.dart';
import '../rebirth/rebirth_popup.dart';
import '../achievement/achievement_popup.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _goldClickCount = 0;
  DateTime? _lastGoldClickTime;
  String _nickname = '플레이어';

  void _onGoldClick() {
    final now = DateTime.now();
    if (_lastGoldClickTime == null ||
        now.difference(_lastGoldClickTime!) < const Duration(seconds: 2)) {
      _goldClickCount++;
      _lastGoldClickTime = now;
      
      if (_goldClickCount >= 5) {
        _goldClickCount = 0;
        _showDeveloperMode();
      }
    } else {
      _goldClickCount = 1;
      _lastGoldClickTime = now;
    }
  }

  void _showDeveloperMode() {
    showDialog(
      context: context,
      builder: (context) => const DeveloperModeDialog(),
    );
  }

  void _showNicknameDialog() {
    final controller = TextEditingController(text: _nickname);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          '닉네임 변경',
          style: TextStyle(color: Colors.cyan),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: '닉네임',
            labelStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.cyan),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.cyan, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _nickname = controller.text.isNotEmpty ? controller.text : '플레이어';
              });
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(
          '$feature',
          style: const TextStyle(color: Colors.cyan),
        ),
        content: Text(
          '$feature 기능은 준비 중입니다.',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        final userData = provider.userData;
        
        return Scaffold(
          backgroundColor: const Color(0xFF0F0F1E),
          body: SafeArea(
            child: Column(
              children: [
                // 상단 바
                _buildTopBar(userData),
                
                // 중간 영역
                Expanded(
                  child: Row(
                    children: [
                      // 왼쪽 공간
                      const Expanded(child: SizedBox()),
                      
                      // 중앙 게임시작 버튼
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: _buildGameStartButton(),
                        ),
                      ),
                      
                      // 오른쪽 환생/업적 버튼
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSmallButton(
                                icon: Icons.assignment,
                                label: '미션',
                                color: Colors.green,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const MissionScreen(),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildSmallButton(
                                icon: Icons.refresh,
                                label: '환생',
                                color: Colors.red,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const RebirthPopup(),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildSmallButton(
                                icon: Icons.emoji_events,
                                label: '업적',
                                color: Colors.yellow,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const AchievementPopup(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 하단 버튼들
                _buildBottomButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  // 상단 바 (왼쪽: 닉네임/레벨/경험치, 오른쪽: 골드)
  Widget _buildTopBar(userData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽: 닉네임, 레벨, 경험치
          GestureDetector(
            onTap: _showNicknameDialog,
            child: _buildUserInfo(userData),
          ),
          
          // 오른쪽: 골드, 환생 포인트
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _onGoldClick,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatNumber(userData.gold),
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.cyan.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.stars,
                        color: Colors.cyan,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatNumber(userData.rebirthPoints),
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 사용자 정보 (닉네임, 레벨, 경험치)
  Widget _buildUserInfo(userData) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 아바타 아이콘 + 레벨
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyan.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.cyan,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.cyan,
                  size: 20,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.cyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Lv.${userData.level}',
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // 닉네임, 경험치
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _nickname,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // 경험치 바 (숫자 포함)
              SizedBox(
                width: 140,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: userData.exp / userData.expToNextLevel,
                        backgroundColor: Colors.grey.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                        minHeight: 20,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${userData.exp}/${userData.expToNextLevel}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.8),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 게임시작 버튼
  Widget _buildGameStartButton() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const GameModePopup(),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          minimumSize: const Size(0, 0), // 최소 크기 제한 제거
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '게임시작',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 작은 버튼 (환생, 업적)
  Widget _buildSmallButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 하단 버튼들
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomButton(
            icon: Icons.auto_awesome,
            label: '스킬',
            color: Colors.purple,
            onTap: () {
              Navigator.pushNamed(context, '/skill');
            },
          ),
          _buildBottomButton(
            icon: Icons.people,
            label: '동료',
            color: Colors.orange,
            onTap: () {
              Navigator.pushNamed(context, '/companion');
            },
          ),
          _buildBottomButton(
            icon: Icons.stars,
            label: '유물',
            color: Colors.amber,
            onTap: () {
              Navigator.pushNamed(context, '/artifact');
            },
          ),
          _buildBottomButton(
            icon: Icons.analytics,
            label: '능력치',
            color: Colors.blue,
            onTap: () {
              Navigator.pushNamed(context, '/status');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}

// DeveloperModeDialog
class DeveloperModeDialog extends StatefulWidget {
  const DeveloperModeDialog({super.key});

  @override
  State<DeveloperModeDialog> createState() => _DeveloperModeDialogState();
}

class _DeveloperModeDialogState extends State<DeveloperModeDialog> {
  late TextEditingController _goldController;
  late TextEditingController _levelController;
  late TextEditingController _rebirthPointsController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<GameProvider>(context, listen: false);
    final userData = provider.userData;
    _goldController = TextEditingController(text: userData.gold.toString());
    _levelController = TextEditingController(text: userData.level.toString());
    _rebirthPointsController = TextEditingController(text: userData.rebirthPoints.toString());
  }

  @override
  void dispose() {
    _goldController.dispose();
    _levelController.dispose();
    _rebirthPointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final userData = provider.userData;

    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Text(
        '개발자 모드',
        style: TextStyle(color: Colors.cyan),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInputField('골드', _goldController),
            const SizedBox(height: 16),
            _buildInputField('레벨', _levelController),
            const SizedBox(height: 16),
            _buildInputField('환생 포인트', _rebirthPointsController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () async {
            final gold = int.tryParse(_goldController.text) ?? userData.gold;
            final level = int.tryParse(_levelController.text) ?? userData.level;
            final rebirthPoints = int.tryParse(_rebirthPointsController.text) ?? userData.rebirthPoints;
            
            await provider.updateUserData(
              userData.copyWith(
                gold: gold,
                level: level,
                rebirthPoints: rebirthPoints,
              ),
            );
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text('적용'),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.cyan),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
        ),
      ),
    );
  }
}
