import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:namma_kahoot_client/namma_kahoot_client.dart';
import '../providers/client_provider.dart';

class AdminDashboard extends StatefulComponent {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _titleInput = '';
  List<Quiz> quizzes = [];
  Quiz? selectedQuiz;
  bool loadingQuizzes = true;
  String? errorMsg;

  List<Question> questions = [];
  bool loadingQuestions = false;

  String qText = '';
  List<String> qOptions = ['', '', '', ''];
  int correctOptionIndex = 0;
  String qTimeStr = '30';

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    setState(() => loadingQuizzes = true);
    try {
      final fetched = await context.read(clientProvider).admin.getQuizzes();
      setState(() {
        quizzes = fetched;
        loadingQuizzes = false;
        errorMsg = null;
      });
    } catch (e) {
      setState(() {
        loadingQuizzes = false;
        errorMsg = 'Error loading quizzes: $e';
      });
    }
  }

  Future<void> _createQuiz() async {
    if (_titleInput.trim().isEmpty) return;
    try {
      await context
          .read(clientProvider)
          .admin
          .createQuiz(
            Quiz(
              title: _titleInput.trim(),
              creatorId: 1,
              createdAt: DateTime.now(),
            ),
          );
      _titleInput = '';
      await _loadQuizzes();
    } catch (e) {
      setState(() => errorMsg = 'Failed to create quiz: $e');
    }
  }

  Future<void> _loadQuestions(int quizId) async {
    setState(() => loadingQuestions = true);
    try {
      final fetched = await context.read(clientProvider).admin.getQuestionsForQuiz(quizId);
      setState(() {
        questions = fetched;
        loadingQuestions = false;
      });
    } catch (e) {
      setState(() {
        loadingQuestions = false;
        errorMsg = 'Error loading questions: $e';
      });
    }
  }

  Future<void> _addQuestion() async {
    if (selectedQuiz == null) return;
    if (qText.isEmpty || qOptions.any((c) => c.isEmpty)) {
      setState(() => errorMsg = 'Please fill all question fields');
      return;
    }

    try {
      await context
          .read(clientProvider)
          .admin
          .addQuestion(
            Question(
              quizId: selectedQuiz!.id!,
              text: qText,
              options: qOptions,
              correctOptionIndex: correctOptionIndex,
              timeLimitSeconds: int.tryParse(qTimeStr) ?? 30,
              orderIndex: questions.length,
            ),
          );

      setState(() {
        qText = '';
        qOptions = ['', '', '', ''];
        correctOptionIndex = 0;
        qTimeStr = '30';
        errorMsg = null;
      });

      await _loadQuestions(selectedQuiz!.id!);
    } catch (e) {
      setState(() => errorMsg = 'Failed to add question: $e');
    }
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'scr on', [
      div(classes: 'topbar', [
        button(classes: 'btn btn-icon btn-white btn-sm', events: {
          'click': (e) {
            if (selectedQuiz != null) {
              setState(() => selectedQuiz = null);
            } else {
              Router.of(context).push('/');
            }
          }
        }, [i(classes: 'ti ti-arrow-left', attributes: {'style': 'font-size:16px;'}, [])]),
        span(classes: 'topbar-title', attributes: {'style': 'flex:1;margin-left:8px;'}, [Component.text(selectedQuiz == null ? 'Admin Dashboard' : 'Quiz Builder')]),
      ]),
      div(classes: 'content-wrap p20 flex-col', attributes: {'style': 'flex:1;'}, [
        if (errorMsg != null)
          div(classes: 'banner banner-err mb16', [
            i(classes: 'ti ti-alert-circle', attributes: {'style': 'font-size:20px;color:#D85A30;'}, []),
            div(attributes: {'style': 'font-size:13px;color:#D85A30;font-weight:500;'}, [Component.text(errorMsg!)])
          ]),
        if (selectedQuiz == null) _buildQuizList() else _buildQuestionManager(),
      ])
    ]);
  }

  Component _buildQuizList() {
    return div(classes: 'flex-col h-full', [
      div(classes: 'card mb20', attributes: {'style': 'padding:16px;'}, [
        div(classes: 't-label mb8', [Component.text('Create a new quiz')]),
        div(classes: 'frow', attributes: {'style': 'gap:12px;'}, [
          div(attributes: {'style': 'flex:1;'}, [
            input(classes: 'finput', attributes: {
              'type': 'text',
              'placeholder': 'Quiz Title',
            }, events: {
              'input': (e) => _titleInput = (e.target as dynamic).value ?? '',
            }),
          ]),
          button(classes: 'btn btn-prim', attributes: {'style': 'padding:12px 16px;'}, events: {'click': (e) => _createQuiz()}, [
            i(classes: 'ti ti-plus', []), Component.text(' Create')
          ])
        ])
      ]),
      div(classes: 't-label mb8', [Component.text('Existing quizzes')]),
      if (loadingQuizzes)
        div(classes: 'flex-center', attributes: {'style': 'padding:40px;'}, [Component.text('Loading quizzes...')])
      else if (quizzes.isEmpty)
        div(classes: 'card card-body flex-center', attributes: {'style': 'padding:40px;color:var(--color-text-secondary);'}, [Component.text('No quizzes yet.')])
      else
        div(classes: 'gap8', [
          for (final q in quizzes)
            div(classes: 'card card-hover', attributes: {'style': 'padding:16px;cursor:pointer;'}, events: {
              'click': (e) {
                setState(() => selectedQuiz = q);
                _loadQuestions(q.id!);
              }
            }, [
              div(classes: 'frow', [
                div([
                  div(classes: 't-body', attributes: {'style': 'font-weight:600;font-size:15px;'}, [Component.text(q.title)]),
                  div(classes: 't-sub mt4', [Component.text('Created on ${q.createdAt.toString().split(' ')[0]}')])
                ]),
                i(classes: 'ti ti-chevron-right', attributes: {'style': 'color:var(--color-text-secondary);'}, [])
              ])
            ])
        ])
    ]);
  }

  Component _buildQuestionManager() {
    return div(classes: 'flex-col h-full', [
      div(classes: 'fgroup', [
        label(classes: 'flabel', [Component.text('Quiz title')]),
        input(classes: 'finput', attributes: {'type': 'text', 'value': selectedQuiz!.title, 'readonly': 'true'}),
      ]),
      hr(classes: 'div', attributes: {'style': 'margin:20px 0;'}),
      div(classes: 'frow mb8', [
        span(classes: 't-label', [Component.text('Questions (${questions.length})')]),
      ]),
      if (loadingQuestions)
        div(classes: 'flex-center p20', [Component.text('Loading questions...')])
      else if (questions.isNotEmpty)
        div(classes: 'card mb20', [
          div(classes: 'card-body', attributes: {'style': 'padding:12px 16px;'}, [
            for (var idx = 0; idx < questions.length; idx++)
              div(classes: 'qrow', attributes: idx == questions.length - 1 ? {'style': 'border:none;'} : {}, [
                div(classes: 'qnum', [Component.text('${idx + 1}')]),
                div(classes: 'qtext', [Component.text(questions[idx].text)]),
                div(classes: 'qmeta', [Component.text('${questions[idx].timeLimitSeconds}s')]),
              ])
          ])
        ]),
      div(classes: 't-label mb8 mt20', [Component.text('Add new question')]),
      div(classes: 'fgroup', [
        label(classes: 'flabel', [Component.text('Question')]),
        textarea(classes: 'ftextarea', attributes: {'placeholder': 'Type your question here...'}, events: {
          'input': (e) => qText = (e.target as dynamic).value ?? '',
        }, [])
      ]),
      div(attributes: {'style': 'display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:12px;'}, [
        for (var i = 0; i < 4; i++)
          div([
            label(classes: 'flabel', attributes: correctOptionIndex == i ? {'style': 'color:#1D9E75;'} : {}, [
              input(attributes: {'type': 'radio', 'name': 'correctOption', 'value': '$i', if (correctOptionIndex == i) 'checked': 'true'}, events: {
                'change': (e) => setState(() => correctOptionIndex = i)
              }),
              Component.text(correctOptionIndex == i ? ' Option ${String.fromCharCode(65 + i)} (Correct)' : ' Option ${String.fromCharCode(65 + i)}')
            ]),
            input(classes: 'finput', attributes: {
              'type': 'text',
              'placeholder': 'Answer ${i + 1}',
              if (correctOptionIndex == i) 'style': 'border-color:#5DCAA5;'
            }, events: {
              'input': (e) {
                final newOpts = List<String>.from(qOptions);
                newOpts[i] = (e.target as dynamic).value ?? '';
                qOptions = newOpts;
              }
            })
          ])
      ]),
      div(classes: 'fgroup mt16', [
        label(classes: 'flabel', [Component.text('Time Limit (seconds)')]),
        input(classes: 'finput', attributes: {
          'type': 'number',
          'placeholder': '30',
        }, events: {
          'input': (e) => qTimeStr = (e.target as dynamic).value ?? '30',
        })
      ]),
      button(
        classes: 'btn btn-prim btn-full mt20',
        attributes: {'style': 'font-size:15px;padding:14px;'},
        events: {'click': (e) => _addQuestion()},
        [i(classes: 'ti ti-check', []), Component.text(' Save question')]
      )
    ]);
  }
}
