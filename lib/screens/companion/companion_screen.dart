import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../core/models/companion.dart';

class CompanionScreen extends StatelessWidget {
  const CompanionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A2E),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  '동료',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, provider, child) {
                final userData = provider.userData;
                final companions = provider.companions;

                // 동료 목록 생성 (임시로 5개)
                final companionList = List.generate(5, (index) {
                  final id = 'companion_${index + 1}';
                  final type = index < 3 ? CompanionType.attacker : CompanionType.healer;
                  return companions[id] ?? Companion(
                    id: id,
                    type: type,
                    name: type == CompanionType.attacker
                        ? '공격형 동료 ${index + 1}'
                        : '회복형 동료 ${index + 1}',
                    description: type == CompanionType.attacker
                        ? '행성을 향해 공격합니다'
                        : '20초마다 지구의 목숨을 회복합니다',
                    baseCost: _getCompanionCost(id),
                  );
                });

                return ListView(
            padding: const EdgeInsets.all(16),
            children: companionList.map((companion) {
              return _buildCompanionCard(context, companion, userData, provider);
            }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanionCard(
    BuildContext context,
    Companion companion,
    userData,
    GameProvider provider,
  ) {
    final canPurchase = !companion.isPurchased && userData.gold >= companion.baseCost;
    final canUpgrade = companion.isPurchased && userData.gold >= companion.upgradeCost;

    return Card(
      color: const Color(0xFF1A1A2E),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  companion.type == CompanionType.attacker
                      ? Icons.auto_awesome
                      : Icons.favorite,
                  color: companion.type == CompanionType.attacker
                      ? Colors.orange
                      : Colors.red,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companion.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        companion.description,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (companion.isPurchased) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text(
                      '레벨: ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '${companion.level}',
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (companion.type == CompanionType.attacker) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '공격력: ${(companion.attackPowerMultiplier * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '공격 속도: ${companion.attackSpeed.toStringAsFixed(1)}초',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '회복 주기: ${companion.healInterval.toStringAsFixed(0)}초',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: canPurchase || canUpgrade
                  ? () async {
                      if (!companion.isPurchased) {
                        // 구매
                        await provider.purchaseCompanion(companion.id, companion.type);
                      } else {
                        // 업그레이드
                        await provider.upgradeCompanion(companion.id);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canPurchase || canUpgrade
                    ? (companion.type == CompanionType.attacker
                        ? Colors.orange
                        : Colors.red)
                    : Colors.grey,
                minimumSize: const Size(double.infinity, 40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    companion.isPurchased
                        ? '레벨업 (${companion.upgradeCost} 골드)'
                        : '구매 (${companion.baseCost} 골드)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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

  static int _getCompanionCost(String id) {
    // 첫 동료 1000, 이후 1.5배씩 증가
    final index = int.tryParse(id.split('_').last) ?? 0;
    return (1000 * (1.5 * (index - 1))).round().clamp(1000, 100000);
  }
}

