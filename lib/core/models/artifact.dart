enum ArtifactType {
  attackPower, // 공격력 증가
  criticalChance, // 치명타 확률 증가
  criticalDamage, // 치명타 피해율 증가
  instantKill, // 즉사 확률 증가
  companionAttackPower, // 동료 공격력 증가
  companionSlot, // 동료 배치 슬롯 증가
  skillCooldown, // 스킬 쿨타임 감소
  goldGain, // 골드 획득량 증가
  expGain, // 경험치 획득량 증가
}

class Artifact {
  final String id;
  final ArtifactType type;
  int level;
  final String name;
  final String description;

  Artifact({
    required this.id,
    required this.type,
    this.level = 1,
    required this.name,
    required this.description,
  });

  // 효과 값 계산 (레벨에 따라 증가)
  double get effectValue {
    double baseValue = _getBaseValue(type);
    return baseValue * level;
  }

  static double _getBaseValue(ArtifactType type) {
    switch (type) {
      case ArtifactType.attackPower:
        return 5.0; // 5% per level
      case ArtifactType.criticalChance:
        return 2.0; // 2% per level
      case ArtifactType.criticalDamage:
        return 10.0; // 10% per level
      case ArtifactType.instantKill:
        return 1.0; // 1% per level
      case ArtifactType.companionAttackPower:
        return 10.0; // 10% per level
      case ArtifactType.companionSlot:
        return 1.0; // +1 slot per level (max 2 levels)
      case ArtifactType.skillCooldown:
        return 5.0; // -5% per level
      case ArtifactType.goldGain:
        return 10.0; // 10% per level
      case ArtifactType.expGain:
        return 10.0; // 10% per level
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'level': level,
    };
  }

  factory Artifact.fromJson(Map<String, dynamic> json) {
    return Artifact(
      id: json['id'] ?? '',
      type: ArtifactType.values[json['type'] ?? 0],
      level: json['level'] ?? 1,
      name: _getArtifactName(json['type'] ?? 0),
      description: _getArtifactDescription(json['type'] ?? 0),
    );
  }

  static String _getArtifactName(int typeIndex) {
    final type = ArtifactType.values[typeIndex];
    switch (type) {
      case ArtifactType.attackPower:
        return '공격력 증가';
      case ArtifactType.criticalChance:
        return '치명타 확률';
      case ArtifactType.criticalDamage:
        return '치명타 피해';
      case ArtifactType.instantKill:
        return '즉사 확률';
      case ArtifactType.companionAttackPower:
        return '동료 공격력';
      case ArtifactType.companionSlot:
        return '동료 슬롯';
      case ArtifactType.skillCooldown:
        return '스킬 쿨타임 감소';
      case ArtifactType.goldGain:
        return '골드 획득량';
      case ArtifactType.expGain:
        return '경험치 획득량';
    }
  }

  static String _getArtifactDescription(int typeIndex) {
    final type = ArtifactType.values[typeIndex];
    switch (type) {
      case ArtifactType.attackPower:
        return '공격력이 증가합니다';
      case ArtifactType.criticalChance:
        return '치명타 확률이 증가합니다';
      case ArtifactType.criticalDamage:
        return '치명타 피해율이 증가합니다';
      case ArtifactType.instantKill:
        return '즉사 확률이 증가합니다';
      case ArtifactType.companionAttackPower:
        return '동료의 공격력이 증가합니다';
      case ArtifactType.companionSlot:
        return '동료 배치 슬롯이 증가합니다';
      case ArtifactType.skillCooldown:
        return '스킬 쿨타임이 감소합니다';
      case ArtifactType.goldGain:
        return '골드 획득량이 증가합니다';
      case ArtifactType.expGain:
        return '경험치 획득량이 증가합니다';
    }
  }

  Artifact copyWith({int? level}) {
    return Artifact(
      id: id,
      type: type,
      level: level ?? this.level,
      name: name,
      description: description,
    );
  }
}

