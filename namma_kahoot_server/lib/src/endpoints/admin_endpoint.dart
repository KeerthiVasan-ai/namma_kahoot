import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AdminEndpoint extends Endpoint {
  /// Create a new Quiz
  Future<Quiz> createQuiz(Session session, Quiz quiz) async {
    return await Quiz.db.insertRow(session, quiz);
  }

  /// Get all quizzes
  Future<List<Quiz>> getQuizzes(Session session) async {
    return await Quiz.db.find(session);
  }

  /// Get a single quiz by ID
  Future<Quiz?> getQuiz(Session session, int id) async {
    return await Quiz.db.findById(session, id);
  }

  /// Add a Question to a Quiz
  Future<Question> addQuestion(Session session, Question question) async {
    return await Question.db.insertRow(session, question);
  }

  /// Get questions for a quiz
  Future<List<Question>> getQuestionsForQuiz(Session session, int quizId) async {
    return await Question.db.find(
      session,
      where: (t) => t.quizId.equals(quizId),
      orderBy: (t) => t.orderIndex,
    );
  }

  /// Delete a Quiz
  Future<void> deleteQuiz(Session session, int quizId) async {
    // Delete questions first
    await Question.db.deleteWhere(session, where: (t) => t.quizId.equals(quizId));
    // Delete quiz
    await Quiz.db.deleteWhere(session, where: (t) => t.id.equals(quizId));
  }
}
