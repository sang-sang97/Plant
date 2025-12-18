import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class GameSettingsDialog extends StatelessWidget {
  const GameSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.cyan.withValues(alpha: 0.3), width: 2),
      ),
      child: Consumer<GameProvider>(
        builder: (context, provider, child) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '설정',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 사운드 설정
                SwitchListTile(
                  title: const Text(
                    '사운드',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    '효과음 재생',
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: provider.soundEnabled,
                  onChanged: (value) {
                    provider.updateGameSettings('soundEnabled', value);
                  },
                  activeColor: Colors.cyan,
                ),
                // 진동 설정
                SwitchListTile(
                  title: const Text(
                    '진동',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    '터치 시 진동',
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: provider.vibrationEnabled,
                  onChanged: (value) {
                    provider.updateGameSettings('vibrationEnabled', value);
                  },
                  activeColor: Colors.cyan,
                ),
                const SizedBox(height: 20),
                // 재시작 버튼
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // 설정 다이얼로그 닫기
                    // GameScreen에서 게임 재시작 처리하도록 콜백 전달
                    Navigator.of(context).pop('restart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '게임 재시작',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                // 홈으로 돌아가기
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'home'); // 'home' 결과 반환
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '홈으로 돌아가기',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

