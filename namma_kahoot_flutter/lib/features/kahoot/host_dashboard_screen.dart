import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namma_kahoot_client/namma_kahoot_client.dart';
import '../../../main.dart';
import 'providers/game_provider.dart';

class HostDashboardScreen extends ConsumerStatefulWidget {
  const HostDashboardScreen({super.key});

  @override
  ConsumerState<HostDashboardScreen> createState() => _HostDashboardScreenState();
}

class _HostDashboardScreenState extends ConsumerState<HostDashboardScreen> {
  List<Quiz> _quizzes = [];
  bool _loadingQuizzes = true;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    try {
      final quizzes = await client.admin.getQuizzes();
      setState(() {
        _quizzes = quizzes;
        _loadingQuizzes = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loadingQuizzes = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    // 1. Selector view
    if (gameState.session == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Host a Kahoot', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: const Color(0xFF46178F),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF2F2F2), Color(0xFFE5E5E5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _loadingQuizzes
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF46178F)))
              : _quizzes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.quiz_outlined, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No quizzes found.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Create a quiz in the Admin Dashboard first.', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select a Quiz to Host',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF333333)),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _quizzes.length,
                              itemBuilder: (context, index) {
                                final quiz = _quizzes[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 4,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1368CE).withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.bolt, color: Color(0xFF1368CE)),
                                    ),
                                    title: Text(
                                      quiz.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        quiz.description ?? 'A general trivia challenge.',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF46178F)),
                                    onTap: () {
                                      ref.read(gameProvider.notifier).hostGame(quiz.id!);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      );
    }

    // 2. Identify the active screen based on status & lastEvent type
    final status = gameState.session?.status;
    final lastEvent = gameState.lastEvent;

    if (status == 'lobby') {
      return _buildLobbyScreen(gameState);
    } else if (lastEvent?.eventType == 'GAME_FINISHED') {
      return _buildPodiumScreen(gameState);
    } else if (lastEvent?.eventType == 'SHOW_LEADERBOARD') {
      return _buildLeaderboardScreen(gameState);
    } else {
      // Game session is active (either question showing or question ended showing answers)
      final currentQuestionIndex = gameState.session?.currentQuestionIndex ?? 0;
      if (currentQuestionIndex < gameState.questions.length) {
        final currentQuestion = gameState.questions[currentQuestionIndex];
        
        if (gameState.correctOptionIndex != null) {
          return _buildQuestionResultsScreen(gameState, currentQuestion);
        } else {
          return _buildActiveQuestionScreen(gameState, currentQuestion);
        }
      } else {
        // Safe fall back
        return _buildPodiumScreen(gameState);
      }
    }
  }

  // LOBBY VIEW
  Widget _buildLobbyScreen(GameState gameState) {
    return Scaffold(
      backgroundColor: const Color(0xFF46178F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Text('Namma Kahoot Game PIN', style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    gameState.session?.pin ?? '...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4.0,
                      shadows: [Shadow(color: Color(0x3F000000), blurRadius: 12, offset: Offset(0, 4))],
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Joined Players',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF333333)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF46178F).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${gameState.players.length} Players',
                              style: const TextStyle(color: Color(0xFF46178F), fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: gameState.players.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(color: Color(0xFF46178F)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Waiting for players to join...',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: gameState.players.map((p) {
                                    return Chip(
                                      padding: const EdgeInsets.all(12),
                                      avatar: const CircleAvatar(
                                        backgroundColor: Color(0xFF46178F),
                                        child: Icon(Icons.person, color: Colors.white, size: 16),
                                      ),
                                      label: Text(
                                        p.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      backgroundColor: Colors.white,
                                      elevation: 2,
                                      shadowColor: Colors.black26,
                                      side: BorderSide(color: const Color(0xFF46178F).withValues(alpha: 0.3)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF26890C), // Green
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                          ),
                          onPressed: gameState.players.isEmpty
                              ? null
                              : () => ref.read(gameProvider.notifier).startQuestion(),
                          child: const Text(
                            'Start Game',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

  // ACTIVE QUESTION VIEW
  Widget _buildActiveQuestionScreen(GameState gameState, Question question) {
    // Count answers
    final totalAnswers = gameState.answerCounts.values.fold(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text(
          'Question ${question.orderIndex + 1} of ${gameState.questions.length}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF46178F),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Question text box
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Text(
                  question.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF333333)),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Timer and answer counts row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CountdownTimer(
                  seconds: question.timeLimitSeconds,
                  onFinished: () {
                    ref.read(gameProvider.notifier).endQuestion();
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$totalAnswers',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF1368CE)),
                      ),
                      const Text(
                        'Answers Submitted',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Options grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(4, (index) {
                  final colors = [
                    const Color(0xFFE21B3C), // Option 0 - Red
                    const Color(0xFF1368CE), // Option 1 - Blue
                    const Color(0xFFD89E00), // Option 2 - Yellow
                    const Color(0xFF26890C), // Option 3 - Green
                  ];
                  final icons = [
                    Icons.change_history_rounded, // Triangle
                    Icons.diamond_rounded,        // Diamond
                    Icons.circle_outlined,         // Circle
                    Icons.square_outlined,         // Square
                  ];

                  if (index >= question.options.length) return const SizedBox.shrink();

                  return Card(
                    color: colors[index],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(icons[index], color: Colors.white, size: 36),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Bottom bar
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => ref.read(gameProvider.notifier).endQuestion(),
                  child: const Text('Skip / Reveal Answer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // QUESTION RESULTS / CHART VIEW
  Widget _buildQuestionResultsScreen(GameState gameState, Question question) {
    const colors = [
      Color(0xFFE21B3C),
      Color(0xFF1368CE),
      Color(0xFFD89E00),
      Color(0xFF26890C),
    ];
    
    final counts = gameState.answerCounts;
    final maxCount = counts.values.isEmpty ? 1 : counts.values.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Question Ended', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF46178F),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Question and Correct option reveal
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      question.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors[gameState.correctOptionIndex!].withValues(alpha: 0.15),
                        border: Border.all(color: colors[gameState.correctOptionIndex!], width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF26890C), size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'Correct Answer: ${question.options[gameState.correctOptionIndex!]}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: colors[gameState.correctOptionIndex!],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Distribution bar chart
            const Text(
              'Answer Distribution',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(4, (index) {
                    if (index >= question.options.length) return const SizedBox.shrink();

                    final count = counts[index] ?? 0;
                    final heightFactor = count / maxCount;
                    final icons = [
                      Icons.change_history_rounded,
                      Icons.diamond_rounded,
                      Icons.circle_outlined,
                      Icons.square_outlined,
                    ];

                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '$count',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            height: 220 * heightFactor + 16,
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              boxShadow: [
                                BoxShadow(color: colors[index].withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Icon(icons[index], color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Next button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1368CE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                onPressed: () => ref.read(gameProvider.notifier).showLeaderboard(),
                child: const Text('Show Leaderboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LEADERBOARD VIEW
  Widget _buildLeaderboardScreen(GameState gameState) {
    final isLastQuestion = gameState.session?.currentQuestionIndex == gameState.questions.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF46178F),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.leaderboard_rounded, size: 64, color: Color(0xFFFFD800)),
                  SizedBox(height: 12),
                  Text(
                    'Leaderboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: gameState.leaderboard.isEmpty
                          ? Center(
                              child: Text(
                                'No answers submitted yet.',
                                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: gameState.leaderboard.length,
                              itemBuilder: (context, index) {
                                final row = gameState.leaderboard[index];
                                final rankColors = [
                                  const Color(0xFFFFD800), // Gold
                                  const Color(0xFFC0C0C0), // Silver
                                  const Color(0xFFCD7F32), // Bronze
                                ];
                                final isPodium = index < 3;

                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 2,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    leading: CircleAvatar(
                                      backgroundColor: isPodium ? rankColors[index] : Colors.grey[300],
                                      foregroundColor: isPodium ? Colors.black : Colors.black87,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(
                                      row['name'],
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    trailing: Text(
                                      '${row['score']} pts',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF46178F),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF46178F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: isLastQuestion
                            ? () => ref.read(gameProvider.notifier).finishGame()
                            : () => ref.read(gameProvider.notifier).nextQuestion(),
                        child: Text(
                          isLastQuestion ? 'Finish Game' : 'Next Question',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  // PODIUM VIEW
  Widget _buildPodiumScreen(GameState gameState) {
    final podium = gameState.podium;

    return Scaffold(
      backgroundColor: const Color(0xFF2C0B5E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.emoji_events_rounded, size: 80, color: Color(0xFFFFD800)),
              const SizedBox(height: 8),
              const Text(
                'Congratulations!',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
              ),
              const Text(
                'Namma Kahoot Podium Finishers',
                style: TextStyle(color: Colors.white60, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),

              // Pillars structure
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 2nd Place (Silver)
                    if (podium.length > 1)
                      Expanded(
                        child: _buildPodiumPillar(
                          name: podium[1]['name'],
                          score: podium[1]['score'],
                          rank: '2nd',
                          color: const Color(0xFFC0C0C0),
                          height: 180,
                        ),
                      )
                    else
                      const Expanded(child: SizedBox.shrink()),
                    
                    // 1st Place (Gold)
                    if (podium.isNotEmpty)
                      Expanded(
                        child: _buildPodiumPillar(
                          name: podium[0]['name'],
                          score: podium[0]['score'],
                          rank: '1st',
                          color: const Color(0xFFFFD800),
                          height: 240,
                        ),
                      )
                    else
                      const Expanded(child: SizedBox.shrink()),

                    // 3rd Place (Bronze)
                    if (podium.length > 2)
                      Expanded(
                        child: _buildPodiumPillar(
                          name: podium[2]['name'],
                          score: podium[2]['score'],
                          rank: '3rd',
                          color: const Color(0xFFCD7F32),
                          height: 140,
                        ),
                      )
                    else
                      const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Return Home Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF46178F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
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

  Widget _buildPodiumPillar({
    required String name,
    required int score,
    required String rank,
    required Color color,
    required double height,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(
          '$score pts',
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))
            ],
          ),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                rank[0],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Stateful Timer Widget
class CountdownTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback onFinished;

  const CountdownTimer({super.key, required this.seconds, required this.onFinished});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _timeLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_timeLeft > 0) {
          setState(() => _timeLeft--);
        } else {
          _timer?.cancel();
          widget.onFinished();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF46178F),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$_timeLeft',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
