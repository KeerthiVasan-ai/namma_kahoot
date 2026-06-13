import 'package:flutter/material.dart';
import '../../main.dart'; // To access client
import 'package:namma_kahoot_client/namma_kahoot_client.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _titleController = TextEditingController();
  List<Quiz> _quizzes = [];
  Quiz? _selectedQuiz;
  bool _isLoading = true;

  List<Question> _questions = [];
  bool _isLoadingQuestions = false;

  final TextEditingController _qTextController = TextEditingController();
  final List<TextEditingController> _qOptionControllers = List.generate(4, (_) => TextEditingController());
  int _correctOptionIndex = 0;
  final TextEditingController _qTimeController = TextEditingController(text: '30');

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    setState(() => _isLoading = true);
    try {
      final quizzes = await client.admin.getQuizzes();
      setState(() => _quizzes = quizzes);
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createQuiz() async {
    if (_titleController.text.isEmpty) return;
    try {
      await client.admin.createQuiz(Quiz(
        title: _titleController.text,
        creatorId: 1,
        createdAt: DateTime.now(),
      ));
      _titleController.clear();
      _loadQuizzes();
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _loadQuestions(int quizId) async {
    setState(() => _isLoadingQuestions = true);
    try {
      final questions = await client.admin.getQuestionsForQuiz(quizId);
      setState(() => _questions = questions);
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoadingQuestions = false);
    }
  }

  Future<void> _addQuestion() async {
    if (_selectedQuiz == null) return;
    if (_qTextController.text.isEmpty || _qOptionControllers.any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields')));
      return;
    }
    
    try {
      await client.admin.addQuestion(Question(
        quizId: _selectedQuiz!.id!,
        text: _qTextController.text,
        options: _qOptionControllers.map((c) => c.text).toList(),
        correctOptionIndex: _correctOptionIndex,
        timeLimitSeconds: int.tryParse(_qTimeController.text) ?? 30,
        orderIndex: _questions.length,
      ));
      
      _qTextController.clear();
      for (var c in _qOptionControllers) { c.clear(); }
      _correctOptionIndex = 0;
      
      await _loadQuestions(_selectedQuiz!.id!);
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedQuiz == null ? 'Admin Dashboard' : 'Manage: ${_selectedQuiz!.title}'),
        leading: _selectedQuiz != null ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => _selectedQuiz = null)) : null,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: _selectedQuiz == null ? _buildQuizList() : _buildQuestionManager(),
          ),
    );
  }

  Widget _buildQuizList() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: TextField(controller: _titleController, decoration: const InputDecoration(hintText: 'New Quiz Title'))),
            ElevatedButton(onPressed: _createQuiz, child: const Text('Add')),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _quizzes.length,
            itemBuilder: (context, index) {
              final quiz = _quizzes[index];
              return ListTile(
                title: Text(quiz.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Created: ${quiz.createdAt.toLocal().toString().split('.')[0]}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                   setState(() => _selectedQuiz = quiz);
                   _loadQuestions(quiz.id!);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isLoadingQuestions) const Center(child: CircularProgressIndicator())
        else Expanded(
          flex: 1,
          child: ListView.builder(
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              final q = _questions[index];
              return Card(
                child: ListTile(
                  title: Text('${index + 1}. ${q.text}'),
                  subtitle: Text('Answer: ${q.options[q.correctOptionIndex]} | Time: ${q.timeLimitSeconds}s'),
                ),
              );
            },
          ),
        ),
        const Divider(),
        const Text("Add New Question", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: _qTextController, decoration: const InputDecoration(labelText: 'Question Text')),
                ...List.generate(4, (index) => Row(
                  children: [
                    // ignore: deprecated_member_use
                    Radio<int>(
                      value: index,
                      // ignore: deprecated_member_use
                      groupValue: _correctOptionIndex,
                      // ignore: deprecated_member_use
                      onChanged: (val) => setState(() => _correctOptionIndex = val!),
                    ),
                    Expanded(child: TextField(controller: _qOptionControllers[index], decoration: InputDecoration(labelText: 'Option ${index + 1}'))),
                  ],
                )),
                TextField(controller: _qTimeController, decoration: const InputDecoration(labelText: 'Time Limit (seconds)'), keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: _addQuestion, child: const Text("Save Question")),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
