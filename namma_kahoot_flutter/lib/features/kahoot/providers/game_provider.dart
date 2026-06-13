import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:namma_kahoot_client/namma_kahoot_client.dart';
import '../../../main.dart';

class GameState {
  final GameSession? session;
  final List<Player> players;
  final GameEvent? lastEvent;
  final bool isConnected;
  final Map<int, int> answerCounts; // optionIndex -> count

  GameState({
    this.session,
    this.players = const [],
    this.lastEvent,
    this.isConnected = false,
    this.answerCounts = const {},
  });

  GameState copyWith({
    GameSession? session,
    List<Player>? players,
    GameEvent? lastEvent,
    bool? isConnected,
    Map<int, int>? answerCounts,
  }) {
    return GameState(
      session: session ?? this.session,
      players: players ?? this.players,
      lastEvent: lastEvent ?? this.lastEvent,
      isConnected: isConnected ?? this.isConnected,
      answerCounts: answerCounts ?? this.answerCounts,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  StreamSubscription? _subscription;

  GameNotifier() : super(GameState());

  Future<void> joinGame(String pin, String username) async {
    final player = await client.kahoot.joinGame(pin, username);
    if (player != null) {
      final session = await client.kahoot.getGameByPin(pin);
      state = state.copyWith(session: session, isConnected: true);
      _subscribeToGame(pin, isHost: false);
    }
  }

  Future<void> hostGame(int quizId) async {
    final session = await client.kahoot.createGame(quizId, 1); // Mocked hostId
    state = state.copyWith(session: session, isConnected: true);
    _subscribeToGame(session.pin, isHost: true);
  }

  void _subscribeToGame(String pin, {bool isHost = false}) {
    _subscription?.cancel();
    _subscription = client.kahoot.gameStream(pin, isHost).listen((event) {
      _handleEvent(event);
    });
  }

  void _handleEvent(GameEvent event) {
    final updatedState = state.copyWith(lastEvent: event);

    if (event.eventType == 'PLAYER_JOINED') {
      final data = jsonDecode(event.dataJson);
      final newPlayer = Player(
        gameSessionId: state.session!.id!,
        name: data['name'],
        score: 0,
      );
      state = updatedState.copyWith(players: [...state.players, newPlayer]);
    } else if (event.eventType == 'QUESTION_STARTED') {
      state = updatedState.copyWith(answerCounts: {});
    } else if (event.eventType == 'ANSWER_RECEIVED') {
      final data = jsonDecode(event.dataJson);
      final optionIndex = data['optionIndex'] as int;
      final currentCounts = Map<int, int>.from(state.answerCounts);
      currentCounts[optionIndex] = (currentCounts[optionIndex] ?? 0) + 1;
      state = updatedState.copyWith(answerCounts: currentCounts);
    } else {
      state = updatedState;
    }
  }

  Future<void> submitAnswer(String pin, int playerId, int optionIndex) async {
    await client.kahoot.submitAnswer(pin, playerId, optionIndex);
  }

  Future<void> startQuestion() async {
    if (state.session == null) return;
    await client.kahoot.startQuestion(state.session!.pin);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
