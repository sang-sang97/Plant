import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/user_data.dart';
import '../../core/models/skill.dart';
import '../../core/models/companion.dart';
import '../../core/models/artifact.dart';
import '../../core/models/stage_progress.dart';
import '../../core/models/status_upgrade.dart';
import '../../core/models/mission.dart';
import '../../core/models/achievement_stats.dart';
import '../local_storage/storage_keys.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // UserData
  Future<void> saveUserData(UserData userData) async {
    await init();
    await _prefs!.setString(StorageKeys.userData, jsonEncode(userData.toJson()));
  }

  Future<UserData> getUserData() async {
    await init();
    final data = _prefs!.getString(StorageKeys.userData);
    if (data != null) {
      return UserData.fromJson(jsonDecode(data));
    }
    return UserData();
  }

  // Skills
  Future<void> saveSkills(Map<SkillType, Skill> skills) async {
    await init();
    final Map<String, dynamic> data = {};
    skills.forEach((type, skill) {
      data[type.index.toString()] = skill.toJson();
    });
    await _prefs!.setString(StorageKeys.skills, jsonEncode(data));
  }

  Future<Map<SkillType, Skill>> getSkills() async {
    await init();
    final data = _prefs!.getString(StorageKeys.skills);
    if (data != null) {
      final Map<String, dynamic> json = jsonDecode(data);
      final Map<SkillType, Skill> skills = {};
      json.forEach((key, value) {
        final type = SkillType.values[int.parse(key)];
        skills[type] = Skill.fromJson(value as Map<String, dynamic>, type);
      });
      return skills;
    }
    return {};
  }

  // Companions
  Future<void> saveCompanions(Map<String, Companion> companions) async {
    await init();
    final Map<String, dynamic> data = {};
    companions.forEach((id, companion) {
      data[id] = companion.toJson();
    });
    await _prefs!.setString(StorageKeys.companions, jsonEncode(data));
  }

  Future<Map<String, Companion>> getCompanions() async {
    await init();
    final data = _prefs!.getString(StorageKeys.companions);
    if (data != null) {
      final Map<String, dynamic> json = jsonDecode(data);
      final Map<String, Companion> companions = {};
      json.forEach((id, value) {
        // 실제로는 companion 데이터에서 type을 가져와야 함
        // 여기서는 간단히 처리
        companions[id] = Companion.fromJson(
          value as Map<String, dynamic>,
          id,
          CompanionType.attacker, // 기본값, 실제로는 저장된 데이터에서 가져와야 함
        );
      });
      return companions;
    }
    return {};
  }

  // Artifacts
  Future<void> saveArtifacts(List<Artifact> artifacts) async {
    await init();
    final List<Map<String, dynamic>> data =
        artifacts.map((a) => a.toJson()).toList();
    await _prefs!.setString(StorageKeys.artifacts, jsonEncode(data));
  }

  Future<List<Artifact>> getArtifacts() async {
    await init();
    final data = _prefs!.getString(StorageKeys.artifacts);
    if (data != null) {
      final List<dynamic> json = jsonDecode(data);
      return json.map((e) => Artifact.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  // Stage Progress
  Future<void> saveStageProgress(StageProgress progress) async {
    await init();
    await _prefs!.setString(
        StorageKeys.stageProgress, jsonEncode(progress.toJson()));
  }

  Future<StageProgress> getStageProgress() async {
    await init();
    final data = _prefs!.getString(StorageKeys.stageProgress);
    if (data != null) {
      return StageProgress.fromJson(jsonDecode(data));
    }
    return StageProgress();
  }

  // Status Upgrades
  Future<void> saveStatusUpgrades(
      Map<StatusType, StatusUpgrade> upgrades) async {
    await init();
    final Map<String, dynamic> data = {};
    upgrades.forEach((type, upgrade) {
      data[type.index.toString()] = upgrade.toJson();
    });
    await _prefs!.setString(StorageKeys.statusUpgrades, jsonEncode(data));
  }

  Future<Map<StatusType, StatusUpgrade>> getStatusUpgrades() async {
    await init();
    final data = _prefs!.getString(StorageKeys.statusUpgrades);
    if (data != null) {
      final Map<String, dynamic> json = jsonDecode(data);
      final Map<StatusType, StatusUpgrade> upgrades = {};
      json.forEach((key, value) {
        final type = StatusType.values[int.parse(key)];
        upgrades[type] = StatusUpgrade.fromJson(value as Map<String, dynamic>);
      });
      return upgrades;
    }
    return {};
  }

  // Achievement Stats
  Future<void> saveAchievementStats(AchievementStats stats) async {
    await init();
    await _prefs!.setString(
        StorageKeys.achievementStats, jsonEncode(stats.toJson()));
  }

  Future<AchievementStats> getAchievementStats() async {
    await init();
    final data = _prefs!.getString(StorageKeys.achievementStats);
    if (data != null) {
      return AchievementStats.fromJson(jsonDecode(data));
    }
    return AchievementStats();
  }

  // Game Settings
  Future<void> saveGameSettings(Map<String, dynamic> settings) async {
    await init();
    await _prefs!.setString(StorageKeys.gameSettings, jsonEncode(settings));
  }

  Future<Map<String, dynamic>> getGameSettings() async {
    await init();
    final data = _prefs!.getString(StorageKeys.gameSettings);
    if (data != null) {
      return jsonDecode(data);
    }
    return {
      'soundEnabled': true,
      'vibrationEnabled': true,
    };
  }

  // Clear all data (for testing)
  Future<void> clearAll() async {
    await init();
    await _prefs!.clear();
  }
}

