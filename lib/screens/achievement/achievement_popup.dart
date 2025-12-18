import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class AchievementPopup extends StatelessWidget {
  const AchievementPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.yellow.withValues(alpha: 0.3), width: 2),
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
                  '업적',
                  style: TextStyle(
                    color: Colors.yellow,
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
              child: Consumer<GameProvider>(
                builder: (context, provider, child) {
                  final stats = provider.achievementStats;

                  return ListView(
                    children: [
                      _buildStatCard(
                        Icons.access_time,
                        '총 플레이 시간',
                        _formatDuration(stats.totalPlayTime),
                        Colors.blue,
                      ),
                      _buildStatCard(
                        Icons.auto_awesome,
                        '파괴한 일반 행성 수',
                        '${stats.totalPlanetsKilled}',
                        Colors.orange,
                      ),
                      _buildStatCard(
                        Icons.dangerous,
                        '파괴한 보스 수',
                        '${stats.totalBossesKilled}',
                        Colors.red,
                      ),
                      _buildStatCard(
                        Icons.flag,
                        '클리어한 스테이지 수',
                        '${stats.totalStagesCleared}',
                        Colors.green,
                      ),
                      _buildStatCard(
                        Icons.refresh,
                        '환생 횟수',
                        '${stats.totalRebirths}',
                        Colors.purple,
                      ),
                      _buildStatCard(
                        Icons.inventory_2,
                        '획득한 유물 수',
                        '${stats.totalArtifactsObtained}',
                        Colors.amber,
                      ),
                      _buildStatCard(
                        Icons.all_inclusive,
                        '최고 무한모드 웨이브',
                        '${stats.bestInfiniteWave}',
                        Colors.cyan,
                      ),
                      _buildStatCard(
                        Icons.monetization_on,
                        '총 획득 골드',
                        '${stats.totalGoldEarned}',
                        Colors.yellow,
                      ),
                      _buildStatCard(
                        Icons.star,
                        '총 획득 경험치',
                        '${stats.totalExpEarned}',
                        Colors.amber,
                      ),
                      _buildStatCard(
                        Icons.people,
                        '동료가 처치한 행성 수',
                        '${stats.companionKills}',
                        Colors.blue,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color color) {
    return Card(
      color: const Color(0xFF0F0F1E),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}시간 ${minutes}분 ${seconds}초';
    } else if (minutes > 0) {
      return '${minutes}분 ${seconds}초';
    } else {
      return '${seconds}초';
    }
  }
}

