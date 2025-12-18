import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../core/models/status_upgrade.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

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
                  '능력치',
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
                final statusUpgrades = provider.statusUpgrades;
                final userData = provider.userData;

                return ListView(
            padding: const EdgeInsets.all(16),
            children: StatusType.values.map((type) {
              final upgrade = statusUpgrades[type] ?? StatusUpgrade(
                type: type,
                name: _getStatusName(type),
              );
              return _buildStatusCard(context, upgrade, userData, provider);
            }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    StatusUpgrade upgrade,
    userData,
    GameProvider provider,
  ) {
    final canUpgrade = upgrade.canUpgrade(50) && userData.gold >= upgrade.upgradeCost;

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
                  _getStatusIcon(upgrade.type),
                  color: _getStatusColor(upgrade.type),
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upgrade.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusDescription(upgrade.type),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 레벨: ${upgrade.level}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '총 증가량: +${upgrade.totalValue}',
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '강화 비용',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${upgrade.upgradeCost}',
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
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: canUpgrade
                  ? () async {
                      await provider.upgradeStatus(upgrade.type);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canUpgrade
                    ? _getStatusColor(upgrade.type)
                    : Colors.grey,
                minimumSize: const Size(double.infinity, 40),
              ),
              child: Text(
                upgrade.level >= 50
                    ? '최대 레벨'
                    : '강화하기',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(StatusType type) {
    switch (type) {
      case StatusType.attackPower:
        return Icons.auto_awesome;
      case StatusType.criticalChance:
        return Icons.crisis_alert;
      case StatusType.criticalDamage:
        return Icons.whatshot;
      case StatusType.instantKill:
        return Icons.dangerous;
    }
  }

  Color _getStatusColor(StatusType type) {
    switch (type) {
      case StatusType.attackPower:
        return Colors.red;
      case StatusType.criticalChance:
        return Colors.orange;
      case StatusType.criticalDamage:
        return Colors.deepOrange;
      case StatusType.instantKill:
        return Colors.purple;
    }
  }

  String _getStatusDescription(StatusType type) {
    switch (type) {
      case StatusType.attackPower:
        return '기본 공격력을 증가시킵니다';
      case StatusType.criticalChance:
        return '치명타 확률을 증가시킵니다 (최대 100%)';
      case StatusType.criticalDamage:
        return '치명타 피해율을 증가시킵니다';
      case StatusType.instantKill:
        return '즉사 확률을 증가시킵니다 (최대 50%)';
    }
  }

  String _getStatusName(StatusType type) {
    switch (type) {
      case StatusType.attackPower:
        return '공격력';
      case StatusType.criticalChance:
        return '치명타 확률';
      case StatusType.criticalDamage:
        return '치명타 피해율';
      case StatusType.instantKill:
        return '즉사 확률';
    }
  }
}

