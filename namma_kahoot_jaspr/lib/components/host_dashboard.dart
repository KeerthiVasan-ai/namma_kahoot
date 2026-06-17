import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:namma_kahoot_client/namma_kahoot_client.dart';
import '../providers/client_provider.dart';
import '../providers/game_provider.dart';
import 'countdown_timer.dart';

class HostDashboard extends StatefulComponent {
  const HostDashboard({super.key});

  @override
  State<HostDashboard> createState() => _HostDashboardState();
}

class _HostDashboardState extends State<HostDashboard> {
  List<Quiz> quizzes = [];
  bool loadingQuizzes = true;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    try {
      final fetched = await context.read(clientProvider).admin.getQuizzes();
      setState(() {
        quizzes = fetched;
        loadingQuizzes = false;
      });
    } catch (e) {
      setState(() => loadingQuizzes = false);
    }
  }

  @override
  Component build(BuildContext context) {
    final gameState = context.watch(gameProvider);

    if (gameState.session == null) {
      return _buildSelector(context);
    }

    final status = gameState.session?.status;
    final lastEvent = gameState.lastEvent;

    if (status == 'lobby') {
      return _buildLobby(context, gameState);
    } else if (lastEvent?.eventType == 'GAME_FINISHED') {
      return _buildPodium(context, gameState);
    } else if (lastEvent?.eventType == 'SHOW_LEADERBOARD') {
      return _buildLeaderboard(context, gameState);
    } else {
      final currentQuestionIndex = gameState.session?.currentQuestionIndex ?? 0;
      if (currentQuestionIndex < gameState.questions.length) {
        final currentQuestion = gameState.questions[currentQuestionIndex];
        if (gameState.correctOptionIndex != null) {
          return _buildQuestionResult(context, gameState, currentQuestion);
        } else {
          return _buildActiveQuestion(context, gameState, currentQuestion);
        }
      } else {
        return _buildPodium(context, gameState);
      }
    }
  }

  Component _buildSelector(BuildContext context) {
    return div(classes: 'scr on', [
      div(classes: 'topbar', [
        button(classes: 'btn btn-icon btn-white btn-sm', events: {'click': (e) => Router.of(context).push('/')}, [i(classes: 'ti ti-arrow-left', attributes: {'style': 'font-size:16px;'}, [])]),
        div(attributes: {'style': 'flex:1;margin-left:8px;'}, [
          div(attributes: {'style': 'font-size:16px;font-weight:600;color:var(--color-text-primary);'}, [Component.text('Host a Quiz')]),
        ]),
      ]),
      div(classes: 'content-wrap p20', [
        if (loadingQuizzes)
          div(classes: 'flex-center', attributes: {'style': 'padding:40px;'}, [Component.text('Loading quizzes...')])
        else if (quizzes.isEmpty)
          div(classes: 'card card-body', attributes: {'style': 'text-align:center;padding:40px 20px;'}, [
            i(classes: 'ti ti-clipboard-list', attributes: {'style': 'font-size:48px;color:var(--color-text-secondary);'}, []),
            div(classes: 't-title mt16', [Component.text('No quizzes found')]),
            div(classes: 't-sub mt8', [Component.text('Create a quiz in the Admin Dashboard first.')])
          ])
        else
          div(classes: 'gap8', [
            for (final quiz in quizzes)
              div(classes: 'card card-hover', attributes: {'style': 'padding:16px;cursor:pointer;'}, events: {
                'click': (e) => context.read(gameProvider.notifier).hostGame(quiz.id!)
              }, [
                div(classes: 'row', attributes: {'style': 'gap:12px;'}, [
                  div(attributes: {'style': 'width:44px;height:44px;background:#EEEDFE;border-radius:12px;display:flex;align-items:center;justify-content:center;flex-shrink:0;'}, [
                    i(classes: 'ti ti-bolt', attributes: {'style': 'font-size:24px;color:#534AB7;'}, [])
                  ]),
                  div(attributes: {'style': 'flex:1;'}, [
                    div(classes: 't-body', attributes: {'style': 'font-weight:600;font-size:15px;'}, [Component.text(quiz.title)]),
                    div(classes: 't-sub mt4', [Component.text(quiz.description ?? 'A general trivia challenge')])
                  ]),
                  div(classes: 'chip chip-t', [Component.text('Select')])
                ])
              ])
          ])
      ])
    ]);
  }

  Component _buildLobby(BuildContext context, GameState gameState) {
    return div(classes: 'scr on bg-pattern', [
      div(classes: 'topbar', attributes: {'style': 'background:rgba(255,255,255,0.9);'}, [
        div(attributes: {'style': 'flex:1;'}, [
          div(classes: 'topbar-title', [Component.text('Lobby')]),
          div(classes: 't-sub', [Component.text('Waiting for players')])
        ]),
        div(classes: 'chip chip-live', [
          span(classes: 'live-dot', attributes: {'style': 'margin-right:6px;'}, []), Component.text('Live')
        ])
      ]),
      div(classes: 'content-wrap p20 flex-col', attributes: {'style': 'flex:1;display:flex;flex-direction:column;'}, [
        // 1. Centered PIN Block at the top
        div(classes: 'pin-block mb20', attributes: {'style': 'margin: 40px auto; width: 100%;'}, [
          div(classes: 'pin-label-t', [Component.text('Join with Game PIN:')]),
          div(classes: 'pin-digits', [Component.text(gameState.session?.pin ?? '...')]),
        ]),
        
        // 2. Action Bar (Players count on left, Start button on right)
        div(classes: 'frow mb20', attributes: {'style': 'padding: 0 10px;'}, [
          div(attributes: {'style': 'background:rgba(0,0,0,0.3);color:#fff;padding:12px 24px;border-radius:8px;font-weight:700;font-size:24px;display:flex;align-items:center;'}, [
            i(classes: 'ti ti-users', attributes: {'style': 'margin-right:12px;font-size:28px;'}, []),
            Component.text('${gameState.players.length}')
          ]),
          button(
            classes: 'btn ${gameState.players.isEmpty ? "disabled" : ""}',
            attributes: {'style': 'font-size:20px;font-weight:800;padding:16px 40px;background:#333;color:#fff;border-radius:8px;box-shadow:0 6px 0 #000;'},
            events: {
              'click': (e) {
                if (gameState.players.isNotEmpty) context.read(gameProvider.notifier).startQuestion();
              }
            },
            [Component.text('Start')]
          )
        ]),

        // 3. Player Grid filling the rest
        div(classes: 'pgrid flex-1', attributes: {'style': 'align-content:flex-start;gap:24px;padding: 20px 10px;'}, [
          for (final pl in gameState.players)
            div(classes: 'jump-anim new', attributes: {'style': 'display:flex;flex-direction:column;align-items:center;'}, [
              div(classes: 'av av-lg', attributes: {'style': 'background:#ffffff;color:var(--kahoot-purple);margin-bottom:8px;box-shadow:0 4px 0 rgba(0,0,0,0.15);font-weight:900;font-size:28px;'}, [
                Component.text(pl.name.isNotEmpty ? pl.name[0].toUpperCase() : '?')
              ]),
              div(attributes: {'style': 'text-align:center;font-size:20px;font-weight:800;color:#fff;text-shadow:1px 1px 3px rgba(0,0,0,0.3);word-break:break-word;'}, [
                Component.text(pl.name)
              ])
            ])
        ])
      ])
    ]);
  }

  Component _buildActiveQuestion(BuildContext context, GameState gameState, Question question) {
    final totalAnswers = gameState.answerCounts.values.fold(0, (a, b) => a + b);
    return div(classes: 'scr on bg-pattern', attributes: {'style': 'display:flex;flex-direction:column;min-height:100vh;'}, [
      div(classes: 'content-wrap p20', attributes: {'style': 'flex:1;display:flex;flex-direction:column;'}, [
        // Question Card
        div(classes: 'card', attributes: {'style': 'padding:32px 20px;text-align:center;background:#fff;border-radius:8px;box-shadow:0 8px 16px rgba(0,0,0,0.2);flex-shrink:0;'}, [
          div(classes: 't-label mb8', [Component.text('Question ${question.orderIndex + 1} of ${gameState.questions.length}')]),
          div(classes: 't-title', attributes: {'style': 'font-size:32px;font-weight:800;color:#333;'}, [Component.text(question.text)])
        ]),
        
        // Timer and Answers Row (Expands to push content apart, min-height to prevent overlap)
        div(classes: 'frow', attributes: {'style': 'flex:1;align-items:center;min-height:120px;margin:20px 0;'}, [
          div(attributes: {'style': 'width:80px;height:80px;background:var(--kahoot-purple);border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-size:36px;font-weight:900;box-shadow:0 6px 0 rgba(0,0,0,0.2);flex-shrink:0;'}, [
            CountdownTimer(
              key: Key('timer_${question.orderIndex}'),
              seconds: question.timeLimitSeconds,
              onFinished: () => context.read(gameProvider.notifier).endQuestion(),
            )
          ]),
          div(attributes: {'style': 'text-align:center;background:#fff;padding:12px 24px;border-radius:8px;box-shadow:0 4px 0 rgba(0,0,0,0.1);min-width:120px;flex-shrink:0;'}, [
            div(classes: 't-sub', attributes: {'style': 'font-weight:700;font-size:16px;margin-bottom:4px;'}, [Component.text('Answers')]),
            div(attributes: {'style': 'font-size:42px;font-weight:900;color:#333;line-height:1;'}, [
              Component.text('$totalAnswers')
            ])
          ])
        ]),
        
        // Answers Grid
        div(classes: 'tiles-grid', attributes: {'style': 'flex-shrink:0;'}, [
          if (question.options.length > 0)
            div(classes: 'tile ta', [div(classes: 'tile-icon', [i(classes: 'ti ti-triangle-filled', [])]), span(classes: 'tile-text', [Component.text(question.options[0])])]),
          if (question.options.length > 1)
            div(classes: 'tile tb', [div(classes: 'tile-icon', [i(classes: 'ti ti-diamond-filled', [])]), span(classes: 'tile-text', [Component.text(question.options[1])])]),
          if (question.options.length > 2)
            div(classes: 'tile tc', [div(classes: 'tile-icon', [i(classes: 'ti ti-circle-filled', [])]), span(classes: 'tile-text', [Component.text(question.options[2])])]),
          if (question.options.length > 3)
            div(classes: 'tile td', [div(classes: 'tile-icon', [i(classes: 'ti ti-square-filled', [])]), span(classes: 'tile-text', [Component.text(question.options[3])])]),
        ]),
        
        // Skip Button
        div(attributes: {'style': 'margin-top:20px;text-align:center;flex-shrink:0;'}, [
          button(
            classes: 'btn btn-ghost',
            attributes: {'style': 'font-size:16px;font-weight:700;padding:12px 24px;border-radius:4px;display:inline-flex;align-items:center;justify-content:center;'},
            events: {'click': (e) => context.read(gameProvider.notifier).endQuestion()},
            [i(classes: 'ti ti-eye', attributes: {'style': 'margin-right:8px;'}, []), Component.text('Skip Timer')]
          )
        ])
      ])
    ]);
  }

  Component _buildQuestionResult(BuildContext context, GameState gameState, Question question) {
    return div(classes: 'scr on', [
      div(classes: 'topbar', [
        div(classes: 'chip chip-p', [Component.text('Q ${question.orderIndex + 1} of ${gameState.questions.length} — results')]),
        div(classes: 'spacer', []),
        button(classes: 'btn btn-prim btn-sm', events: {
          'click': (e) => context.read(gameProvider.notifier).showLeaderboard()
        }, [Component.text('Leaderboard '), i(classes: 'ti ti-arrow-right', [])])
      ]),
      div(classes: 'content-wrap p20 flex-col', attributes: {'style': 'flex:1;'}, [
        div(classes: 'card mb12', attributes: {'style': 'padding:20px;text-align:center;'}, [
          div(classes: 't-sub mb8', [Component.text('Question ${question.orderIndex + 1}')]),
          div(classes: 't-title', attributes: {'style': 'font-size:20px;'}, [Component.text(question.text)])
        ]),
        div(classes: 'banner banner-ok mb20', [
          div(classes: 'tile-icon', attributes: {'style': 'width:48px;height:48px;background:#1D9E75;border-radius:12px;flex-shrink:0;'}, [
            i(classes: 'ti ti-check', attributes: {'style': 'font-size:24px;color:#fff;'}, [])
          ]),
          div(attributes: {'style': 'flex:1;margin-left:8px;'}, [
            div(attributes: {'style': 'font-size:16px;font-weight:600;color:#085041;margin-bottom:4px;'}, [Component.text('Correct Answer: ${question.options[gameState.correctOptionIndex!]}')]),
            div(attributes: {'style': 'font-size:13px;color:#0F6E56;'}, [Component.text('${gameState.answerCounts[gameState.correctOptionIndex]} players answered correctly')])
          ])
        ]),
        div(classes: 't-label mb12', [Component.text('Answer distribution')]),
        div(classes: 'card mb20', attributes: {'style': 'padding:16px;'}, [
          _buildChartBar('A', gameState.answerCounts[0] ?? 0, gameState.players.length, 'var(--kahoot-red)'),
          _buildChartBar('B', gameState.answerCounts[1] ?? 0, gameState.players.length, 'var(--kahoot-blue)'),
          _buildChartBar('C', gameState.answerCounts[2] ?? 0, gameState.players.length, 'var(--kahoot-yellow)'),
          _buildChartBar('D', gameState.answerCounts[3] ?? 0, gameState.players.length, 'var(--kahoot-green)'),
        ]),
        div(classes: 'spacer', []),
        button(
          classes: 'btn btn-full',
          attributes: {'style': 'font-size:18px;font-weight:700;padding:16px;background:#333;color:#fff;border-radius:4px;box-shadow:0 4px 0 #000;'},
          events: {'click': (e) => context.read(gameProvider.notifier).showLeaderboard()},
          [Component.text('Next (Leaderboard)')]
        )
      ])
    ]);
  }

  Component _buildChartBar(String label, int count, int total, String color) {
    final pct = total > 0 ? (count / total) * 100 : 0;
    return div(classes: 'bar-item', [
      div(classes: 'bar-key', attributes: {'style': 'background:$color;'}, [Component.text(label)]),
      div(classes: 'bar-track', [
        div(classes: 'bar-fill', attributes: {'style': 'width:${pct > 0 ? pct : 2}%;background:$color;'}, [
          if (count > 0) Component.text('$count')
        ])
      ]),
      span(classes: 'bar-pct', [Component.text('${pct.round()}%')])
    ]);
  }

  Component _buildLeaderboard(BuildContext context, GameState gameState) {
    final isLastQuestion = gameState.session?.currentQuestionIndex == gameState.questions.length - 1;
    return div(classes: 'scr on', [
      div(classes: 'topbar', [
        div(classes: 'topbar-title', attributes: {'style': 'flex:1;'}, [Component.text('Leaderboard')]),
        button(classes: 'btn btn-prim btn-sm', events: {
          'click': (e) {
            if (isLastQuestion) context.read(gameProvider.notifier).finishGame();
            else context.read(gameProvider.notifier).nextQuestion();
          }
        }, [Component.text('Next '), i(classes: 'ti ti-arrow-right', [])])
      ]),
      div(classes: 'content-wrap p20 flex-col', attributes: {'style': 'flex:1;'}, [
        div(classes: 'card', attributes: {'style': 'padding:16px 20px;'}, [
          if (gameState.leaderboard.isEmpty)
            div(classes: 'flex-center text-gray', attributes: {'style': 'padding:40px;'}, [Component.text('No answers submitted yet.')])
          else
            for (var idx = 0; idx < gameState.leaderboard.length; idx++)
              div(classes: 'lb-item', [
                div(classes: 'lb-rank ${idx == 0 ? "rank-gold" : idx == 1 ? "rank-silver" : idx == 2 ? "rank-bronze" : ""}', [
                  if (idx == 0) i(classes: 'ti ti-crown', attributes: {'style': 'font-size:18px;'}, []) else Component.text('${idx + 1}')
                ]),
                div(classes: 'av av-md ${idx % 2 == 0 ? "av-p" : "av-t"}', [Component.text('${gameState.leaderboard[idx]['name']}'.isNotEmpty ? '${gameState.leaderboard[idx]['name']}'[0].toUpperCase() : '?')]),
                div(classes: 'lb-name', attributes: {'style': 'font-weight:600;margin-left:8px;'}, [Component.text('${gameState.leaderboard[idx]['name']}')]),
                div(classes: 'lb-pts', [Component.text('${gameState.leaderboard[idx]['score']}')])
              ])
        ]),
        div(classes: 'spacer', []),
        button(
          classes: 'btn btn-prim btn-full mt20',
          attributes: {'style': 'font-size:16px;padding:14px;'},
          events: {
            'click': (e) {
              if (isLastQuestion) {
                context.read(gameProvider.notifier).finishGame();
              } else {
                context.read(gameProvider.notifier).nextQuestion();
              }
            }
          },
          [Component.text(isLastQuestion ? 'Finish Game' : 'Next Question')]
        )
      ])
    ]);
  }

  Component _buildPodium(BuildContext context, GameState gameState) {
    final podium = gameState.podium;
    return div(classes: 'scr on bg-pattern', [
      div(attributes: {'style': 'padding:40px 20px 24px;'}, [
        div(classes: 'content-wrap', attributes: {'style': 'text-align:center;'}, [
          div(attributes: {'style': 'font-size:48px;font-weight:900;color:#fff;text-shadow:2px 2px 4px rgba(0,0,0,0.3);'}, [Component.text('Podium')]),
        ]),
        div(classes: 'content-wrap podium mt20', [
          if (podium.length > 1)
            div(classes: 'pod-col', [
              div(classes: 'av av-md av-t', [Component.text('${podium[1]['name']}'[0].toUpperCase())]),
              div(classes: 'pod-step pod-step-2', [div(classes: 'pod-num', [Component.text('2')])]),
              div(classes: 'pod-name', attributes: {'style': 'color:#CECBF6;'}, [Component.text('${podium[1]['name']}')])
            ]),
          if (podium.isNotEmpty)
            div(classes: 'pod-col', [
              i(classes: 'ti ti-crown', attributes: {'style': 'font-size:24px;color:#FAC775;'}, []),
              div(classes: 'av av-lg av-p', [Component.text('${podium[0]['name']}'[0].toUpperCase())]),
              div(classes: 'pod-step pod-step-1', [div(classes: 'pod-num', [Component.text('1')])]),
              div(classes: 'pod-name', attributes: {'style': 'color:#CECBF6;'}, [Component.text('${podium[0]['name']}')])
            ]),
          if (podium.length > 2)
            div(classes: 'pod-col', [
              div(classes: 'av av-sm av-a', [Component.text('${podium[2]['name']}'[0].toUpperCase())]),
              div(classes: 'pod-step pod-step-3', [div(classes: 'pod-num', [Component.text('3')])]),
              div(classes: 'pod-name', attributes: {'style': 'color:#CECBF6;'}, [Component.text('${podium[2]['name']}')])
            ]),
        ])
      ]),
      div(classes: 'content-wrap p20 flex-col', attributes: {'style': 'flex:1;'}, [
        if (podium.isNotEmpty)
          div(classes: 'card mb20', attributes: {'style': 'padding:16px 20px;background:#EEEDFE;border-color:#AFA9EC;'}, [
            div(classes: 'row', attributes: {'style': 'gap:16px;'}, [
              div(classes: 'av av-lg av-p', [Component.text('${podium[0]['name']}'[0].toUpperCase())]),
              div(attributes: {'style': 'flex:1;'}, [
                div(attributes: {'style': 'font-size:18px;font-weight:600;color:#3C3489;margin-bottom:4px;'}, [Component.text('${podium[0]['name']} wins!')]),
                div(attributes: {'style': 'font-size:14px;color:#534AB7;'}, [Component.text('${podium[0]['score']} pts')])
              ]),
              i(classes: 'ti ti-crown', attributes: {'style': 'font-size:32px;color:#7F77DD;'}, [])
            ])
          ]),
        div(classes: 'stats-row mb20', [
          div(classes: 'stat', [div(classes: 'stat-v', [Component.text('${gameState.players.length}')]), div(classes: 'stat-l', [Component.text('Players')])]),
          div(classes: 'stat', [div(classes: 'stat-v', [Component.text('${gameState.questions.length}')]), div(classes: 'stat-l', [Component.text('Questions')])]),
        ]),
        div(classes: 'spacer', []),
        div(attributes: {'style': 'display:flex;gap:12px;'}, [
          button(classes: 'btn btn-prim', attributes: {'style': 'flex:1;padding:14px;'}, events: {
            'click': (e) {
              context.read(gameProvider.notifier).reset();
              Router.of(context).push('/host');
            }
          }, [i(classes: 'ti ti-refresh', []), Component.text(' Play again')]),
          button(classes: 'btn btn-white', attributes: {'style': 'flex:1;padding:14px;'}, events: {
            'click': (e) {
              context.read(gameProvider.notifier).reset();
              Router.of(context).push('/');
            }
          }, [i(classes: 'ti ti-home', []), Component.text(' Dashboard')]),
        ])
      ])
    ]);
  }
}
