import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_router/jaspr_router.dart';
import '../providers/game_provider.dart';

class PlayerBoard extends StatefulComponent {
  const PlayerBoard({super.key});

  @override
  State<PlayerBoard> createState() => _PlayerBoardState();
}

class _PlayerBoardState extends State<PlayerBoard> {
  String pin = '';
  String username = '';
  bool isJoining = false;
  String? errorMessage;

  @override
  Component build(BuildContext context) {
    final gameState = context.watch(gameProvider);

    if (!gameState.isConnected) {
      return _buildJoinForm(context);
    }

    final lastEvent = gameState.lastEvent;

    // Game finished
    if (lastEvent?.eventType == 'GAME_FINISHED') {
      return _buildFinishScreen(context, gameState);
    }

    // Question ended - show result
    if (gameState.correctOptionIndex != null) {
      return _buildResultScreen(context, gameState);
    }

    // Answer submitted - waiting
    if (gameState.submittedAnswerIndex != null) {
      return _buildWaitingScreen(context, gameState);
    }

    // Active question
    if (gameState.session?.status == 'active') {
      return _buildQuestionScreen(context, gameState);
    }

    // Lobby - waiting for game to start
    return _buildLobbyScreen(context, gameState);
  }

  Component _buildJoinForm(BuildContext context) {
    return div(classes: 'scr on', [
      div(classes: 'bg-pattern', attributes: {'style': 'padding:60px 20px 80px;text-align:center;'}, [
        div(attributes: {'style': 'width:80px;height:80px;background:#ffffff;border-radius:24px;display:flex;align-items:center;justify-content:center;margin:0 auto 20px;box-shadow:0 8px 0 rgba(0,0,0,0.1);transform: rotate(-10deg);'}, [
          i(classes: 'ti ti-bolt', attributes: {'style': 'font-size:48px;color:var(--kahoot-purple);'}, [])
        ]),
        div(attributes: {'style': 'font-size:36px;font-weight:900;color:#fff;text-shadow:2px 2px 4px rgba(0,0,0,0.3);'}, [Component.text('Join Game')]),
      ]),
      div(classes: 'content-wrap', attributes: {'style': 'margin-top:-24px;position:relative;padding:0 20px;'}, [
        div(classes: 'card', [
          div(classes: 'card-body p20', [
            if (errorMessage != null)
              div(classes: 'banner banner-err mb12', [
                i(classes: 'ti ti-alert-circle', attributes: {'style': 'font-size:20px;color:#D85A30;'}, []),
                div(attributes: {'style': 'font-size:13px;color:#D85A30;font-weight:500;'}, [Component.text(errorMessage!)])
              ]),
            div(classes: 'fgroup', [
              label(classes: 'flabel', [Component.text('Game PIN')]),
              input(classes: 'finput', attributes: {
                'type': 'text',
                'placeholder': '4 8 2 0 1 6',
                'style': 'text-align:center;font-size:24px;letter-spacing:10px;font-family:var(--font-mono);height:56px;',
                'maxlength': '6'
              }, events: {
                'input': (e) => setState(() => pin = (e.target as dynamic).value ?? ''),
              }),
            ]),
            div(classes: 'fgroup mt16', [
              label(classes: 'flabel', [Component.text('Your nickname')]),
              input(classes: 'finput', attributes: {
                'type': 'text',
                'placeholder': 'Nickname',
                'style': 'text-align:center;font-size:20px;font-weight:700;height:56px;'
              }, events: {
                'input': (e) => setState(() => username = (e.target as dynamic).value ?? ''),
              }),
            ]),
            button(
              classes: 'btn btn-full mt20 ${isJoining ? "disabled" : ""}',
              attributes: {'style': 'font-size:18px;font-weight:700;padding:16px;background:#333333;color:#fff;border-radius:4px;box-shadow:0 4px 0 #000;'},
              events: {
                'click': (e) async {
                  if (pin.isEmpty || username.isEmpty || isJoining) return;
                  setState(() {
                    isJoining = true;
                    errorMessage = null;
                  });
                  final success = await context.read(gameProvider.notifier).joinGame(pin, username);
                  if (!success) {
                    setState(() {
                      isJoining = false;
                      errorMessage = 'Could not join game. Check PIN and try again.';
                    });
                  }
                }
              },
              [i(classes: 'ti ti-login', []), Component.text(isJoining ? 'Joining...' : 'Join game')]
            ),
            div(attributes: {'style': 'text-align:center;margin-top:16px;font-size:12px;color:var(--color-text-secondary);'}, [
              Component.text('No account needed')
            ])
          ])
        ])
      ])
    ]);
  }

  Component _buildLobbyScreen(BuildContext context, GameState gameState) {
    return div(classes: 'scr on', [
      div(classes: 'bg-pattern', attributes: {'style': 'padding:40px 20px;text-align:center;flex:1;display:flex;flex-direction:column;justify-content:center;'}, [
        div(attributes: {'style': 'font-size:36px;font-weight:900;color:#fff;margin-bottom:20px;'}, [Component.text('You\'re in!')]),
        div(attributes: {'style': 'font-size:24px;font-weight:700;color:#fff;'}, [Component.text(gameState.currentPlayer?.name ?? username)]),
        div(attributes: {'style': 'font-size:16px;color:rgba(255,255,255,.8);margin-top:20px;font-weight:600;'}, [Component.text('See your nickname on screen')]),
      ]),
    ]);
  }

  Component _buildQuestionScreen(BuildContext context, GameState gameState) {
    final currentQuestionIndex = gameState.session?.currentQuestionIndex ?? 0;
    if (currentQuestionIndex >= gameState.questions.length) {
      return div(classes: 'scr on bg-pattern flex-center', attributes: {'style':'color:#fff;font-size:24px;font-weight:700;'}, [Component.text('Get Ready!')]);
    }
    final question = gameState.questions[currentQuestionIndex];

    return div(classes: 'scr on bg-pattern', [
      div(classes: 'flex-col', attributes: {'style': 'flex:1;padding:8px;'}, [
        div(attributes: {'style': 'display:grid;grid-template-columns:1fr 1fr;grid-template-rows:1fr 1fr;gap:8px;flex:1;width:100%;height:100%;'}, [
          if (question.options.length > 0)
            button(classes: 'tile ta', attributes: {'style': 'display:flex;justify-content:center;align-items:center;padding:0;min-height:0;height:100%;box-shadow:inset 0 -8px 0 rgba(0,0,0,0.2);'}, events: {'click': (e) => context.read(gameProvider.notifier).submitAnswer(0)}, [
              i(classes: 'ti ti-triangle-filled', attributes: {'style':'font-size:min(30vw, 120px);color:#fff;'}, [])
            ]),
          if (question.options.length > 1)
            button(classes: 'tile tb', attributes: {'style': 'display:flex;justify-content:center;align-items:center;padding:0;min-height:0;height:100%;box-shadow:inset 0 -8px 0 rgba(0,0,0,0.2);'}, events: {'click': (e) => context.read(gameProvider.notifier).submitAnswer(1)}, [
              i(classes: 'ti ti-diamond-filled', attributes: {'style':'font-size:min(30vw, 120px);color:#fff;'}, [])
            ]),
          if (question.options.length > 2)
            button(classes: 'tile tc', attributes: {'style': 'display:flex;justify-content:center;align-items:center;padding:0;min-height:0;height:100%;box-shadow:inset 0 -8px 0 rgba(0,0,0,0.2);'}, events: {'click': (e) => context.read(gameProvider.notifier).submitAnswer(2)}, [
              i(classes: 'ti ti-circle-filled', attributes: {'style':'font-size:min(30vw, 120px);color:#fff;'}, [])
            ]),
          if (question.options.length > 3)
            button(classes: 'tile td', attributes: {'style': 'display:flex;justify-content:center;align-items:center;padding:0;min-height:0;height:100%;box-shadow:inset 0 -8px 0 rgba(0,0,0,0.2);'}, events: {'click': (e) => context.read(gameProvider.notifier).submitAnswer(3)}, [
              i(classes: 'ti ti-square-filled', attributes: {'style':'font-size:min(30vw, 120px);color:#fff;'}, [])
            ]),
        ])
      ])
    ]);
  }

  Component _buildWaitingScreen(BuildContext context, GameState gameState) {
    return div(classes: 'scr on bg-pattern flex-col flex-center h-full', attributes: {'style': 'flex:1;justify-content:center;color:#fff;'}, [
      div(attributes: {'style': 'font-size:32px;font-weight:900;margin-bottom:12px;'}, [Component.text('Waiting for others...')]),
      div(attributes: {'style': 'font-size:20px;font-weight:600;opacity:0.8;'}, [Component.text('You\'re fast!')])
    ]);
  }

  Component _buildResultScreen(BuildContext context, GameState gameState) {
    final isCorrect = gameState.submittedAnswerIndex == gameState.correctOptionIndex;
    final points = gameState.earnedPoints ?? 0;

    return div(classes: 'scr on flex-col flex-center h-full', attributes: {'style': 'flex:1;justify-content:center;background:${isCorrect ? "var(--kahoot-green)" : "var(--kahoot-red)"};color:#fff;'}, [
      i(classes: isCorrect ? 'ti ti-check' : 'ti ti-x', attributes: {'style': 'font-size:80px;font-weight:900;margin-bottom:16px;'}, []),
      div(attributes: {'style': 'font-size:48px;font-weight:900;margin-bottom:12px;'}, [
        Component.text(isCorrect ? 'Correct!' : 'Incorrect')
      ]),
      div(classes: 'chip', attributes: {'style':'background:rgba(0,0,0,0.2);color:#fff;font-size:20px;padding:8px 16px;font-weight:700;'}, [
        Component.text(isCorrect ? '+$points' : '0')
      ])
    ]);
  }

  Component _buildFinishScreen(BuildContext context, GameState gameState) {
    return div(classes: 'scr on bg-pattern', attributes: {'style': 'flex:1;'}, [
      div(attributes: {'style': 'padding:40px 20px 32px;text-align:center;'}, [
        div(attributes: {'style': 'font-size:48px;font-weight:900;color:#fff;text-shadow:2px 2px 0 rgba(0,0,0,0.2);'}, [Component.text('Podium')]),
      ]),
      div(classes: 'content-wrap p20 flex-1', [
        div(classes: 'card', attributes: {'style': 'padding:32px;text-align:center;background:#fff;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.2);margin-bottom:20px;'}, [
          div(attributes: {'style': 'color:var(--color-text-secondary);font-size:18px;font-weight:700;margin-bottom:8px;'}, [Component.text('Your final score')]),
          div(attributes: {'style': 'font-size:64px;font-weight:900;color:#333;'}, [Component.text('${gameState.currentPlayer?.score ?? 0}')]),
        ]),
        button(
          classes: 'btn btn-full',
          attributes: {'style': 'font-size:18px;font-weight:700;padding:16px;background:#333333;color:#fff;border-radius:4px;box-shadow:0 4px 0 #000;'},
          events: {
            'click': (e) {
              context.read(gameProvider.notifier).reset();
              Router.of(context).push('/');
            }
          },
          [i(classes: 'ti ti-home', []), Component.text(' Back to Home')]
        )
      ])
    ]);
  }
}
