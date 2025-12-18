import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class RebirthPopup extends StatelessWidget {
  const RebirthPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.red.withValues(alpha: 0.3), width: 2),
      ),
      child: Consumer<GameProvider>(
        builder: (context, provider, child) {
          final userData = provider.userData;
          final rebirthPoints = userData.level; // 레벨 = 환생 포인트
          final artifactBoxes = userData.level ~/ 10; // 10레벨당 1개

          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '환생',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.refresh,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '현재 레벨: ${userData.level}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.cyan,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '환생 시 획득',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.stars,
                              color: Colors.cyan,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '환생 포인트: $rebirthPoints',
                              style: const TextStyle(
                                color: Colors.cyan,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.inventory_2,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '유물 상자: $artifactBoxes개',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '주의사항',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildWarningItem('레벨, 경험치, 골드가 초기화됩니다'),
                  _buildWarningItem('동료가 초기화됩니다'),
                  _buildWarningItem('상태 강화 레벨이 초기화됩니다'),
                  const SizedBox(height: 12),
                  const Text(
                    '유지되는 항목',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildWarningItem('스테이지 진행도', isPositive: true),
                  _buildWarningItem('환생 포인트', isPositive: true),
                  _buildWarningItem('유물', isPositive: true),
                  _buildWarningItem('스킬 레벨', isPositive: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: userData.level > 1
                        ? () {
                            _showRebirthConfirmDialog(context, provider, rebirthPoints, artifactBoxes);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '환생하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWarningItem(String text, {bool isPositive = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.check_circle : Icons.warning,
            color: isPositive ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isPositive ? Colors.green.shade300 : Colors.red.shade300,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRebirthConfirmDialog(
    BuildContext context,
    GameProvider provider,
    int rebirthPoints,
    int artifactBoxes,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          '환생 확인',
          style: TextStyle(color: Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '정말 환생하시겠습니까?',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              '획득: 환생 포인트 $rebirthPoints, 유물 상자 $artifactBoxes개',
              style: const TextStyle(
                color: Colors.cyan,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await provider.performRebirth();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text(
              '확인',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

