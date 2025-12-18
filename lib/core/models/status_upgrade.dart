enum StatusType {
  attackPower,
  criticalChance,
  criticalDamage,
  instantKill,
}

class StatusUpgrade {
  final StatusType type;
  int level;
  final String name;

  StatusUpgrade({
    required this.type,
    this.level = 0,
    required this.name,
  });

  // 강화 비용: 레벨^1.5 * 100
  int get upgradeCost {
    return (level * 1.5 * 100).round();
  }

  // 증가량: 1-10레벨 +1, 11-20레벨 +2, 21-30레벨 +3, 31-40레벨 +4, 41-50레벨 +5
  int get increaseAmount {
    if (level <= 10) return 1;
    if (level <= 20) return 2;
    if (level <= 30) return 3;
    if (level <= 40) return 4;
    return 5;
  }

  int get totalValue {
    int total = 0;
    for (int i = 1; i <= level; i++) {
      if (i <= 10) total += 1;
      else if (i <= 20) total += 2;
      else if (i <= 30) total += 3;
      else if (i <= 40) total += 4;
      else total += 5;
    }
    return total;
  }

  bool canUpgrade(int maxLevel) {
    return level < maxLevel;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'level': level,
    };
  }

  factory StatusUpgrade.fromJson(Map<String, dynamic> json) {
    return StatusUpgrade(
      type: StatusType.values[json['type'] ?? 0],
      level: json['level'] ?? 0,
      name: _getStatusName(json['type'] ?? 0),
    );
  }

  static String _getStatusName(int typeIndex) {
    final type = StatusType.values[typeIndex];
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

  StatusUpgrade copyWith({int? level}) {
    return StatusUpgrade(
      type: type,
      level: level ?? this.level,
      name: name,
    );
  }
}

