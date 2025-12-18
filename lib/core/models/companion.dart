enum CompanionType {
  attacker,
  healer,
}

class Companion {
  final String id;
  final CompanionType type;
  final String name;
  final String description;
  int level;
  final int baseCost; // 골드

  Companion({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    this.level = 0,
    required this.baseCost,
  });

  bool get isPurchased => level > 0;

  int get upgradeCost => level * 500; // 레벨당 500 골드

  // 공격형: 레벨당 공격력 +10% (레벨 1 = 100%, 레벨 2 = 110%, 레벨 3 = 120%)
  double get attackPowerMultiplier {
    if (type == CompanionType.attacker) {
      return 1.0 + (level - 1) * 0.1;
    }
    return 0.0;
  }

  // 공격 속도: 레벨 1 = 3초, 최대 레벨 = 1초 (레벨당 -0.1초)
  double get attackSpeed {
    if (type == CompanionType.attacker) {
      return (3.0 - (level - 1) * 0.1).clamp(1.0, 3.0);
    }
    return 0.0;
  }

  // 회복형: 20초마다 목숨 1개 회복
  double get healInterval => 20.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
    };
  }

  factory Companion.fromJson(Map<String, dynamic> json, String id, CompanionType type) {
    return Companion(
      id: id,
      type: type,
      level: json['level'] ?? 0,
      name: _getCompanionName(id, type),
      description: _getCompanionDescription(type),
      baseCost: _getCompanionCost(id),
    );
  }

  static String _getCompanionName(String id, CompanionType type) {
    if (type == CompanionType.attacker) {
      return '공격형 동료 ${id}';
    } else {
      return '회복형 동료 ${id}';
    }
  }

  static String _getCompanionDescription(CompanionType type) {
    switch (type) {
      case CompanionType.attacker:
        return '행성을 향해 공격합니다';
      case CompanionType.healer:
        return '20초마다 지구의 목숨을 회복합니다';
    }
  }

  static int _getCompanionCost(String id) {
    // 첫 동료 1000, 이후 1.5배씩 증가
    int index = int.tryParse(id) ?? 0;
    return (1000 * (1.5 * index)).round();
  }

  Companion copyWith({int? level}) {
    return Companion(
      id: id,
      type: type,
      name: name,
      description: description,
      level: level ?? this.level,
      baseCost: baseCost,
    );
  }
}

