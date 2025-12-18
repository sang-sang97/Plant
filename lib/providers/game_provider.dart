import 'dart:math';
import 'package:flutter/foundation.dart';
import '../core/models/user_data.dart';
import '../core/models/skill.dart';
import '../core/models/companion.dart';
import '../core/models/artifact.dart';
import '../core/models/stage_progress.dart';
import '../core/models/status_upgrade.dart';
import '../core/models/mission.dart';
import '../core/models/achievement_stats.dart';
import '../data/repositories/user_repository.dart';

class GameProvider with ChangeNotifier {
  final UserRepository _repository = UserRepository();

  UserData _userData = UserData();
  Map<SkillType, Skill> _skills = {};
  Map<String, Companion> _companions = {};
  List<Artifact> _artifacts = [];
  StageProgress _stageProgress = StageProgress();
  Map<StatusType, StatusUpgrade> _statusUpgrades = {};
  List<Mission> _dailyMissions = [];
  List<Mission> _weeklyMissions = [];
  AchievementStats _achievementStats = AchievementStats();
  Map<String, dynamic> _gameSettings = {
    'soundEnabled': true,
    'vibrationEnabled': true,
  };

  // Getters
  UserData get userData => _userData;
  Map<SkillType, Skill> get skills => _skills;
  Map<String, Companion> get companions => _companions;
  List<Artifact> get artifacts => _artifacts;
  StageProgress get stageProgress => _stageProgress;
  Map<StatusType, StatusUpgrade> get statusUpgrades => _statusUpgrades;
  List<Mission> get dailyMissions => _dailyMissions;
  List<Mission> get weeklyMissions => _weeklyMissions;
  AchievementStats get achievementStats => _achievementStats;
  Map<String, dynamic> get gameSettings => _gameSettings;

  bool get soundEnabled => _gameSettings['soundEnabled'] ?? true;
  bool get vibrationEnabled => _gameSettings['vibrationEnabled'] ?? true;

  // 초기화
  Future<void> init() async {
    await _repository.init();
    await loadAllData();
  }

  Future<void> loadAllData() async {
    _userData = await _repository.getUserData();
    _skills = await _repository.getSkills();
    _stageProgress = await _repository.getStageProgress();
    _statusUpgrades = await _repository.getStatusUpgrades();
    _artifacts = await _repository.getArtifacts();
    _achievementStats = await _repository.getAchievementStats();
    _gameSettings = await _repository.getGameSettings();
    _initializeSkills();
    _initializeStatusUpgrades();
    _initializeMissions();
    notifyListeners();
  }

  void _initializeSkills() {
    if (_skills.isEmpty) {
      _skills = {
        SkillType.doubleClick: Skill(
          type: SkillType.doubleClick,
          name: '더블 클릭',
          description: '3초 동안 다음 클릭이 2배 이상의 데미지를 줍니다',
          baseCost: 10,
        ),
        SkillType.timeStop: Skill(
          type: SkillType.timeStop,
          name: '시간 정지',
          description: '일정 시간 동안 행성 이동을 정지시킵니다',
          baseCost: 10,
        ),
        SkillType.chainLightning: Skill(
          type: SkillType.chainLightning,
          name: '연쇄 번개',
          description: '터치한 행성과 가장 가까운 행성도 함께 타격합니다',
          baseCost: 10,
        ),
      };
    }
  }

  void _initializeStatusUpgrades() {
    if (_statusUpgrades.isEmpty) {
      _statusUpgrades = {
        StatusType.attackPower: StatusUpgrade(
          type: StatusType.attackPower,
          name: '공격력',
        ),
        StatusType.criticalChance: StatusUpgrade(
          type: StatusType.criticalChance,
          name: '치명타 확률',
        ),
        StatusType.criticalDamage: StatusUpgrade(
          type: StatusType.criticalDamage,
          name: '치명타 피해율',
        ),
        StatusType.instantKill: StatusUpgrade(
          type: StatusType.instantKill,
          name: '즉사 확률',
        ),
      };
    }
  }

  void _initializeMissions() {
    // 일일미션 초기화 (실제로는 날짜 체크 필요)
    if (_dailyMissions.isEmpty) {
      _dailyMissions = [
        Mission(
          id: 'daily_1',
          type: MissionType.killPlanets,
          description: '행성 50개 터트리기',
          target: 50,
          reward: MissionReward(type: MissionRewardType.exp, amount: 100),
          isDaily: true,
        ),
        Mission(
          id: 'daily_2',
          type: MissionType.clearStage,
          description: '스테이지 1개 클리어',
          target: 1,
          reward: MissionReward(type: MissionRewardType.gold, amount: 500),
          isDaily: true,
        ),
        Mission(
          id: 'daily_3',
          type: MissionType.killBoss,
          description: '보스 1명 처치',
          target: 1,
          reward: MissionReward(type: MissionRewardType.rebirthPoint, amount: 1),
          isDaily: true,
        ),
      ];
    }

    // 주간미션 초기화
    if (_weeklyMissions.isEmpty) {
      _weeklyMissions = [
        Mission(
          id: 'weekly_1',
          type: MissionType.killPlanets,
          description: '총 행성 500개 터트리기',
          target: 500,
          reward: MissionReward(type: MissionRewardType.exp, amount: 1000),
          isDaily: false,
        ),
        Mission(
          id: 'weekly_2',
          type: MissionType.clearStage,
          description: '스테이지 5개 클리어',
          target: 5,
          reward: MissionReward(type: MissionRewardType.gold, amount: 5000),
          isDaily: false,
        ),
      ];
    }
  }

  // UserData 업데이트
  Future<void> updateUserData(UserData userData) async {
    _userData = userData;
    await _repository.saveUserData(userData);
    notifyListeners();
  }

  // 골드 추가
  Future<void> addGold(int amount) async {
    _userData = _userData.copyWith(gold: _userData.gold + amount);
    await _repository.saveUserData(_userData);
    notifyListeners();
  }

  // 경험치 추가
  Future<void> addExp(int amount) async {
    _userData = _userData.copyWith(exp: _userData.exp + amount);
    while (_userData.canLevelUp()) {
      _userData.levelUp();
    }
    await _repository.saveUserData(_userData);
    notifyListeners();
  }

  // 스킬 구매/업그레이드
  Future<void> purchaseSkill(SkillType type) async {
    final skill = _skills[type]!;
    if (skill.level == 0) {
      // 구매
      if (_userData.rebirthPoints >= skill.baseCost) {
        _userData = _userData.copyWith(
            rebirthPoints: _userData.rebirthPoints - skill.baseCost);
        _skills[type] = skill.copyWith(level: 1);
      }
    } else {
      // 업그레이드
      if (_userData.rebirthPoints >= skill.upgradeCost) {
        _userData = _userData.copyWith(
            rebirthPoints: _userData.rebirthPoints - skill.upgradeCost);
        _skills[type] = skill.copyWith(level: skill.level + 1);
      }
    }
    await _repository.saveUserData(_userData);
    await _repository.saveSkills(_skills);
    notifyListeners();
  }

  // 게임 설정 업데이트
  Future<void> updateGameSettings(String key, dynamic value) async {
    _gameSettings[key] = value;
    await _repository.saveGameSettings(_gameSettings);
    notifyListeners();
  }

  // 튜토리얼 완료
  Future<void> completeTutorial() async {
    _userData = _userData.copyWith(tutorialCompleted: true);
    await _repository.saveUserData(_userData);
    notifyListeners();
  }

  // 환생 로직
  Future<void> performRebirth() async {
    if (_userData.level <= 1) return;

    final rebirthPoints = _userData.level;
    final artifactBoxes = _userData.level ~/ 10;

    // 환생 포인트 추가
    _userData = _userData.copyWith(
      rebirthPoints: _userData.rebirthPoints + rebirthPoints,
      level: 1,
      exp: 0,
      gold: 0,
    );

    // 동료 초기화
    _companions.clear();
    await _repository.saveCompanions(_companions);

    // 상태 강화 초기화
    _statusUpgrades.forEach((type, upgrade) {
      _statusUpgrades[type] = upgrade.copyWith(level: 0);
    });
    await _repository.saveStatusUpgrades(_statusUpgrades);

    // 유물 상자 추가
    for (int i = 0; i < artifactBoxes; i++) {
      await openArtifactBox();
    }

    await _repository.saveUserData(_userData);
    notifyListeners();
  }

  // 상태 강화
  Future<void> upgradeStatus(StatusType type) async {
    final upgrade = _statusUpgrades[type]!;
    final cost = upgrade.upgradeCost;
    final maxLevel = _getMaxStatusLevel(type);

    if (!upgrade.canUpgrade(maxLevel) || _userData.gold < cost) {
      return;
    }

    _userData = _userData.copyWith(gold: _userData.gold - cost);
    _statusUpgrades[type] = upgrade.copyWith(level: upgrade.level + 1);

    await _repository.saveUserData(_userData);
    await _repository.saveStatusUpgrades(_statusUpgrades);
    notifyListeners();
  }

  int _getMaxStatusLevel(StatusType type) {
    switch (type) {
      case StatusType.attackPower:
        return 100;
      case StatusType.criticalChance:
        return 100;
      case StatusType.criticalDamage:
        return 1000;
      case StatusType.instantKill:
        return 50;
    }
  }

  // 동료 구매
  Future<void> purchaseCompanion(String companionId, CompanionType type) async {
    // 동료 목록에서 가져오거나 새로 생성
    Companion? companion = _companions[companionId];
    if (companion == null) {
      final index = int.tryParse(companionId.split('_').last) ?? 1;
      final baseCost = (1000 * pow(1.5, index - 1)).round();
      companion = Companion(
        id: companionId,
        type: type,
        name: type == CompanionType.attacker
            ? '공격형 동료 $index'
            : '회복형 동료 $index',
        description: type == CompanionType.attacker
            ? '행성을 향해 공격합니다'
            : '20초마다 지구의 목숨을 회복합니다',
        baseCost: baseCost,
      );
    }

    if (_userData.gold < companion.baseCost) return;

    // 최대 배치 가능 수 체크
    final maxSlots = 3 + _getCompanionSlotBonus();
    final activeCompanions = _companions.values.where((c) => c.isPurchased).length;
    if (activeCompanions >= maxSlots) return;

    _userData = _userData.copyWith(gold: _userData.gold - companion.baseCost);
    _companions[companionId] = companion.copyWith(level: 1);

    await _repository.saveUserData(_userData);
    await _repository.saveCompanions(_companions);
    notifyListeners();
  }

  // 동료 업그레이드
  Future<void> upgradeCompanion(String companionId) async {
    final companion = _companions[companionId];
    if (companion == null || !companion.isPurchased) return;

    final cost = companion.upgradeCost;
    if (_userData.gold < cost) return;

    _userData = _userData.copyWith(gold: _userData.gold - cost);
    _companions[companionId] = companion.copyWith(level: companion.level + 1);

    await _repository.saveUserData(_userData);
    await _repository.saveCompanions(_companions);
    notifyListeners();
  }

  // 동료 슬롯 보너스 (유물에서)
  int _getCompanionSlotBonus() {
    int bonus = 0;
    for (final artifact in _artifacts) {
      if (artifact.type == ArtifactType.companionSlot) {
        bonus += artifact.level.toInt();
      }
    }
    return bonus.clamp(0, 2); // 최대 2개 추가
  }

  // 미션 진행도 업데이트
  Future<void> updateMissionProgress(MissionType type, int amount) async {
    bool updated = false;

    for (final mission in _dailyMissions) {
      if (mission.type == type && !mission.isCompleted) {
        mission.updateProgress(amount);
        updated = true;
      }
    }

    for (final mission in _weeklyMissions) {
      if (mission.type == type && !mission.isCompleted) {
        mission.updateProgress(amount);
        updated = true;
      }
    }

    if (updated) {
      notifyListeners();
    }
  }

  // 미션 보상 수령
  Future<void> claimMissionReward(String missionId, bool isDaily) async {
    final missions = isDaily ? _dailyMissions : _weeklyMissions;
    final mission = missions.firstWhere((m) => m.id == missionId);

    if (!mission.isCompleted || mission.progress < mission.target) {
      return;
    }

    final reward = mission.reward;
    switch (reward.type) {
      case MissionRewardType.exp:
        await addExp(reward.amount);
        break;
      case MissionRewardType.gold:
        await addGold(reward.amount);
        break;
      case MissionRewardType.rebirthPoint:
        _userData = _userData.copyWith(
          rebirthPoints: _userData.rebirthPoints + reward.amount,
        );
        await _repository.saveUserData(_userData);
        break;
      case MissionRewardType.artifactBox:
        for (int i = 0; i < reward.amount; i++) {
          await openArtifactBox();
        }
        break;
    }

    // 미션 완료 처리 (보상 수령 후 미션 초기화는 일일/주간 리셋에서)
    notifyListeners();
  }

  // 유물 상자 열기
  Future<void> openArtifactBox() async {
    final random = DateTime.now().millisecondsSinceEpoch % ArtifactType.values.length;
    final artifactType = ArtifactType.values[random];

    // 같은 타입의 유물이 있으면 레벨업, 없으면 새로 추가
    final existingIndex = _artifacts.indexWhere((a) => a.type == artifactType);
    
    if (existingIndex >= 0) {
      _artifacts[existingIndex] = _artifacts[existingIndex].copyWith(
        level: _artifacts[existingIndex].level + 1,
      );
    } else {
      final artifactNames = {
        ArtifactType.attackPower: '공격력 증가',
        ArtifactType.criticalChance: '치명타 확률',
        ArtifactType.criticalDamage: '치명타 피해',
        ArtifactType.instantKill: '즉사 확률',
        ArtifactType.companionAttackPower: '동료 공격력',
        ArtifactType.companionSlot: '동료 슬롯',
        ArtifactType.skillCooldown: '스킬 쿨타임 감소',
        ArtifactType.goldGain: '골드 획득량',
        ArtifactType.expGain: '경험치 획득량',
      };
      
      final artifactDescriptions = {
        ArtifactType.attackPower: '공격력이 증가합니다',
        ArtifactType.criticalChance: '치명타 확률이 증가합니다',
        ArtifactType.criticalDamage: '치명타 피해율이 증가합니다',
        ArtifactType.instantKill: '즉사 확률이 증가합니다',
        ArtifactType.companionAttackPower: '동료의 공격력이 증가합니다',
        ArtifactType.companionSlot: '동료 배치 슬롯이 증가합니다',
        ArtifactType.skillCooldown: '스킬 쿨타임이 감소합니다',
        ArtifactType.goldGain: '골드 획득량이 증가합니다',
        ArtifactType.expGain: '경험치 획득량이 증가합니다',
      };
      
      _artifacts.add(Artifact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: artifactType,
        name: artifactNames[artifactType] ?? '유물',
        description: artifactDescriptions[artifactType] ?? '효과가 있습니다',
      ));
    }


    await _repository.saveArtifacts(_artifacts);
    notifyListeners();
  }

  // 일일던전 입장 횟수 체크
  int _dailyDungeonEntries = 0;
  DateTime? _lastDailyDungeonReset;

  bool canEnterDailyDungeon() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastDailyDungeonReset == null ||
        DateTime(_lastDailyDungeonReset!.year, _lastDailyDungeonReset!.month, _lastDailyDungeonReset!.day) != today) {
      _dailyDungeonEntries = 0;
      _lastDailyDungeonReset = now;
    }

    return _dailyDungeonEntries < 3;
  }

  void useDailyDungeonEntry() {
    if (canEnterDailyDungeon()) {
      _dailyDungeonEntries++;
    }
  }

  int get remainingDailyDungeonEntries {
    canEnterDailyDungeon(); // 리셋 체크
    return 3 - _dailyDungeonEntries;
  }
}

