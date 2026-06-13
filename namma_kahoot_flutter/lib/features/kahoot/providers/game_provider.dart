import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:namma_kahoot_client/namma_kahoot_client.dart';
import '../../../main.dart';

class GameState {
  final GameSession? session;
  final Player? currentPlayer;
  final List<Player> players;
  final List<Question> questions;
  final GameEvent? lastEvent;
  final bool isConnected;
  final Map<int, int> answerCounts; // optionIndex -> count
  final int? submittedAnswerIndex; // answer chosen by this player
  final int? earnedPoints; // points awarded for current question
  final int? correctOptionIndex; // revealed correct answer
  final List<dynamic> leaderboard; // top players list
  final List<dynamic> podium; // top 3 players list

  GameState({
    this.session,
    this.currentPlayer,
    this.players = const [],
    this.questions = const [],
    this.lastEvent,
    this.isConnected = false,
    this.answerCounts = const {},
    this.submittedAnswerIndex,
    this.earnedPoints,
    this.correctOptionIndex,
    this.leaderboard = const [],
    this.podium = const [],
  });

  GameState copyWith({
    GameSession? session,
    Player? currentPlayer,
    List<Player>? players,
    List<Question>? questions,
    GameEvent? lastEvent,
    bool? isConnected,
    Map<int, int>? answerCounts,
    Object? submittedAnswerIndex = const Object(),
    Object? earnedPoints = const Object(),
    Object? correctOptionIndex = const Object(),
    List<dynamic>? leaderboard,
    List<dynamic>? podium,
  }) {
    return GameState(
      session: session ?? this.session,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      players: players ?? this.players,
      questions: questions ?? this.questions,
      lastEvent: lastEvent ?? this.lastEvent,
      isConnected: isConnected ?? this.isConnected,
      answerCounts: answerCounts ?? this.answerCounts,
      submittedAnswerIndex: submittedAnswerIndex == const Object()
          ? this.submittedAnswerIndex
          : (submittedAnswerIndex as int?),
      earnedPoints: earnedPoints == const Object()
          ? this.earnedPoints
          : (earnedPoints as int?),
      correctOptionIndex: correctOptionIndex == const Object()
          ? this.correctOptionIndex
          : (correctOptionIndex as int?),
      leaderboard: leaderboard ?? this.leaderboard,
      podium: podium ?? this.podium,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  StreamSubscription? _subscription;

  GameNotifier() : super(GameState());

  /// Reset game state
  void reset() {
    _subscription?.cancel();
    state = GameState();
  }

  /// Player joins game
  Future<bool> joinGame(String pin, String username) async {
    try {
      // Ensure the WebSocket streaming connection is open for real-time messages
      await client.openStreamingConnection();
      
      final player = await client.kahoot.joinGame(pin, username);
      if (player != null) {
        final session = await client.kahoot.getGameByPin(pin);
        if (session != null) {
          state = state.copyWith(
            currentPlayer: player,
            session: session,
            isConnected: true,
          );
          _subscribeToGame(pin, isHost: false);
          return true;
        }
      }
    } catch (e) {
      // Print or log error
    }
    return false;
  }

  /// Host starts a game
  Future<void> hostGame(int quizId) async {
    try {
      // Ensure the WebSocket streaming connection is open for real-time messages
      await client.openStreamingConnection();

      final session = await client.kahoot.createGame(quizId, 1); // Mocked hostId = 1
      final questions = await client.admin.getQuestionsForQuiz(quizId);
      
      state = state.copyWith(
        session: session,
        questions: questions,
        isConnected: true,
      );
      
      _subscribeToGame(session.pin, isHost: true);
    } catch (e) {
      // Handle error
    }
  }

  void _subscribeToGame(String pin, {bool isHost = false}) {
    _subscription?.cancel();
    _subscription = client.kahoot.gameStream(pin, isHost).listen((event) {
      _handleEvent(event);
    });
  }

  void _handleEvent(GameEvent event) {
    var updatedState = state.copyWith(lastEvent: event);

    if (event.eventType == 'PLAYER_JOINED') {
      final data = jsonDecode(event.dataJson);
      final newPlayer = Player(
        id: data['playerId'],
        gameSessionId: state.session!.id!,
        name: data['name'],
        score: 0,
      );
      state = updatedState.copyWith(players: [...state.players, newPlayer]);
    } 
    else if (event.eventType == 'QUESTION_STARTED') {
      final data = jsonDecode(event.dataJson);
      final newIndex = data['questionIndex'] as int;
      
      if (state.session != null) {
        state.session!.currentQuestionIndex = newIndex;
        state.session!.status = 'active';
      }
      
      state = state.copyWith(
        lastEvent: event,
        answerCounts: {},
        submittedAnswerIndex: null,
        earnedPoints: null,
        correctOptionIndex: null,
      );
    } 
    else if (event.eventType == 'ANSWER_RECEIVED') {
      final data = jsonDecode(event.dataJson);
      final optionIndex = data['optionIndex'] as int;
      final currentCounts = Map<int, int>.from(state.answerCounts);
      currentCounts[optionIndex] = (currentCounts[optionIndex] ?? 0) + 1;
      
      state = updatedState.copyWith(answerCounts: currentCounts);
    } 
    else if (event.eventType == 'QUESTION_ENDED') {
      final data = jsonDecode(event.dataJson);
      final correctOptionIndex = data['correctOptionIndex'] as int;
      
      if (state.session != null) {
        state.session!.status = 'paused';
      }

      state = updatedState.copyWith(
        correctOptionIndex: correctOptionIndex,
      );
      
      // If we are a player, fetch our updated score from the server
      if (state.currentPlayer != null) {
        _syncPlayerScore();
      }
    } 
    else if (event.eventType == 'SHOW_LEADERBOARD') {
      final data = jsonDecode(event.dataJson);
      final topPlayers = data['topPlayers'] as List<dynamic>;
      if (state.session != null) {
        state.session!.status = 'paused';
      }
      state = updatedState.copyWith(leaderboard: topPlayers);
    } 
    else if (event.eventType == 'GAME_FINISHED') {
      final data = jsonDecode(event.dataJson);
      final topPlayers = data['topPlayers'] as List<dynamic>;
      if (state.session != null) {
        state.session!.status = 'finished';
      }
      state = updatedState.copyWith(podium: topPlayers);
    } 
    else {
      state = updatedState;
    }
  }

  /// Player submits an answer
  Future<void> submitAnswer(int optionIndex) async {
    if (state.session == null || state.currentPlayer == null) return;
    
    final pin = state.session!.pin;
    final playerId = state.currentPlayer!.id!;
    
    try {
      final points = await client.kahoot.submitAnswer(pin, playerId, optionIndex);
      state = state.copyWith(
        submittedAnswerIndex: optionIndex,
        earnedPoints: points,
      );
    } catch (e) {
      // Handle error
    }
  }

  /// Sync player score from server database
  Future<void> _syncPlayerScore() async {
    if (state.currentPlayer == null) return;
    try {
      if (state.earnedPoints != null && state.earnedPoints! > 0) {
        final currentScore = state.currentPlayer!.score;
        final updatedPlayer = state.currentPlayer!.copyWith(
          score: currentScore + state.earnedPoints!,
        );
        state = state.copyWith(currentPlayer: updatedPlayer);
      }
    } catch (e) {
      // Handle error
    }
  }

  /// Host triggers first question
  Future<void> startQuestion() async {
    if (state.session == null) return;
    await client.kahoot.startQuestion(state.session!.pin);
  }

  /// Host triggers next question
  Future<void> nextQuestion() async {
    if (state.session == null) return;
    final updatedSession = await client.kahoot.nextQuestion(state.session!.pin);
    if (updatedSession != null) {
      state = state.copyWith(session: updatedSession);
    }
  }

  /// Host ends current question
  Future<void> endQuestion() async {
    if (state.session == null) return;
    await client.kahoot.endQuestion(state.session!.pin);
  }

  /// Host displays leaderboard
  Future<void> showLeaderboard() async {
    if (state.session == null) return;
    await client.kahoot.showLeaderboard(state.session!.pin);
  }

  /// Host finishes the game
  Future<void> finishGame() async {
    if (state.session == null) return;
    await client.kahoot.finishGame(state.session!.pin);
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
