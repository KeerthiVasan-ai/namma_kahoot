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

  void _join() async {
    setState(() => _isJoining = true);
    await ref.read(gameProvider.notifier).joinGame(
      _pinController.text,
      _nameController.text,
    );
    setState(() => _isJoining = false);
  }

  Widget _buildAnswerButton(Color color, IconData icon, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 8,
          ),
          onPressed: () {
            final pin = ref.read(gameProvider).session?.pin ?? '';
            ref.read(gameProvider.notifier).submitAnswer(pin, 1, index); // Mocked playerId 1
          },
          child: Icon(icon, size: 64, color: Colors.white),
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
        backgroundColor: const Color(0xFF46178f),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Join Game', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _pinController,
                      decoration: const InputDecoration(labelText: 'Game PIN', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nickname', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                        onPressed: _isJoining ? null : _join,
                        child: _isJoining ? const CircularProgressIndicator() : const Text('Enter'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // 2. Lobby / Waiting Screen
    if (gameState.lastEvent?.eventType != 'QUESTION_STARTED') {
      return Scaffold(
        backgroundColor: const Color(0xFF46178f),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 24),
              Text(
                'You\'re in, ${_nameController.text}!',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Waiting for host to start...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Question Screen
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text('Question ${gameState.session?.currentQuestionIndex ?? 0 + 1}'),
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildAnswerButton(const Color(0xFFE21B3C), Icons.change_history, 0),
                _buildAnswerButton(const Color(0xFF1368CE), Icons.diamond, 1),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildAnswerButton(const Color(0xFFD89E00), Icons.circle, 2),
                _buildAnswerButton(const Color(0xFF26890C), Icons.square, 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
