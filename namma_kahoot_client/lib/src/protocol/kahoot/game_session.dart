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

abstract class GameSession implements _i1.SerializableModel {
  GameSession._({
    this.id,
    required this.pin,
    required this.quizId,
    required this.hostId,
    required this.status,
    required this.currentQuestionIndex,
    this.startTime,
  });

  factory GameSession({
    int? id,
    required String pin,
    required int quizId,
    required int hostId,
    required String status,
    required int currentQuestionIndex,
    DateTime? startTime,
  }) = _GameSessionImpl;

  factory GameSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return GameSession(
      id: jsonSerialization['id'] as int?,
      pin: jsonSerialization['pin'] as String,
      quizId: jsonSerialization['quizId'] as int,
      hostId: jsonSerialization['hostId'] as int,
      status: jsonSerialization['status'] as String,
      currentQuestionIndex: jsonSerialization['currentQuestionIndex'] as int,
      startTime: jsonSerialization['startTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startTime']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String pin;

  int quizId;

  int hostId;

  String status;

  int currentQuestionIndex;

  DateTime? startTime;

  /// Returns a shallow copy of this [GameSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GameSession copyWith({
    int? id,
    String? pin,
    int? quizId,
    int? hostId,
    String? status,
    int? currentQuestionIndex,
    DateTime? startTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GameSession',
      if (id != null) 'id': id,
      'pin': pin,
      'quizId': quizId,
      'hostId': hostId,
      'status': status,
      'currentQuestionIndex': currentQuestionIndex,
      if (startTime != null) 'startTime': startTime?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GameSessionImpl extends GameSession {
  _GameSessionImpl({
    int? id,
    required String pin,
    required int quizId,
    required int hostId,
    required String status,
    required int currentQuestionIndex,
    DateTime? startTime,
  }) : super._(
         id: id,
         pin: pin,
         quizId: quizId,
         hostId: hostId,
         status: status,
         currentQuestionIndex: currentQuestionIndex,
         startTime: startTime,
       );

  /// Returns a shallow copy of this [GameSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GameSession copyWith({
    Object? id = _Undefined,
    String? pin,
    int? quizId,
    int? hostId,
    String? status,
    int? currentQuestionIndex,
    Object? startTime = _Undefined,
  }) {
    return GameSession(
      id: id is int? ? id : this.id,
      pin: pin ?? this.pin,
      quizId: quizId ?? this.quizId,
      hostId: hostId ?? this.hostId,
      status: status ?? this.status,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      startTime: startTime is DateTime? ? startTime : this.startTime,
    );
  }
}
