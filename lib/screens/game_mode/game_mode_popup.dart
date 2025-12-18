import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../game/game_screen.dart';

class GameModePopup extends StatefulWidget {
  const GameModePopup({super.key});

  @override
  State<GameModePopup> createState() => _GameModePopupState();
}

class _GameModePopupState extends State<GameModePopup>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.cyan.withOpacity(0.3), width: 2),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '게임 모드 선택',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.cyan,
              labelColor: Colors.cyan,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: '일반 스테이지'),
                Tab(text: '일일던전'),
                Tab(text: '무한모드'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStageTab(),
                  _buildDailyDungeonTab(),
                  _buildInfiniteTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageTab() {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        final progress = provider.stageProgress;
        final unlockedStages = progress.unlockedStages.toList()..sort();

        return ListView.builder(
          itemCount: unlockedStages.length,
          itemBuilder: (context, index) {
            final stage = unlockedStages[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GameScreen(
                        stage: stage,
                        gameMode: 'stage',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.withOpacity(0.2),
                  padding: const EdgeInsets.all(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '스테이지 $stage',
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.cyan),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDailyDungeonTab() {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        final remainingEntries = provider.remainingDailyDungeonEntries;

        return Column(
          children: [
            // 경험치 던전
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.purple.withOpacity(0.2),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: const Text(
                    '경험치 던전',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.vpn_key, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '남은 횟수: $remainingEntries',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.cyan),
                  onTap: () {
                    if (provider.canEnterDailyDungeon()) {
                      provider.useDailyDungeonEntry();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameScreen(
                            stage: 1,
                            gameMode: 'daily_exp',
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('일일 던전 입장 횟수를 모두 사용했습니다'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

            // 골드 던전
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.yellow.withOpacity(0.2),
                child: ListTile(
                  leading: const Icon(Icons.monetization_on, color: Colors.yellow),
                  title: const Text(
                    '골드 던전',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.vpn_key, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '남은 횟수: $remainingEntries',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.cyan),
                  onTap: () {
                    if (provider.canEnterDailyDungeon()) {
                      provider.useDailyDungeonEntry();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameScreen(
                            stage: 1,
                            gameMode: 'daily_gold',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfiniteTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.all_inclusive,
            size: 80,
            color: Colors.cyan,
          ),
          const SizedBox(height: 20),
          const Text(
            '무한모드',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GameScreen(
                    stage: 1,
                    gameMode: 'infinite',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
            ),
            child: const Text(
              '시작',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

