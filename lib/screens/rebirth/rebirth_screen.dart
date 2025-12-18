import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class RebirthScreen extends StatelessWidget {
  const RebirthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          '환생',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          final userData = provider.userData;
          final rebirthPoints = userData.level; // 레벨 = 환생 포인트
          final artifactBoxes = userData.level ~/ 10; // 10레벨당 1개

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: const Color(0xFF1A1A2E),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '환생',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '현재 레벨: ${userData.level}',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                              const SizedBox(height: 8),
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
                                      fontSize: 20,
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  color: const Color(0xFF1A1A2E),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '주의사항',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildWarningItem('레벨, 경험치, 골드가 초기화됩니다'),
                        _buildWarningItem('동료가 초기화됩니다'),
                        _buildWarningItem('상태 강화 레벨이 초기화됩니다'),
                        const SizedBox(height: 12),
                        const Text(
                          '유지되는 항목',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildWarningItem('스테이지 진행도', isPositive: true),
                        _buildWarningItem('환생 포인트', isPositive: true),
                        _buildWarningItem('유물', isPositive: true),
                        _buildWarningItem('스킬 레벨', isPositive: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWarningItem(String text, {bool isPositive = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.check_circle : Icons.warning,
            color: isPositive ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isPositive ? Colors.green.shade300 : Colors.red.shade300,
                fontSize: 14,
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

