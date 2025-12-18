enum MissionType {
  killPlanets, // 행성 터트리기
  clearStage, // 스테이지 클리어
  killBoss, // 보스 처치
  earnGold, // 골드 획득
  reachWave, // 웨이브 도달
}

enum MissionRewardType {
  exp,
  gold,
  rebirthPoint,
  artifactBox,
}

class MissionReward {
  final MissionRewardType type;
  final int amount;

  MissionReward({
    required this.type,
    required this.amount,
  });
}

class Mission {
  final String id;
  final MissionType type;
  final String description;
  final int target;
  int progress;
  final MissionReward reward;
  final bool isDaily; // true: 일일미션, false: 주간미션
  bool isCompleted;

  Mission({
    required this.id,
    required this.type,
    required this.description,
    required this.target,
    this.progress = 0,
    required this.reward,
    this.isDaily = true,
    this.isCompleted = false,
  });

  void updateProgress(int amount) {
    if (!isCompleted) {
      progress = (progress + amount).clamp(0, target);
      if (progress >= target) {
        isCompleted = true;
      }
    }
  }

  double get progressPercent => progress / target;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'progress': progress,
      'isCompleted': isCompleted,
    };
  }

  factory Mission.fromJson(Map<String, dynamic> json, MissionType type, bool isDaily) {
    return Mission(
      id: json['id'] ?? '',
      type: type,
      description: _getMissionDescription(type, json['target'] ?? 0),
      target: json['target'] ?? 0,
      progress: json['progress'] ?? 0,
      reward: _getMissionReward(type, isDaily),
      isDaily: isDaily,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  static String _getMissionDescription(MissionType type, int target) {
    switch (type) {
      case MissionType.killPlanets:
        return '행성 $target개 터트리기';
      case MissionType.clearStage:
        return '스테이지 $target개 클리어';
      case MissionType.killBoss:
        return '보스 $target명 처치';
      case MissionType.earnGold:
        return '골드 $target 획득';
      case MissionType.reachWave:
        return '웨이브 $target 도달';
    }
  }

  static MissionReward _getMissionReward(MissionType type, bool isDaily) {
    if (isDaily) {
      switch (type) {
        case MissionType.killPlanets:
          return MissionReward(type: MissionRewardType.exp, amount: 100);
        case MissionType.clearStage:
          return MissionReward(type: MissionRewardType.gold, amount: 500);
        case MissionType.killBoss:
          return MissionReward(type: MissionRewardType.rebirthPoint, amount: 1);
        case MissionType.earnGold:
          return MissionReward(type: MissionRewardType.exp, amount: 50);
        case MissionType.reachWave:
          return MissionReward(type: MissionRewardType.gold, amount: 300);
      }
    } else {
      // 주간미션 보상은 더 큼
      switch (type) {
        case MissionType.killPlanets:
          return MissionReward(type: MissionRewardType.exp, amount: 1000);
        case MissionType.clearStage:
          return MissionReward(type: MissionRewardType.gold, amount: 5000);
        case MissionType.killBoss:
          return MissionReward(type: MissionRewardType.rebirthPoint, amount: 5);
        case MissionType.earnGold:
          return MissionReward(type: MissionRewardType.exp, amount: 500);
        case MissionType.reachWave:
          return MissionReward(type: MissionRewardType.artifactBox, amount: 1);
      }
    }
  }

  Mission copyWith({
    int? progress,
    bool? isCompleted,
  }) {
    return Mission(
      id: id,
      type: type,
      description: description,
      target: target,
      progress: progress ?? this.progress,
      reward: reward,
      isDaily: isDaily,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

