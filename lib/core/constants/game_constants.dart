class GameConstants {
  // 지구 설정
  static const double earthHeightRatio = 0.1; // 화면 높이의 1/10
  static const int maxEarthLives = 3;

  // 행성 스폰 설정
  static const double spawnInterval = 2.0; // 2초마다
  static const int minSpawnCount = 3;
  static const int maxSpawnCount = 5;
  static const int minPlanetCount = 2; // 2개 이하가 되면 추가 스폰

  // 행성 속도
  static const double waveSpeedMultiplier = 1.2; // 웨이브마다 1.2배

  // 행성 체력
  static const double waveHealthMultiplier = 1.2; // 웨이브마다 20% 증가
  static const double bossHealthMultiplier = 50.0; // 보스 체력 = 3웨이브 행성의 50배

  // 스테이지 난이도
  static const double stageDifficultyMultiplier = 1.5; // 스테이지마다 1.5배

  // 동료 설정
  static const int baseCompanionSlots = 3;
  static const int maxCompanionSlots = 5;

  // 스킬 쿨타임
  static const double skillCooldown = 10.0; // 10초

  // 더블클릭 지속시간
  static const double doubleClickDuration = 3.0; // 3초

  // 시간정지 기본 지속시간
  static const double timeStopBaseDuration = 2.0; // 2초

  // 연쇄클릭 지속시간
  static const double chainLightningDuration = 3.0; // 3초

  // 동료 공격 속도
  static const double companionBaseAttackSpeed = 3.0; // 3초
  static const double companionMinAttackSpeed = 1.0; // 최소 1초

  // 동료 회복 주기
  static const double companionHealInterval = 20.0; // 20초

  // 일일던전
  static const int dailyDungeonMaxEntries = 3; // 하루 3회
  static const int expDungeonDuration = 60; // 60초

  // 무한모드 랭킹
  static const int maxRankingEntries = 10; // 상위 10명

  // 개발자 모드
  static const int developerModeClickCount = 7; // 7번 연속 클릭
}

