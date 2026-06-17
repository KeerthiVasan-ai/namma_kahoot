import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'scr on', [
      div(classes: 'hero-bg bg-pattern', [
        div(
          attributes: {'style': 'margin-bottom:16px;'},
          [
            div(
              attributes: {
                'style': 'font-size:42px;font-weight:900;color:#fff;text-shadow:2px 2px 4px rgba(0,0,0,0.3);',
              },
              [Component.text('Namma Kahoot')],
            ),
          ],
        ),
        div(classes: 't-hero mb8', [Component.text('Quizzes for everyone.')]),
        div(
          classes: 't-sub mb16',
          attributes: {'style': 'font-size:15px;max-width:500px;margin:0 auto 24px;'},
          [Component.text('Real-time multiplayer quizzes — host, play, and share. Built in the open.')],
        ),
        div(
          attributes: {'style': 'display:flex;gap:12px;max-width:250px;margin:0 auto;width:100%;'},
          [
            button(
              classes: 'btn',
              attributes: {
                'style':
                    'flex:1;font-size:16px;font-weight:700;padding:16px;background:#ffffff;color:var(--kahoot-purple);border-radius:4px;box-shadow:0 4px 0 rgba(0,0,0,0.2);',
              },
              events: {'click': (e) => Router.of(context).push('/host')},
              [i(classes: 'ti ti-player-play', []), Component.text(' Host a quiz')],
            ),
          ],
        ),
      ]),

      div(classes: 'content-wrap p20', [
        div(
          attributes: {'style': 'position:relative;max-width:400px;margin:20px auto;padding:40px 20px;'},
          [
            // Floating background shapes
            div(
              classes: 'float-anim',
              attributes: {'style': 'position:absolute;top:20px;left:-20px;'},
              [
                i(
                  classes: 'ti ti-triangle-filled',
                  attributes: {'style': 'font-size:48px;color:var(--kahoot-red);transform:rotate(-15deg);'},
                  [],
                ),
              ],
            ),
            div(
              classes: 'float-anim delay-1',
              attributes: {'style': 'position:absolute;bottom:0px;left:-40px;'},
              [
                i(
                  classes: 'ti ti-diamond-filled',
                  attributes: {'style': 'font-size:56px;color:var(--kahoot-blue);transform:rotate(10deg);'},
                  [],
                ),
              ],
            ),
            div(
              classes: 'float-anim delay-2',
              attributes: {'style': 'position:absolute;top:-10px;right:-10px;'},
              [
                i(
                  classes: 'ti ti-circle-filled',
                  attributes: {'style': 'font-size:36px;color:var(--kahoot-yellow);'},
                  [],
                ),
              ],
            ),
            div(
              classes: 'float-anim delay-3',
              attributes: {'style': 'position:absolute;bottom:20px;right:-30px;'},
              [
                i(
                  classes: 'ti ti-square-filled',
                  attributes: {'style': 'font-size:42px;color:var(--kahoot-green);transform:rotate(15deg);'},
                  [],
                ),
              ],
            ),

            // Creative Join Card
            div(
              classes: 'card',
              attributes: {
                'style':
                    'background:#ffffff;border-radius:16px;padding:32px 24px;box-shadow:0 8px 30px rgba(0,0,0,0.15);position:relative;z-index:2;border:none;',
              },
              [
                div(
                  attributes: {'style': 'text-align:center;margin-bottom:24px;'},
                  [
                    div(
                      attributes: {'style': 'font-size:24px;font-weight:900;color:var(--color-text-primary);'},
                      [Component.text('Ready to play?')],
                    ),
                  ],
                ),
                button(
                  classes: 'btn btn-full',
                  attributes: {
                    'style':
                        'font-size:22px;font-weight:900;padding:20px;background:#333333;color:#fff;border-radius:8px;box-shadow:0 6px 0 #000;',
                  },
                  events: {'click': (e) => Router.of(context).push('/play')},
                  [Component.text('Enter Game PIN')],
                ),
              ],
            ),
          ],
        ),

        div(
          attributes: {
            'style': 'display:grid;grid-template-columns:repeat(auto-fit,minmax(120px,1fr));gap:12px;margin-top:24px;',
          },
          [
            div(
              classes: 'card card-body',
              attributes: {'style': 'text-align:center;padding:20px 12px;'},
              [
                i(classes: 'ti ti-antenna-bars-5', attributes: {'style': 'font-size:28px;color:#7F77DD;'}, []),
                div(
                  attributes: {
                    'style': 'font-size:15px;font-weight:600;color:var(--color-text-primary);margin-top:8px;',
                  },
                  [Component.text('Real-time')],
                ),
                div(
                  attributes: {'style': 'font-size:12px;color:var(--color-text-secondary);margin-top:4px;'},
                  [Component.text('WebSocket')],
                ),
              ],
            ),
            div(
              classes: 'card card-body',
              attributes: {'style': 'text-align:center;padding:20px 12px;'},
              [
                i(classes: 'ti ti-trophy', attributes: {'style': 'font-size:28px;color:#BA7517;'}, []),
                div(
                  attributes: {
                    'style': 'font-size:15px;font-weight:600;color:var(--color-text-primary);margin-top:8px;',
                  },
                  [Component.text('Leaderboard')],
                ),
                div(
                  attributes: {'style': 'font-size:12px;color:var(--color-text-secondary);margin-top:4px;'},
                  [Component.text('Live ranks')],
                ),
              ],
            ),
            div(
              classes: 'card card-body',
              attributes: {'style': 'text-align:center;padding:20px 12px;'},
              [
                i(classes: 'ti ti-brand-open-source', attributes: {'style': 'font-size:28px;color:#1D9E75;'}, []),
                div(
                  attributes: {
                    'style': 'font-size:15px;font-weight:600;color:var(--color-text-primary);margin-top:8px;',
                  },
                  [Component.text('Open source')],
                ),
                div(
                  attributes: {'style': 'font-size:12px;color:var(--color-text-secondary);margin-top:4px;'},
                  [Component.text('Self-host')],
                ),
              ],
            ),
          ],
        ),

        button(
          classes: 'btn btn-white btn-full mt20',
          attributes: {'style': 'font-size:16px;padding:16px;'},
          events: {'click': (e) => Router.of(context).push('/admin')},
          [Component.text('Go to Admin Dashboard '), i(classes: 'ti ti-arrow-right', [])],
        ),
      ]),

      // Footer Section
      footer(
        attributes: {
          'style':
              'background:#111111;color:#ffffff;padding:40px 20px 20px;margin-top:auto;font-family:var(--font-sans);',
        },
        [
          div(
            classes: 'content-wrap',
            attributes: {
              'style': 'display:flex;flex-wrap:wrap;gap:40px;justify-content:space-between;margin-bottom:40px;',
            },
            [
              div(
                attributes: {'style': 'flex:1;min-width:200px;'},
                [
                  div(
                    attributes: {
                      'style':
                          'font-size:24px;font-weight:800;margin-bottom:12px;display:flex;align-items:center;gap:8px;',
                    },
                    [
                      i(classes: 'ti ti-bolt', attributes: {'style': 'color:var(--kahoot-purple);'}, []),
                      Component.text('Namma Kahoot'),
                    ],
                  ),
                  JasprBadge.darkTwoTone(),
                ],
              ),
              div(
                attributes: {'style': 'flex:1;min-width:120px;'},
                [
                  div(
                    attributes: {'style': 'font-size:14px;font-weight:700;margin-bottom:16px;'},
                    [Component.text('Navigation')],
                  ),
                  div(
                    attributes: {'style': 'display:flex;flex-direction:column;gap:12px;font-size:14px;color:#a0a0a0;'},
                    [
                      a(
                        href: '/',
                        attributes: {'style': 'color:#a0a0a0;text-decoration:none;'},
                        [Component.text('Home')],
                      ),
                      a(
                        href: '/play',
                        attributes: {'style': 'color:#a0a0a0;text-decoration:none;'},
                        [Component.text('Play')],
                      ),
                      a(
                        href: '/host',
                        attributes: {'style': 'color:#a0a0a0;text-decoration:none;'},
                        [Component.text('Host')],
                      ),
                    ],
                  ),
                ],
              ),
              div(
                attributes: {'style': 'flex:1;min-width:120px;'},
                [
                  div(
                    attributes: {'style': 'font-size:14px;font-weight:700;margin-bottom:16px;'},
                    [Component.text('Community')],
                  ),
                  div(
                    attributes: {'style': 'display:flex;flex-direction:column;gap:12px;font-size:14px;color:#a0a0a0;'},
                    [
                      a(
                        href: 'https://github.com/KeerthiVasan-ai/namma_kahoot',
                        target: Target.blank,
                        attributes: {'style': 'color:#a0a0a0;text-decoration:none;'},
                        [Component.text('Project GitHub')],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          div(
            attributes: {
              'style': 'border-top:1px solid #333;padding-top:20px;font-size:12px;color:#666;text-align:left;',
            },
            [Component.text('Copyright © ${DateTime.now().year} Namma Kahoot | MIT License')],
          ),
        ],
      ),
    ]);
  }
}
