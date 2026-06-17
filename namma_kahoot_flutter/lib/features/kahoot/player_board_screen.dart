import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/game_provider.dart';

class PlayerBoardScreen extends ConsumerStatefulWidget {
  const PlayerBoardScreen({super.key});

  @override
  ConsumerState<PlayerBoardScreen> createState() => _PlayerBoardScreenState();
}

class _PlayerBoardScreenState extends ConsumerState<PlayerBoardScreen> {
  final _pinController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isJoining = false;
  String? _errorMessage;

  void _join() async {
    if (_pinController.text.isEmpty || _nameController.text.isEmpty) {
      setState(() => _errorMessage = "Please fill in both fields");
      return;
    }

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    final success = await ref.read(gameProvider.notifier).joinGame(
          _pinController.text.trim(),
          _nameController.text.trim(),
        );

    if (mounted) {
      setState(() {
        _isJoining = false;
        if (!success) {
          _errorMessage = "Failed to join game. Check PIN and try again.";
        }
      });
    }
  }

  Widget _buildAnswerButton({
    required Color color,
    required IconData icon,
    required int index,
    required bool isDisabled,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            disabledBackgroundColor: color.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: isDisabled ? 1 : 8,
          ),
          onPressed: isDisabled
              ? null
              : () => ref.read(gameProvider.notifier).submitAnswer(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36.0),
            child: Icon(icon, size: 60, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    // 1. Join Screen
    if (!gameState.isConnected) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF46178F), Color(0xFF2C0B5E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 12,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.videogame_asset_rounded, size: 56, color: Color(0xFF46178F)),
                          const SizedBox(height: 12),
                          const Text(
                            'Join a Game',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF333333)),
                          ),
                          const SizedBox(height: 24),
                          if (_errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE21B3C).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE21B3C).withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded, color: Color(0xFFE21B3C)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(color: Color(0xFFE21B3C), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          TextField(
                            controller: _pinController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                            decoration: InputDecoration(
                              labelText: 'Game PIN',
                              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              hintText: 'e.g. 123456',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              prefixIcon: const Icon(Icons.pin),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _nameController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              labelText: 'Nickname',
                              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              hintText: 'Enter name',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              prefixIcon: const Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF46178F),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                              ),
                              onPressed: _isJoining ? null : _join,
                              child: _isJoining
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Enter Game', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final eventType = gameState.lastEvent?.eventType;

    // 2. Game finished screen
    if (eventType == 'GAME_FINISHED') {
      return Scaffold(
        backgroundColor: const Color(0xFF2C0B5E),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.military_tech_rounded, size: 90, color: Color(0xFFFFD800)),
                const SizedBox(height: 16),
                const Text(
                  'Game Completed!',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'Final score: ${gameState.currentPlayer?.score ?? 0} points',
                  style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 250,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF46178F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      ref.read(gameProvider.notifier).reset();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Back to Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3. Question Ended / Result Feedback Screen
    if (gameState.correctOptionIndex != null) {
      final isCorrect = gameState.submittedAnswerIndex == gameState.correctOptionIndex;
      final isAnswered = gameState.submittedAnswerIndex != null;

      return Scaffold(
        backgroundColor: isCorrect ? const Color(0xFF26890C) : const Color(0xFFE21B3C),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCorrect
                      ? Icons.check_circle_outline_rounded
                      : (isAnswered ? Icons.cancel_outlined : Icons.timer_off_outlined),
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  isCorrect
                      ? 'Correct!'
                      : (isAnswered ? 'Incorrect!' : 'Time Out!'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                if (isCorrect)
                  Text(
                    '+${gameState.earnedPoints ?? 0} pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Score',
                        style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${gameState.currentPlayer?.score ?? 0}',
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Look at the big screen for standings!',
                  style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 4. Active Question screen (where player inputs answer)
    if (eventType == 'QUESTION_STARTED') {
      final hasAnswered = gameState.submittedAnswerIndex != null;

      if (hasAnswered) {
        // Answer submitted, show waiting view
        return Scaffold(
          backgroundColor: const Color(0xFF46178F),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 24),
                const Icon(Icons.done_all_rounded, size: 64, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Answer Submitted!',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Waiting for other players...',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }

      // Active answering grid
      return Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        appBar: AppBar(
          title: Text(
            'Select Option',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF46178F),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildAnswerButton(
                    color: const Color(0xFFE21B3C), // Red
                    icon: Icons.change_history_rounded,
                    index: 0,
                    isDisabled: false,
                  ),
                  _buildAnswerButton(
                    color: const Color(0xFF1368CE), // Blue
                    icon: Icons.diamond_rounded,
                    index: 1,
                    isDisabled: false,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildAnswerButton(
                    color: const Color(0xFFD89E00), // Yellow
                    icon: Icons.circle_outlined,
                    index: 2,
                    isDisabled: false,
                  ),
                  _buildAnswerButton(
                    color: const Color(0xFF26890C), // Green
                    icon: Icons.square_outlined,
                    index: 3,
                    isDisabled: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 5. Lobby / Waiting screen (waiting for game to start or next question)
    return Scaffold(
      backgroundColor: const Color(0xFF46178F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 32),
              Text(
                'You\'re in, ${gameState.currentPlayer?.name}!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Waiting for host to proceed...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'YOUR CURRENT SCORE',
                      style: TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${gameState.currentPlayer?.score ?? 0}',
                      style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
