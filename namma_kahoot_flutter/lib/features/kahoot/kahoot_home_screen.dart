import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../admin/admin_dashboard_screen.dart';
import 'host_dashboard_screen.dart';
import 'player_board_screen.dart';
import 'providers/game_provider.dart';

class KahootHomeScreen extends ConsumerStatefulWidget {
  final String? initialPin;
  final String? initialRole;

  const KahootHomeScreen({super.key, this.initialPin, this.initialRole});

  @override
  ConsumerState<KahootHomeScreen> createState() => _KahootHomeScreenState();
}

class _KahootHomeScreenState extends ConsumerState<KahootHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Reset provider state when landing on home screen
    Future.microtask(() {
      ref.read(gameProvider.notifier).reset();
    });

    if (widget.initialPin != null || widget.initialRole == 'host') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.initialRole == 'host') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HostDashboardScreen()));
        } else if (widget.initialPin != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerBoardScreen()));
        }
      });
    }
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C0B5E), Color(0xFF46178F), Color(0xFF1368CE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Header Area
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 2),
                          ),
                          child: const Icon(
                            Icons.bolt,
                            size: 80,
                            color: Color(0xFFFFD800), // Glowing gold
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Namma Kahoot',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'The Ultimate Real-Time Quiz Experience',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menu Options
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      children: [
                        _buildMenuCard(
                          title: 'Join Game',
                          subtitle: 'Enter a PIN to play general knowledge trivia',
                          icon: Icons.play_arrow_rounded,
                          color: const Color(0xFF26890C), // Green
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerBoardScreen()));
                          },
                        ),
                        _buildMenuCard(
                          title: 'Host a Game',
                          subtitle: 'Launch a trivia quiz on the big screen',
                          icon: Icons.tv_rounded,
                          color: const Color(0xFF1368CE), // Blue
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const HostDashboardScreen()));
                          },
                        ),
                        _buildMenuCard(
                          title: 'Admin Dashboard',
                          subtitle: 'Create, edit or delete custom quizzes',
                          icon: Icons.dashboard_customize_rounded,
                          color: const Color(0xFFE21B3C), // Red
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  Text(
                    'Connected to local Docker serverpod',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.5),
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
}
