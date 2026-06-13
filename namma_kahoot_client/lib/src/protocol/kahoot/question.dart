/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:namma_kahoot_client/src/protocol/protocol.dart' as _i2;

abstract class Question implements _i1.SerializableModel {
  Question._({
    this.id,
    required this.quizId,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.timeLimitSeconds,
    required this.orderIndex,
  });

  factory Question({
    int? id,
    required int quizId,
    required String text,
    required List<String> options,
    required int correctOptionIndex,
    required int timeLimitSeconds,
    required int orderIndex,
  }) = _QuestionImpl;

  factory Question.fromJson(Map<String, dynamic> jsonSerialization) {
    return Question(
      id: jsonSerialization['id'] as int?,
      quizId: jsonSerialization['quizId'] as int,
      text: jsonSerialization['text'] as String,
      options: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['options'],
      ),
      correctOptionIndex: jsonSerialization['correctOptionIndex'] as int,
      timeLimitSeconds: jsonSerialization['timeLimitSeconds'] as int,
      orderIndex: jsonSerialization['orderIndex'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int quizId;

  String text;

  List<String> options;

  int correctOptionIndex;

  int timeLimitSeconds;

  int orderIndex;

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Question copyWith({
    int? id,
    int? quizId,
    String? text,
    List<String>? options,
    int? correctOptionIndex,
    int? timeLimitSeconds,
    int? orderIndex,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Question',
      if (id != null) 'id': id,
      'quizId': quizId,
      'text': text,
      'options': options.toJson(),
      'correctOptionIndex': correctOptionIndex,
      'timeLimitSeconds': timeLimitSeconds,
      'orderIndex': orderIndex,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionImpl extends Question {
  _QuestionImpl({
    int? id,
    required int quizId,
    required String text,
    required List<String> options,
    required int correctOptionIndex,
    required int timeLimitSeconds,
    required int orderIndex,
  }) : super._(
         id: id,
         quizId: quizId,
         text: text,
         options: options,
         correctOptionIndex: correctOptionIndex,
         timeLimitSeconds: timeLimitSeconds,
         orderIndex: orderIndex,
       );

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Question copyWith({
    Object? id = _Undefined,
    int? quizId,
    String? text,
    List<String>? options,
    int? correctOptionIndex,
    int? timeLimitSeconds,
    int? orderIndex,
  }) {
    return Question(
      id: id is int? ? id : this.id,
      quizId: quizId ?? this.quizId,
      text: text ?? this.text,
      options: options ?? this.options.map((e0) => e0).toList(),
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
