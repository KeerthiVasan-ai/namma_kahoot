import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'scr on', [
      div(classes: 'hero-bg', [
        div(attributes: {'style': 'margin-bottom:16px;display:flex;align-items:center;gap:12px;'}, [
          div(attributes: {'style': 'width:56px;height:56px;background:rgba(255,255,255,.2);border-radius:16px;display:flex;align-items:center;justify-content:center;'}, [
            i(classes: 'ti ti-bolt', attributes: {'style': 'font-size:32px;color:#fff;'}, [])
          ]),
          div(attributes: {'style': 'text-align:left;'}, [
            div(attributes: {'style': 'font-size:24px;font-weight:600;color:#fff;'}, [Component.text('Namma Kahoot')]),
            div(attributes: {'style': 'font-size:13px;color:#CECBF6;'}, [Component.text('Open source · Jaspr + Serverpod')]),
          ])
        ]),
        div(classes: 't-hero mb8', [Component.text('Quizzes for everyone.')]),
        div(classes: 't-sub mb16', attributes: {'style': 'font-size:15px;max-width:500px;margin:0 auto 24px;'}, [
          Component.text('Real-time multiplayer quizzes — host, play, and share. Built in the open.')
        ]),
        div(attributes: {'style': 'display:flex;gap:12px;max-width:400px;margin:0 auto;width:100%;'}, [
          button(classes: 'btn btn-ghost', attributes: {'style': 'flex:1;font-size:15px;padding:14px;'}, events: {
            'click': (e) => Router.of(context).push('/host')
          }, [
            i(classes: 'ti ti-player-play', []), Component.text(' Host a quiz')
          ]),
          button(classes: 'btn btn-ghost', attributes: {'style': 'flex:1;font-size:15px;padding:14px;'}, events: {
            'click': (e) => Router.of(context).push('/play')
          }, [
            i(classes: 'ti ti-login', []), Component.text(' Join with PIN')
          ])
        ])
      ]),
      
      div(classes: 'content-wrap p20', [
        div(classes: 'tiles-grid mt12', [
          div(classes: 'tile ta', [div(classes: 'tile-icon', [i(classes: 'ti ti-triangle', [])]), span(classes: 'tile-text', [Component.text('H₂O')])]),
          div(classes: 'tile tb', [div(classes: 'tile-icon', [i(classes: 'ti ti-circle', [])]), span(classes: 'tile-text', [Component.text('CO₂')])]),
          div(classes: 'tile tc', [div(classes: 'tile-icon', [i(classes: 'ti ti-square', [])]), span(classes: 'tile-text', [Component.text('O₂')])]),
          div(classes: 'tile td', [div(classes: 'tile-icon', [i(classes: 'ti ti-diamond', [])]), span(classes: 'tile-text', [Component.text('NaCl')])]),
        ]),
        
        div(attributes: {'style': 'display:grid;grid-template-columns:repeat(auto-fit,minmax(120px,1fr));gap:12px;margin-top:24px;'}, [
          div(classes: 'card card-body', attributes: {'style': 'text-align:center;padding:20px 12px;'}, [
            i(classes: 'ti ti-antenna-bars-5', attributes: {'style': 'font-size:28px;color:#7F77DD;'}, []),
            div(attributes: {'style': 'font-size:15px;font-weight:600;color:var(--color-text-primary);margin-top:8px;'}, [Component.text('Real-time')]),
            div(attributes: {'style': 'font-size:12px;color:var(--color-text-secondary);margin-top:4px;'}, [Component.text('WebSocket')])
          ]),
          div(classes: 'card card-body', attributes: {'style': 'text-align:center;padding:20px 12px;'}, [
            i(classes: 'ti ti-trophy', attributes: {'style': 'font-size:28px;color:#BA7517;'}, []),
            div(attributes: {'style': 'font-size:15px;font-weight:600;color:var(--color-text-primary);margin-top:8px;'}, [Component.text('Leaderboard')]),
            div(attributes: {'style': 'font-size:12px;color:var(--color-text-secondary);margin-top:4px;'}, [Component.text('Live ranks')])
          ]),
          div(classes: 'card card-body', attributes: {'style': 'text-align:center;padding:20px 12px;'}, [
            i(classes: 'ti ti-brand-open-source', attributes: {'style': 'font-size:28px;color:#1D9E75;'}, []),
            div(attributes: {'style': 'font-size:15px;font-weight:600;color:var(--color-text-primary);margin-top:8px;'}, [Component.text('Open source')]),
            div(attributes: {'style': 'font-size:12px;color:var(--color-text-secondary);margin-top:4px;'}, [Component.text('Self-host')])
          ])
        ]),

        button(classes: 'btn btn-white btn-full mt20', attributes: {'style': 'font-size:16px;padding:16px;'}, events: {
          'click': (e) => Router.of(context).push('/admin')
        }, [
          Component.text('Go to Admin Dashboard '), i(classes: 'ti ti-arrow-right', [])
        ]),
      ])
    ]);
  }
}
