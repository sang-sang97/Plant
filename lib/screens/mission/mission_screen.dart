import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../core/models/mission.dart';

class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.cyan.withValues(alpha: 0.3), width: 2),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '미션',
                  style: TextStyle(
                    color: Colors.cyan,
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
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      indicatorColor: Colors.cyan,
                      labelColor: Colors.cyan,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: '일일미션'),
                        Tab(text: '주간미션'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildDailyMissions(context),
                          _buildWeeklyMissions(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyMissions(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        final missions = provider.dailyMissions;

        if (missions.isEmpty) {
          return const Center(
            child: Text(
              '일일미션이 없습니다',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: missions.length,
          itemBuilder: (context, index) {
            final mission = missions[index];
            return _buildMissionCard(mission, provider);
          },
        );
      },
    );
  }

  Widget _buildWeeklyMissions(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        final missions = provider.weeklyMissions;

        if (missions.isEmpty) {
          return const Center(
            child: Text(
              '주간미션이 없습니다',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: missions.length,
          itemBuilder: (context, index) {
            final mission = missions[index];
            return _buildMissionCard(mission, provider);
          },
        );
      },
    );
  }

  Widget _buildMissionCard(Mission mission, GameProvider provider) {
    final progressPercent = mission.progressPercent.clamp(0.0, 1.0);

    return Card(
      color: const Color(0xFF0F0F1E),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    mission.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (mission.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '완료',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressPercent,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        mission.isCompleted ? Colors.green : Colors.cyan,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${mission.progress}/${mission.target}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _getRewardIcon(mission.reward.type),
                  color: _getRewardColor(mission.reward.type),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '보상: ${_getRewardText(mission.reward)}',
                  style: TextStyle(
                    color: _getRewardColor(mission.reward.type),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (mission.isCompleted)
                  ElevatedButton(
                    onPressed: () async {
                      await provider.claimMissionReward(mission.id, mission.isDaily);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text(
                      '보상 받기',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRewardIcon(MissionRewardType type) {
    switch (type) {
      case MissionRewardType.exp:
        return Icons.star;
      case MissionRewardType.gold:
        return Icons.monetization_on;
      case MissionRewardType.rebirthPoint:
        return Icons.stars;
      case MissionRewardType.artifactBox:
        return Icons.inventory_2;
    }
  }

  Color _getRewardColor(MissionRewardType type) {
    switch (type) {
      case MissionRewardType.exp:
        return Colors.amber;
      case MissionRewardType.gold:
        return Colors.yellow;
      case MissionRewardType.rebirthPoint:
        return Colors.cyan;
      case MissionRewardType.artifactBox:
        return Colors.purple;
    }
  }

  String _getRewardText(MissionReward reward) {
    switch (reward.type) {
      case MissionRewardType.exp:
        return '경험치 ${reward.amount}';
      case MissionRewardType.gold:
        return '골드 ${reward.amount}';
      case MissionRewardType.rebirthPoint:
        return '환생 포인트 ${reward.amount}';
      case MissionRewardType.artifactBox:
        return '유물 상자 ${reward.amount}개';
    }
  }
}

