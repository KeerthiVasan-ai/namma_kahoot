import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/game_provider.dart';

class HostDashboardScreen extends ConsumerStatefulWidget {
  const HostDashboardScreen({super.key});

  @override
  ConsumerState<HostDashboardScreen> createState() => _HostDashboardScreenState();
}

class _HostDashboardScreenState extends ConsumerState<HostDashboardScreen> {
  
  Widget _buildResultsChart(Map<int, int> counts, int totalPlayers) {
    const colors = [Color(0xFFE21B3C), Color(0xFF1368CE), Color(0xFFD89E00), Color(0xFF26890C)];
    final maxCount = counts.values.isEmpty ? 1 : counts.values.reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(4, (index) {
          final count = counts[index] ?? 0;
          final heightFactor = count / maxCount;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: 300 * heightFactor + 10,
                  decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    if (gameState.session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Start Hosting')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => ref.read(gameProvider.notifier).hostGame(1),
            child: const Text('Launch Quiz #1'),
          ),
        ),
      );
    }

    final isQuestionActive = gameState.lastEvent?.eventType == 'QUESTION_STARTED' || 
                             gameState.lastEvent?.eventType == 'ANSWER_RECEIVED';

    return Scaffold(
      backgroundColor: const Color(0xFF46178f),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Game PIN:', style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text(
                        gameState.session?.pin ?? '...',
                        style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${gameState.players.length} Players',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    if (!isQuestionActive) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          'Ready to start?',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: gameState.players.map((p) => Chip(
                              label: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFF46178f)),
                              avatar: const CircleAvatar(child: Icon(Icons.person, size: 16)),
                            )).toList(),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          'Question Active',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                        ),
                      ),
                      _buildResultsChart(gameState.answerCounts, gameState.players.length),
                      const Spacer(),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1368CE),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => ref.read(gameProvider.notifier).startQuestion(),
                          child: Text(
                            isQuestionActive ? 'Next Question' : 'Start Game',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
