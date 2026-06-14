import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'home_page.dart';
import 'host_dashboard.dart';
import 'player_board.dart';
import 'admin_dashboard.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'nk', [
      div(classes: 'shell', [
        Router(routes: [
          Route(path: '/', title: 'Namma Kahoot', builder: (context, state) => const HomePage()),
          Route(path: '/play', title: 'Player - Namma Kahoot', builder: (context, state) => const PlayerBoard()),
          Route(path: '/host', title: 'Host - Namma Kahoot', builder: (context, state) => const HostDashboard()),
          Route(path: '/admin', title: 'Admin - Namma Kahoot', builder: (context, state) => const AdminDashboard()),
        ]),
      ]),
    ]);
  }
}
