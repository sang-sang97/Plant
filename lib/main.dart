import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'providers/game_provider.dart';
import 'screens/loading_screen.dart';
import 'screens/skill/skill_screen.dart';
import 'screens/companion/companion_screen.dart';
import 'screens/artifact/artifact_screen.dart';
import 'screens/status/status_screen.dart';
import 'screens/rebirth/rebirth_screen.dart';
import 'screens/achievement/achievement_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 세로 모드 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider()..init(),
      child: MaterialApp(
        title: 'Planet Defense',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Colors.cyan,
            secondary: Colors.blue,
            surface: const Color(0xFF1A1A2E),
          ),
          scaffoldBackgroundColor: const Color(0xFF0F0F1E),
          useMaterial3: true,
        ),
        builder: (context, child) {
          if (kIsWeb) {
            // 웹일 때 9:16 비율로 중앙 배치
            return LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;
                
                // 9:16 비율 계산
                double gameWidth = screenWidth * 0.4; // 화면 너비의 40%
                double gameHeight = gameWidth * 16 / 9; // 9:16 비율 유지
                
                // 화면 높이를 초과하지 않도록 조정
                if (gameHeight > screenHeight * 0.9) {
                  gameHeight = screenHeight * 0.9;
                  gameWidth = gameHeight * 9 / 16;
                }
                
                // 최소/최대 크기 제한
                gameWidth = gameWidth.clamp(300.0, 450.0);
                gameHeight = gameWidth * 16 / 9;
                
                return Container(
                  color: const Color(0xFF000000), // 외부 배경색
                  child: Center(
                    child: Container(
                      width: gameWidth,
                      height: gameHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0F1E),
                        border: Border.all(
                          color: Colors.cyan.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: child,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return child!;
        },
        routes: {
          '/skill': (context) => const SkillScreen(),
          '/companion': (context) => const CompanionScreen(),
          '/artifact': (context) => const ArtifactScreen(),
          '/status': (context) => const StatusScreen(),
          '/rebirth': (context) => const RebirthScreen(),
          '/achievement': (context) => const AchievementScreen(),
        },
        home: const LoadingScreen(),
      ),
    );
  }
}
