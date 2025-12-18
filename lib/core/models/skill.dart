enum SkillType {
  doubleClick,
  timeStop,
  chainLightning,
}

class Skill {
  final SkillType type;
  int level;
  final String name;
  final String description;
  final int baseCost; // 환생 포인트

  Skill({
    required this.type,
    this.level = 0,
    required this.name,
    required this.description,
    required this.baseCost,
  });

  bool get isPurchased => level > 0;

  int get upgradeCost => level * 5; // 레벨당 5 포인트

  // 더블클릭: 레벨 1 = 2.0배, 레벨 2 = 2.2배, 레벨 3 = 2.5배, 레벨 4 = 2.8배, 레벨 5 = 3.2배
  double get doubleClickMultiplier {
    if (level == 0) return 1.0;
    if (level == 1) return 2.0;
    if (level == 2) return 2.2;
    if (level == 3) return 2.5;
    if (level == 4) return 2.8;
    if (level == 5) return 3.2;
    return 3.2 + (level - 5) * 0.3;
  }

  // 시간정지: 레벨 1 = 2.0초, 레벨당 +0.2초
  double get timeStopDuration => 2.0 + (level - 1) * 0.2;

  // 연쇄클릭: 레벨 1 = 1개 추가 타격, 레벨당 +1개
  int get chainLightningCount => level;

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'level': level,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json, SkillType type) {
    return Skill(
      type: type,
      level: json['level'] ?? 0,
      name: _getSkillName(type),
      description: _getSkillDescription(type),
      baseCost: 10,
    );
  }

  static String _getSkillName(SkillType type) {
    switch (type) {
      case SkillType.doubleClick:
        return '더블 클릭';
      case SkillType.timeStop:
        return '시간 정지';
      case SkillType.chainLightning:
        return '연쇄 번개';
    }
  }

  static String _getSkillDescription(SkillType type) {
    switch (type) {
      case SkillType.doubleClick:
        return '3초 동안 다음 클릭이 2배 이상의 데미지를 줍니다';
      case SkillType.timeStop:
        return '일정 시간 동안 행성 이동을 정지시킵니다';
      case SkillType.chainLightning:
        return '터치한 행성과 가장 가까운 행성도 함께 타격합니다';
    }
  }

  Skill copyWith({int? level}) {
    return Skill(
      type: type,
      level: level ?? this.level,
      name: name,
      description: description,
      baseCost: baseCost,
    );
  }
}

