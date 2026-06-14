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
      div(attributes: {'style': 'background:#7F77DD;padding:40px 20px 48px;text-align:center;'}, [
        div(attributes: {'style': 'width:64px;height:64px;background:rgba(255,255,255,.2);border-radius:18px;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;'}, [
          i(classes: 'ti ti-bolt', attributes: {'style': 'font-size:36px;color:#fff;'}, [])
        ]),
        div(attributes: {'style': 'font-size:28px;font-weight:600;color:#fff;'}, [Component.text('Join a game')]),
        div(attributes: {'style': 'font-size:14px;color:#CECBF6;margin-top:8px;'}, [Component.text('Enter the PIN on screen')])
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
              div(classes: 'row', attributes: {'style': 'gap:12px;'}, [
                div(classes: 'av av-md av-p', [Component.text(username.isNotEmpty ? username[0].toUpperCase() : '?')]),
                input(classes: 'finput', attributes: {
                  'type': 'text',
                  'placeholder': 'Nickname',
                  'style': 'flex:1;'
                }, events: {
                  'input': (e) => setState(() => username = (e.target as dynamic).value ?? ''),
                }),
              ])
            ]),
            button(
              classes: 'btn btn-prim btn-full mt20 ${isJoining ? "disabled" : ""}',
              attributes: {'style': 'font-size:16px;padding:14px;'},
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
      div(attributes: {'style': 'background:#7F77DD;padding:40px 20px;text-align:center;'}, [
        div(classes: 'chip chip-live', attributes: {'style': 'background:rgba(255,255,255,.2);color:#fff;margin-bottom:16px;'}, [
          span(classes: 'live-dot', attributes: {'style': 'background:#fff;width:8px;height:8px;'}, []), Component.text(' Connected')
        ]),
        div(classes: 'av av-lg av-p', attributes: {'style': 'margin:0 auto 12px;width:72px;height:72px;font-size:24px;'}, [
          Component.text(gameState.currentPlayer?.name.isNotEmpty == true ? gameState.currentPlayer!.name[0].toUpperCase() : '?')
        ]),
        div(attributes: {'style': 'font-size:24px;font-weight:600;color:#fff;'}, [Component.text(gameState.currentPlayer?.name ?? username)]),
        div(attributes: {'style': 'font-size:14px;color:#CECBF6;margin-top:6px;'}, [Component.text('PIN ${gameState.session?.pin}')]),
      ]),
      div(classes: 'content-wrap p20', [
        div(classes: 'card', attributes: {'style': 'text-align:center;padding:32px 20px;margin-bottom:16px;'}, [
          i(classes: 'ti ti-dots', attributes: {'style': 'font-size:36px;color:#7F77DD;animation:pulse 1.5s infinite;'}, []),
          div(classes: 't-body mt12', attributes: {'style': 'font-weight:500;font-size:16px;'}, [Component.text('Waiting for host to start')]),
          div(classes: 't-sub mt8', [Component.text('${gameState.players.length} players in the room')])
        ]),
        div(classes: 'pgrid', [
          for (final pl in gameState.players)
            div(classes: 'pbadge ${pl.id == gameState.currentPlayer?.id ? "new" : ""}', attributes: pl.id == gameState.currentPlayer?.id ? {'style': 'border:2px solid #7F77DD;'} : {}, [
              div(classes: 'pbadge-av av-t', attributes: pl.id == gameState.currentPlayer?.id ? {'style': 'background:#EEEDFE;color:#3C3489;'} : {}, [
                Component.text(pl.name.isNotEmpty ? pl.name[0].toUpperCase() : '?')
              ]),
              div(classes: 'pbadge-n', attributes: pl.id == gameState.currentPlayer?.id ? {'style': 'color:#7F77DD;font-weight:600;'} : {}, [
                Component.text(pl.id == gameState.currentPlayer?.id ? 'You' : pl.name)
              ])
            ])
        ])
      ])
    ]);
  }

  Component _buildQuestionScreen(BuildContext context, GameState gameState) {
    final currentQuestionIndex = gameState.session?.currentQuestionIndex ?? 0;
    if (currentQuestionIndex >= gameState.questions.length) {
      return div(classes: 'scr on flex-center', [Component.text('Waiting for question...')]);
    }
    final question = gameState.questions[currentQuestionIndex];

    return div(classes: 'scr on', [
      div(attributes: {'style': 'padding:16px 20px;border-bottom:0.5px solid var(--color-border-tertiary);background:var(--color-background-primary);'}, [
        div(classes: 'content-wrap', [
          div(classes: 'frow mb12', [
            div(classes: 'chip chip-p', [Component.text('Q ${currentQuestionIndex + 1} of ${gameState.questions.length}')]),
            div(classes: 'row', attributes: {'style': 'gap:12px;'}, [
              div(classes: 'streak', [i(classes: 'ti ti-flame', attributes: {'style': 'font-size:14px;'}, []), Component.text(' ${gameState.currentPlayer?.score ?? 0} pts')])
            ])
          ]),
          div(classes: 'prog', [div(classes: 'prog-fill', attributes: {'style': 'width:${((currentQuestionIndex + 1) / gameState.questions.length) * 100}%'}, [])])
        ])
      ]),
      div(classes: 'content-wrap p20 flex-1', [
        div(classes: 'card mb20', attributes: {'style': 'padding:24px 20px;text-align:center;'}, [
          div(classes: 't-title', attributes: {'style': 'font-size:20px;'}, [Component.text(question.text)])
        ]),
        div(classes: 'tiles-grid', [
          if (question.options.length > 0)
            button(classes: 'tile ta', events: {'click': (e) => context.read(gameProvider.notifier).submitAnswer(0)}, [
              div(classes: 'tile-icon', [i(classes: 'ti ti-triangle', [])]), span(classes: 'tile-text', [Component.text(question.options[0])])
            ]),
          if (question.options.length > 1)
            button(classes: 'tile tb', events: {'click': (e) => context.read(gameProvider.notifier).submitAnswer(1)}, [
              div(classes: 'tile-icon', [i(classes: 'ti ti-circle', [])]), span(classes: 'tile-text', [Component.text(question.options[1])])
            ]),
          if (question.options.length > 2)
            button(classes: 'tile tc', events: {'click': (e) => context.read(gameProvider.notifier).submitAnswer(2)}, [
              div(classes: 'tile-icon', [i(classes: 'ti ti-square', [])]), span(classes: 'tile-text', [Component.text(question.options[2])])
            ]),
          if (question.options.length > 3)
            button(classes: 'tile td', events: {'click': (e) => context.read(gameProvider.notifier).submitAnswer(3)}, [
              div(classes: 'tile-icon', [i(classes: 'ti ti-diamond', [])]), span(classes: 'tile-text', [Component.text(question.options[3])])
            ]),
        ]),
        div(attributes: {'style': 'text-align:center;margin-top:16px;'}, [
          span(classes: 't-sub', [Component.text('Tap a tile to answer')])
        ])
      ])
    ]);
  }

  Component _buildWaitingScreen(BuildContext context, GameState gameState) {
    return div(classes: 'scr on', [
      div(classes: 'content-wrap p20 flex-col flex-center h-full', attributes: {'style': 'flex:1;justify-content:center;'}, [
        div(classes: 'banner banner-ok', attributes: {'style': 'flex-direction:column;padding:32px 24px;text-align:center;width:100%;max-width:400px;margin:0 auto;'}, [
          i(classes: 'ti ti-check', attributes: {'style': 'font-size:48px;color:#1D9E75;margin-bottom:12px;'}, []),
          div(classes: 't-hero', attributes: {'style': 'font-size:24px;color:#085041;margin-bottom:8px;'}, [Component.text('Answer locked in!')]),
          div(classes: 't-body', attributes: {'style': 'color:#0F6E56;'}, [Component.text('Waiting for others to finish...')]),
        ]),
        div(classes: 'mt20', attributes: {'style': 'text-align:center;'}, [
          div(classes: 't-label', [Component.text('Current Score')]),
          div(classes: 't-num mt8', attributes: {'style': 'color:#7F77DD;font-size:36px;'}, [Component.text('${gameState.currentPlayer?.score ?? 0}')])
        ])
      ])
    ]);
  }

  Component _buildResultScreen(BuildContext context, GameState gameState) {
    final isCorrect = gameState.submittedAnswerIndex == gameState.correctOptionIndex;
    final points = gameState.earnedPoints ?? 0;

    return div(classes: 'scr on', [
      div(classes: 'content-wrap p20 flex-col flex-center h-full', attributes: {'style': 'flex:1;justify-content:center;'}, [
        div(classes: 'banner ${isCorrect ? "banner-ok" : "banner-err"}', attributes: {'style': 'flex-direction:column;padding:40px 24px;text-align:center;width:100%;max-width:400px;margin:0 auto;'}, [
          i(classes: isCorrect ? 'ti ti-check-circle' : 'ti ti-circle-x', attributes: {'style': 'font-size:56px;color:${isCorrect ? "#1D9E75" : "#D85A30"};margin-bottom:16px;'}, []),
          div(classes: 't-hero', attributes: {'style': 'font-size:32px;color:${isCorrect ? "#085041" : "#712B13"};margin-bottom:12px;'}, [
            Component.text(isCorrect ? 'Correct!' : 'Wrong!')
          ]),
          div(classes: 'streak', [
            i(classes: isCorrect ? 'ti ti-trending-up' : 'ti ti-trending-down', attributes: {'style': 'font-size:16px;'}, []),
            Component.text(isCorrect ? '+$points points' : '0 points')
          ])
        ]),
        div(classes: 'mt20', attributes: {'style': 'text-align:center;'}, [
          div(classes: 't-label', [Component.text('Total Score')]),
          div(classes: 't-num mt8', attributes: {'style': 'color:#7F77DD;font-size:42px;'}, [Component.text('${gameState.currentPlayer?.score ?? 0}')])
        ])
      ])
    ]);
  }

  Component _buildFinishScreen(BuildContext context, GameState gameState) {
    return div(classes: 'scr on', [
      div(attributes: {'style': 'background:#7F77DD;padding:40px 20px 32px;text-align:center;'}, [
        div(classes: 'chip', attributes: {'style': 'background:rgba(255,255,255,.2);color:#fff;margin-bottom:16px;'}, [
          i(classes: 'ti ti-trophy', attributes: {'style': 'font-size:14px;'}, []), Component.text(' Game over')
        ]),
        div(attributes: {'style': 'font-size:32px;font-weight:600;color:#fff;'}, [Component.text('Final results')]),
        div(attributes: {'style': 'font-size:14px;color:#CECBF6;margin-top:6px;'}, [Component.text(gameState.currentPlayer?.name ?? 'Player')])
      ]),
      div(classes: 'content-wrap p20 flex-1', [
        div(classes: 'card', attributes: {'style': 'padding:24px;text-align:center;background:#EEEDFE;border-color:#AFA9EC;margin-bottom:20px;'}, [
          div(classes: 't-label', attributes: {'style': 'color:#534AB7;margin-bottom:8px;'}, [Component.text('Your final score')]),
          div(attributes: {'style': 'font-size:48px;font-weight:700;color:#3C3489;'}, [Component.text('${gameState.currentPlayer?.score ?? 0}')]),
        ]),
        button(
          classes: 'btn btn-white btn-full',
          attributes: {'style': 'font-size:16px;padding:16px;'},
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
