class UserData {
  int level;
  int exp;
  int gold;
  int rebirthPoints;
  bool tutorialCompleted;

  UserData({
    this.level = 1,
    this.exp = 0,
    this.gold = 0,
    this.rebirthPoints = 0,
    this.tutorialCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'exp': exp,
      'gold': gold,
      'rebirthPoints': rebirthPoints,
      'tutorialCompleted': tutorialCompleted,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      level: json['level'] ?? 1,
      exp: json['exp'] ?? 0,
      gold: json['gold'] ?? 0,
      rebirthPoints: json['rebirthPoints'] ?? 0,
      tutorialCompleted: json['tutorialCompleted'] ?? false,
    );
  }

  int get expToNextLevel => level * 100;

  bool canLevelUp() {
    return exp >= expToNextLevel;
  }

  void levelUp() {
    if (canLevelUp()) {
      exp -= expToNextLevel;
      level++;
    }
  }

  UserData copyWith({
    int? level,
    int? exp,
    int? gold,
    int? rebirthPoints,
    bool? tutorialCompleted,
  }) {
    return UserData(
      level: level ?? this.level,
      exp: exp ?? this.exp,
      gold: gold ?? this.gold,
      rebirthPoints: rebirthPoints ?? this.rebirthPoints,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
    );
  }
}

