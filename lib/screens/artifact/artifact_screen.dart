import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../core/models/artifact.dart';

class ArtifactScreen extends StatelessWidget {
  const ArtifactScreen({super.key});

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
                  '유물',
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
                final artifacts = provider.artifacts;

                if (artifacts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2,
                          size: 80,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '보유한 유물이 없습니다',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '환생 시 유물 상자를 획득할 수 있습니다',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
            padding: const EdgeInsets.all(16),
            children: artifacts.map((artifact) {
              return _buildArtifactCard(artifact);
            }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtifactCard(Artifact artifact) {
    return Card(
      color: const Color(0xFF1A1A2E),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getArtifactColor(artifact.type).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getArtifactColor(artifact.type),
                  width: 2,
                ),
              ),
              child: Icon(
                _getArtifactIcon(artifact.type),
                color: _getArtifactColor(artifact.type),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        artifact.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Lv.${artifact.level}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artifact.description,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getArtifactColor(artifact.type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '효과: +${artifact.effectValue.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: _getArtifactColor(artifact.type),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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

  IconData _getArtifactIcon(ArtifactType type) {
    switch (type) {
      case ArtifactType.attackPower:
        return Icons.auto_awesome;
      case ArtifactType.criticalChance:
        return Icons.crisis_alert;
      case ArtifactType.criticalDamage:
        return Icons.whatshot;
      case ArtifactType.instantKill:
        return Icons.dangerous;
      case ArtifactType.companionAttackPower:
        return Icons.people;
      case ArtifactType.companionSlot:
        return Icons.add_circle;
      case ArtifactType.skillCooldown:
        return Icons.timer;
      case ArtifactType.goldGain:
        return Icons.monetization_on;
      case ArtifactType.expGain:
        return Icons.star;
    }
  }

  Color _getArtifactColor(ArtifactType type) {
    switch (type) {
      case ArtifactType.attackPower:
        return Colors.red;
      case ArtifactType.criticalChance:
        return Colors.orange;
      case ArtifactType.criticalDamage:
        return Colors.deepOrange;
      case ArtifactType.instantKill:
        return Colors.purple;
      case ArtifactType.companionAttackPower:
        return Colors.blue;
      case ArtifactType.companionSlot:
        return Colors.green;
      case ArtifactType.skillCooldown:
        return Colors.cyan;
      case ArtifactType.goldGain:
        return Colors.amber;
      case ArtifactType.expGain:
        return Colors.yellow;
    }
  }
}

