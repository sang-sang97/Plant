import 'skill.dart';

class AchievementStats {
  Duration totalPlayTime;
  int totalPlanetsKilled;
  int totalBossesKilled;
  int totalStagesCleared;
  int totalRebirths;
  int totalArtifactsObtained;
  int bestInfiniteWave;
  int totalGoldEarned;
  int totalExpEarned;
  Map<SkillType, int> skillUsageCount;
  int companionKills;

  AchievementStats({
    this.totalPlayTime = Duration.zero,
    this.totalPlanetsKilled = 0,
    this.totalBossesKilled = 0,
    this.totalStagesCleared = 0,
    this.totalRebirths = 0,
    this.totalArtifactsObtained = 0,
    this.bestInfiniteWave = 0,
    this.totalGoldEarned = 0,
    this.totalExpEarned = 0,
    Map<SkillType, int>? skillUsageCount,
    this.companionKills = 0,
  }) : skillUsageCount = skillUsageCount ?? {};

  Map<String, dynamic> toJson() {
    return {
      'totalPlayTime': totalPlayTime.inSeconds,
      'totalPlanetsKilled': totalPlanetsKilled,
      'totalBossesKilled': totalBossesKilled,
      'totalStagesCleared': totalStagesCleared,
      'totalRebirths': totalRebirths,
      'totalArtifactsObtained': totalArtifactsObtained,
      'bestInfiniteWave': bestInfiniteWave,
      'totalGoldEarned': totalGoldEarned,
      'totalExpEarned': totalExpEarned,
      'skillUsageCount': skillUsageCount.map((k, v) => MapEntry(k.index.toString(), v)),
      'companionKills': companionKills,
    };
  }

  factory AchievementStats.fromJson(Map<String, dynamic> json) {
    Map<SkillType, int> skillCount = {};
    if (json['skillUsageCount'] != null) {
      (json['skillUsageCount'] as Map).forEach((k, v) {
        skillCount[SkillType.values[int.parse(k)]] = v as int;
      });
    }

    return AchievementStats(
      totalPlayTime: Duration(seconds: json['totalPlayTime'] ?? 0),
      totalPlanetsKilled: json['totalPlanetsKilled'] ?? 0,
      totalBossesKilled: json['totalBossesKilled'] ?? 0,
      totalStagesCleared: json['totalStagesCleared'] ?? 0,
      totalRebirths: json['totalRebirths'] ?? 0,
      totalArtifactsObtained: json['totalArtifactsObtained'] ?? 0,
      bestInfiniteWave: json['bestInfiniteWave'] ?? 0,
      totalGoldEarned: json['totalGoldEarned'] ?? 0,
      totalExpEarned: json['totalExpEarned'] ?? 0,
      skillUsageCount: skillCount,
      companionKills: json['companionKills'] ?? 0,
    );
  }

  AchievementStats copyWith({
    Duration? totalPlayTime,
    int? totalPlanetsKilled,
    int? totalBossesKilled,
    int? totalStagesCleared,
    int? totalRebirths,
    int? totalArtifactsObtained,
    int? bestInfiniteWave,
    int? totalGoldEarned,
    int? totalExpEarned,
    Map<SkillType, int>? skillUsageCount,
    int? companionKills,
  }) {
    return AchievementStats(
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      totalPlanetsKilled: totalPlanetsKilled ?? this.totalPlanetsKilled,
      totalBossesKilled: totalBossesKilled ?? this.totalBossesKilled,
      totalStagesCleared: totalStagesCleared ?? this.totalStagesCleared,
      totalRebirths: totalRebirths ?? this.totalRebirths,
      totalArtifactsObtained: totalArtifactsObtained ?? this.totalArtifactsObtained,
      bestInfiniteWave: bestInfiniteWave ?? this.bestInfiniteWave,
      totalGoldEarned: totalGoldEarned ?? this.totalGoldEarned,
      totalExpEarned: totalExpEarned ?? this.totalExpEarned,
      skillUsageCount: skillUsageCount ?? this.skillUsageCount,
      companionKills: companionKills ?? this.companionKills,
    );
  }
}

