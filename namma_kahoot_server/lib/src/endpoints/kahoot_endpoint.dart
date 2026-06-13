import 'package:serverpod/serverpod.dart';
import 'dart:math';
import '../generated/protocol.dart';

class KahootEndpoint extends Endpoint {
  
  /// Create a new Game Session from a Quiz and return the PIN
  Future<GameSession> createGame(Session session, int quizId, int hostId) async {
    var rng = Random();
    var pin = (rng.nextInt(900000) + 100000).toString();

    var game = GameSession(
      pin: pin,
      quizId: quizId,
      hostId: hostId,
      status: 'lobby',
      currentQuestionIndex: 0,
    );

    game = await GameSession.db.insertRow(session, game);
    return game;
  }

  /// Get Game Info by PIN
  Future<GameSession?> getGameByPin(Session session, String pin) async {
    return await GameSession.db.findFirstRow(
      session,
      where: (t) => t.pin.equals(pin),
    );
  }

  /// Players and Host call this stream to receive real-time updates
  Stream<GameEvent> gameStream(Session session, String pin, bool isHost) async* {
    var channel = isHost ? 'game-$pin-host' : 'game-$pin';
    yield* session.messages.createStream<GameEvent>(channel);
  }

  /// Send an event manually over the channel
  Future<void> sendEvent(Session session, String pin, GameEvent event, bool toHostOnly) async {
    if (toHostOnly) {
      await session.messages.postMessage('game-$pin-host', event);
    } else {
      await session.messages.postMessage('game-$pin', event);
      await session.messages.postMessage('game-$pin-host', event);
    }
  }

  /// Join a game
  Future<Player?> joinGame(Session session, String pin, String username) async {
    var game = await getGameByPin(session, pin);
    if (game == null || game.status != 'lobby') return null;

    var player = Player(
      gameSessionId: game.id!,
      name: username,
      score: 0,
    );

    player = await Player.db.insertRow(session, player);

    // Notify ONLY the host that a player joined
    await session.messages.postMessage('game-$pin-host', GameEvent(
      eventType: 'PLAYER_JOINED',
      dataJson: '{"playerId": ${player.id}, "name": "$username"}',
    ));

    return player;
  }

  /// Host starts a question
  Future<void> startQuestion(Session session, String pin) async {
    var game = await getGameByPin(session, pin);
    if (game != null) {
      game.status = 'active';
      game.startTime = DateTime.now();
      await GameSession.db.updateRow(session, game);

      final event = GameEvent(
        eventType: 'QUESTION_STARTED',
        dataJson: '{"questionIndex": ${game.currentQuestionIndex}}',
      );
      
      // Notify both host and players
      await session.messages.postMessage('game-$pin', event);
      await session.messages.postMessage('game-$pin-host', event);
    }
  }

  /// Player submits an answer
  Future<void> submitAnswer(Session session, String pin, int playerId, int optionIndex) async {
    var game = await getGameByPin(session, pin);
    if (game == null || game.status != 'active' || game.startTime == null) return;

    var question = await Question.db.findFirstRow(
      session,
      where: (t) => t.quizId.equals(game.quizId) & t.orderIndex.equals(game.currentQuestionIndex),
    );

    if (question == null) return;

    int points = 0;
    if (question.correctOptionIndex == optionIndex) {
       final timeTaken = DateTime.now().difference(game.startTime!).inSeconds;
       final timeLimit = question.timeLimitSeconds;
       if (timeTaken <= timeLimit) {
           points = (1000 * (1 - (timeTaken / timeLimit))).round();
           if (points < 0) points = 0;
       }
    }

    if (points > 0) {
        var player = await Player.db.findById(session, playerId);
        if (player != null) {
            player.score += points;
            await Player.db.updateRow(session, player);
        }
    }

    // Send answer received ONLY to the host
    await session.messages.postMessage('game-$pin-host', GameEvent(
      eventType: 'ANSWER_RECEIVED',
      dataJson: '{"playerId": $playerId, "optionIndex": $optionIndex, "points": $points}',
    ));
  }

  /// Host shows leaderboard / results
  Future<void> showLeaderboard(Session session, String pin) async {
    var game = await getGameByPin(session, pin);
    if (game != null) {
      game.status = 'finished'; // or 'showing_leaderboard'
      
      // Get top 5 players
      var topPlayers = await Player.db.find(
        session,
        where: (t) => t.gameSessionId.equals(game.id),
        orderBy: (t) => t.score,
        orderDescending: true,
        limit: 5,
      );
      
      var leaderboardJson = topPlayers.map((p) => '{"name": "${p.name}", "score": ${p.score}}').toList();
      var dataJson = '{"topPlayers": $leaderboardJson}';

      await GameSession.db.updateRow(session, game);

      final event = GameEvent(
        eventType: 'SHOW_LEADERBOARD',
        dataJson: dataJson,
      );

      await session.messages.postMessage('game-$pin', event);
      await session.messages.postMessage('game-$pin-host', event);
    }
  }
}
