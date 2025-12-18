import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../models/game_state.dart';
import '../constants/game_constants.dart';

class GameService extends ChangeNotifier {
  final Random _random = Random();
  
  GameState _gameState = GameState();
  List<Planet> _planets = [];
  Timer? _spawnTimer;
  DateTime? _lastSpawnTime;
  bool _isRunning = false;
  Size? _screenSize;

  GameState get gameState => _gameState;
  List<Planet> get planets => _planets;
  bool get isRunning => _isRunning;
  
  // 외부에서 업데이트를 호출할 수 있도록
  void updateGame(double deltaTime) {
    if (!_isRunning || _gameState.isPaused || _screenSize == null) return;

    // 행성 업데이트
    _planets.removeWhere((planet) {
      planet.update(deltaTime, _screenSize!.height);
      return planet.isOffScreen(_screenSize!.height) || planet.isDestroyed;
    });

    // 지구 충돌 체크
    _checkEarthCollision(_screenSize!);
  }

  // 행성 스폰
  void startSpawning(Size screenSize) {
    _isRunning = true;
    _screenSize = screenSize;
    _gameState.reset();
    _planets.clear();
    _lastSpawnTime = DateTime.now();

    // 행성 스폰은 별도 타이머로
    _spawnTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) {
        if (_screenSize != null && _isRunning) {
          _checkSpawn(_screenSize!);
        }
      },
    );

    _spawnPlanets(screenSize);
  }


  void _checkSpawn(Size screenSize) {
    if (!_isRunning) return;
    
    final now = DateTime.now();
    final timeSinceLastSpawn = now.difference(_lastSpawnTime ?? now).inSeconds;

    // 2초마다 스폰
    if (timeSinceLastSpawn >= GameConstants.spawnInterval.toInt()) {
      _spawnPlanets(screenSize);
      _lastSpawnTime = now;
    }

    // 행성이 2개 이하가 되면 추가 스폰
    final activePlanets = _planets.where((p) => !p.isDestroyed).length;
    if (activePlanets <= GameConstants.minPlanetCount) {
      _spawnPlanets(screenSize);
    }
  }

  void _spawnPlanets(Size screenSize) {
    final count = GameConstants.minSpawnCount +
        _random.nextInt(GameConstants.maxSpawnCount - GameConstants.minSpawnCount + 1);

    for (int i = 0; i < count; i++) {
      final planet = _createPlanet(screenSize);
      _planets.add(planet);
    }
  }

  Planet _createPlanet(Size screenSize) {
    final wave = _gameState.currentWave;
    final baseHealth = 100.0 * pow(GameConstants.waveHealthMultiplier, wave - 1);
    // 속도를 더 느리게 조정 (픽셀/초 단위)
    // 속도를 픽셀/초 단위로 설정 (원래 로직 유지하되 더 부드럽게)
    final baseSpeed = 50.0 * pow(GameConstants.waveSpeedMultiplier, wave - 1);
    
    // 행성 크기 약간 랜덤
    final baseRadius = 20.0;
    final radius = baseRadius + _random.nextDouble() * 10 - 5;

    // 행성 색상 랜덤
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.purple,
      Colors.green,
      Colors.orange,
    ];
    final color = colors[_random.nextInt(colors.length)];

    // UI 오버레이 높이 고려 (SafeArea + 상단 UI 높이 약 100px)
    final topOffset = 100.0;
    
    // 행성 ID를 더 고유하게 생성
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomId = _random.nextInt(10000);

    return Planet(
      id: '${timestamp}_$randomId',
      position: Offset(
        _random.nextDouble() * (screenSize.width - radius * 2) + radius, // 화면 경계 내에서
        topOffset - radius, // UI 오버레이 아래에서 시작
      ),
      radius: radius,
      health: baseHealth,
      maxHealth: baseHealth,
      speed: baseSpeed,
      color: color,
    );
  }

  void _checkEarthCollision(Size screenSize) {
    final earthY = screenSize.height - (screenSize.height * GameConstants.earthHeightRatio);
    
    for (final planet in _planets) {
      if (!planet.isDestroyed && planet.position.dy + planet.radius >= earthY) {
        planet.isDestroyed = true;
        _gameState.loseLife();
        if (_gameState.isGameOver) {
          stop();
        }
      }
    }
  }

  // 행성 터치 처리
  bool onPlanetTapped(Offset tapPosition, double baseDamage) {
    for (final planet in _planets) {
      if (!planet.isDestroyed && planet.checkCollision(tapPosition)) {
        planet.takeDamage(baseDamage);
        if (planet.isDestroyed) {
          _gameState.score++;
        }
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void nextWave() {
    _gameState.nextWave();
    notifyListeners();
  }

  void pause() {
    _gameState.isPaused = true;
    notifyListeners();
  }

  void resume() {
    _gameState.isPaused = false;
    _lastSpawnTime = DateTime.now();
    notifyListeners();
  }

  void stop() {
    _isRunning = false;
    _spawnTimer?.cancel();
    _spawnTimer = null;
    notifyListeners();
  }

  void reset() {
    stop();
    _gameState = GameState();
    _planets.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

