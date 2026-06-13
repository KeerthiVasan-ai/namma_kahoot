import 'package:flutter/material.dart';
import '../admin/admin_dashboard_screen.dart';
import 'host_dashboard_screen.dart';
import 'player_board_screen.dart';

class KahootHomeScreen extends StatefulWidget {
  final String? initialPin;
  final String? initialRole;

  const KahootHomeScreen({super.key, this.initialPin, this.initialRole});

  @override
  State<KahootHomeScreen> createState() => _KahootHomeScreenState();
}

class _KahootHomeScreenState extends State<KahootHomeScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialPin != null || widget.initialRole == 'host') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.initialRole == 'host') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HostDashboardScreen()));
        } else if (widget.initialPin != null) {
          // Pre-fill logic could go here, or just push to player screen
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerBoardScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Namma Kahoot', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF46178f), // Kahoot purple
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26890C), // Kahoot green
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerBoardScreen()));
              },
              child: const Text('Join Game (Player)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1368CE), // Kahoot blue
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HostDashboardScreen()));
              },
              child: const Text('Host a Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE21B3C), // Kahoot red
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
              },
              child: const Text('Admin (Create Quiz)'),
            ),
          ],
        ),
      ),
    );
  }
}
