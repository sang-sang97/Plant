import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../core/models/skill.dart';

class SkillScreen extends StatelessWidget {
  const SkillScreen({super.key});

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
                  '스킬',
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
                final skills = provider.skills;
                final userData = provider.userData;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: SkillType.values.map((type) {
                    final skill = skills[type] ?? Skill(
                      type: type,
                      name: _getSkillName(type),
                      description: _getSkillDescription(type),
                      baseCost: 10,
                    );

                    return _buildSkillCard(context, skill, userData, provider);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(
    BuildContext context,
    Skill skill,
    userData,
    GameProvider provider,
  ) {
    final canPurchase = !skill.isPurchased && userData.rebirthPoints >= skill.baseCost;
    final canUpgrade = skill.isPurchased && userData.rebirthPoints >= skill.upgradeCost;

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
                  _getSkillIcon(skill.type),
                  color: _getSkillColor(skill.type),
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skill.description,
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
            if (skill.isPurchased) ...[
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
                      '${skill.level}',
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
              _buildSkillEffect(skill),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: canPurchase || canUpgrade
                  ? () async {
                      await provider.purchaseSkill(skill.type);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canPurchase || canUpgrade
                    ? _getSkillColor(skill.type)
                    : Colors.grey,
                minimumSize: const Size(double.infinity, 40),
              ),
              child: Text(
                skill.isPurchased
                    ? '레벨업 (${skill.upgradeCost} 포인트)'
                    : '구매 (${skill.baseCost} 포인트)',
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

  Widget _buildSkillEffect(Skill skill) {
    String effectText = '';
    switch (skill.type) {
      case SkillType.doubleClick:
        effectText = '데미지 배수: ${skill.doubleClickMultiplier.toStringAsFixed(1)}배';
        break;
      case SkillType.timeStop:
        effectText = '지속시간: ${skill.timeStopDuration.toStringAsFixed(1)}초';
        break;
      case SkillType.chainLightning:
        effectText = '연쇄 타격: ${skill.chainLightningCount}개';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        effectText,
        style: const TextStyle(
          color: Colors.amber,
          fontSize: 14,
        ),
      ),
    );
  }

  IconData _getSkillIcon(SkillType type) {
    switch (type) {
      case SkillType.doubleClick:
        return Icons.touch_app;
      case SkillType.timeStop:
        return Icons.pause_circle;
      case SkillType.chainLightning:
        return Icons.bolt;
    }
  }

  Color _getSkillColor(SkillType type) {
    switch (type) {
      case SkillType.doubleClick:
        return Colors.purple;
      case SkillType.timeStop:
        return Colors.blue;
      case SkillType.chainLightning:
        return Colors.yellow;
    }
  }

  String _getSkillName(SkillType type) {
    switch (type) {
      case SkillType.doubleClick:
        return '더블 클릭';
      case SkillType.timeStop:
        return '시간 정지';
      case SkillType.chainLightning:
        return '연쇄 번개';
    }
  }

  String _getSkillDescription(SkillType type) {
    switch (type) {
      case SkillType.doubleClick:
        return '3초 동안 다음 클릭이 2배 이상의 데미지를 줍니다';
      case SkillType.timeStop:
        return '일정 시간 동안 행성 이동을 정지시킵니다';
      case SkillType.chainLightning:
        return '터치한 행성과 가장 가까운 행성도 함께 타격합니다';
    }
  }
}

