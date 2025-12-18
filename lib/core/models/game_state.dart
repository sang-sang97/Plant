class GameState {
  int currentWave;
  int currentStage;
  int earthLives; // 목숨 3개
  int score;
  bool isPaused;
  bool isGameOver;
  bool isVictory;
  DateTime? gameStartTime;

  GameState({
    this.currentWave = 1,
    this.currentStage = 1,
    this.earthLives = 3,
    this.score = 0,
    this.isPaused = false,
    this.isGameOver = false,
    this.isVictory = false,
    this.gameStartTime,
  });

  void reset() {
    currentWave = 1;
    earthLives = 3;
    score = 0;
    isPaused = false;
    isGameOver = false;
    isVictory = false;
    gameStartTime = DateTime.now();
  }

  void loseLife() {
    if (earthLives > 0) {
      earthLives--;
      if (earthLives <= 0) {
        isGameOver = true;
      }
    }
  }

  void nextWave() {
    currentWave++;
    if (currentWave > 3) {
      // 웨이브 3개 클리어 시 보스 등장
      // 보스 처치 시 isVictory = true
    }
  }

  GameState copyWith({
    int? currentWave,
    int? currentStage,
    int? earthLives,
    int? score,
    bool? isPaused,
    bool? isGameOver,
    bool? isVictory,
    DateTime? gameStartTime,
  }) {
    return GameState(
      currentWave: currentWave ?? this.currentWave,
      currentStage: currentStage ?? this.currentStage,
      earthLives: earthLives ?? this.earthLives,
      score: score ?? this.score,
      isPaused: isPaused ?? this.isPaused,
      isGameOver: isGameOver ?? this.isGameOver,
      isVictory: isVictory ?? this.isVictory,
      gameStartTime: gameStartTime ?? this.gameStartTime,
    );
  }
}

