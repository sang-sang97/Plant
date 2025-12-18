class StageProgress {
  int currentStage;
  Set<int> unlockedStages;

  StageProgress({
    this.currentStage = 1,
    Set<int>? unlockedStages,
  }) : unlockedStages = unlockedStages ?? {1};

  void unlockStage(int stage) {
    unlockedStages.add(stage);
    if (stage > currentStage) {
      currentStage = stage;
    }
  }

  bool isStageUnlocked(int stage) {
    return unlockedStages.contains(stage);
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStage': currentStage,
      'unlockedStages': unlockedStages.toList(),
    };
  }

  factory StageProgress.fromJson(Map<String, dynamic> json) {
    return StageProgress(
      currentStage: json['currentStage'] ?? 1,
      unlockedStages: (json['unlockedStages'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toSet() ??
          {1},
    );
  }

  StageProgress copyWith({
    int? currentStage,
    Set<int>? unlockedStages,
  }) {
    return StageProgress(
      currentStage: currentStage ?? this.currentStage,
      unlockedStages: unlockedStages ?? this.unlockedStages,
    );
  }
}

