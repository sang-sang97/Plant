import 'package:flutter/material.dart';
import '../../core/services/game_service.dart';
import '../../widgets/game/planet_painter.dart';
import '../../widgets/game/earth_widget.dart';
import '../../widgets/game/game_settings_dialog.dart';

class GameScreen extends StatefulWidget {
  final int stage;
  final String gameMode; // 'stage', 'daily_exp', 'daily_gold', 'infinite'

  const GameScreen({
    super.key,
    required this.stage,
    required this.gameMode,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameService _gameService;
  final GlobalKey _gameKey = GlobalKey();
  DateTime _lastUpdateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _gameService = GameService();
    _lastUpdateTime = DateTime.now();
    
    // AnimationController를 사용하여 부드러운 60fps 업데이트
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // 무한 반복
    
    _animationController.addListener(_updateGame);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      _gameService.startSpawning(size);
    });
  }

  void _updateGame() {
    if (!mounted || !_gameService.isRunning) return;
    
    final now = DateTime.now();
    final deltaTime = _lastUpdateTime == DateTime(0)
        ? 0.016 // 첫 프레임
        : now.difference(_lastUpdateTime).inMicroseconds / 1000000.0;
    
    // deltaTime이 너무 크면 제한 (프레임 드롭 방지)
    final clampedDeltaTime = deltaTime.clamp(0.0, 0.1);
    _lastUpdateTime = now;
    
    _gameService.updateGame(clampedDeltaTime);
    
    // UI 업데이트
    setState(() {});
  }

  @override
  void dispose() {
    _gameService.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    final renderBox = _gameKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final hit = _gameService.onPlanetTapped(localPosition, 1.0); // 기본 데미지 1
    if (hit && mounted) {
      setState(() {}); // 터치 시 즉시 UI 업데이트
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = _gameService.gameState;
    final planets = _gameService.planets;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: Stack(
        children: [
          // 게임 영역
          GestureDetector(
            key: _gameKey,
            onTapDown: _onTapDown,
            behavior: HitTestBehavior.opaque, // 투명한 영역도 터치 가능
            child: RepaintBoundary(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CustomPaint(
                  painter: PlanetPainter(List.from(planets)), // 새 리스트로 복사하여 변경 감지
                  willChange: true, // 애니메이션이 계속되므로 최적화 힌트
                ),
              ),
            ),
          ),

          // 지구
          EarthWidget(lives: gameState.earthLives),

          // UI 오버레이
          _buildUIOverlay(gameState),

          // 게임 오버/성공 화면
          if (gameState.isGameOver)
            _buildGameOverScreen()
          else if (gameState.isVictory)
            _buildVictoryScreen(),
        ],
      ),
    );
  }

  Widget _buildUIOverlay(gameState) {
    return SafeArea(
      child: Column(
        children: [
          // 상단 UI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 왼쪽: 목숨
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        index < gameState.earthLives
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: index < gameState.earthLives
                            ? Colors.red
                            : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              // 오른쪽: 웨이브 번호 및 설정
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Wave ${gameState.currentWave} / 3',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () async {
                        final size = MediaQuery.of(context).size;
                        final result = await showDialog(
                          context: context,
                          builder: (context) => const GameSettingsDialog(),
                        );
                        if (!mounted) return;
                        if (result == 'restart') {
                          // 게임 재시작
                          _gameService.reset();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              _gameService.startSpawning(size);
                            }
                          });
                        } else if (result == 'home') {
                          // 홈으로 돌아가기
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          // 하단: 스킬 버튼 (오른쪽 하단)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TODO: 스킬 버튼들
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverScreen() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sentiment_very_dissatisfied,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              '게임 오버',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _gameService.reset();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final size = MediaQuery.of(context).size;
                  _gameService.startSpawning(size);
                });
              },
              child: const Text('재시작'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('메인 메뉴로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVictoryScreen() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.celebration,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 20),
            const Text(
              '성공!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '획득한 점수: ${_gameService.gameState.score}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _gameService.reset();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final size = MediaQuery.of(context).size;
                  _gameService.startSpawning(size);
                });
              },
              child: const Text('재시작'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('메인 메뉴로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}

