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

abstract class Quiz implements _i1.SerializableModel {
  Quiz._({
    this.id,
    required this.title,
    required this.creatorId,
    this.description,
    required this.createdAt,
  });

  factory Quiz({
    int? id,
    required String title,
    required int creatorId,
    String? description,
    required DateTime createdAt,
  }) = _QuizImpl;

  factory Quiz.fromJson(Map<String, dynamic> jsonSerialization) {
    return Quiz(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      creatorId: jsonSerialization['creatorId'] as int,
      description: jsonSerialization['description'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  int creatorId;

  String? description;

  DateTime createdAt;

  /// Returns a shallow copy of this [Quiz]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Quiz copyWith({
    int? id,
    String? title,
    int? creatorId,
    String? description,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Quiz',
      if (id != null) 'id': id,
      'title': title,
      'creatorId': creatorId,
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuizImpl extends Quiz {
  _QuizImpl({
    int? id,
    required String title,
    required int creatorId,
    String? description,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         creatorId: creatorId,
         description: description,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Quiz]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Quiz copyWith({
    Object? id = _Undefined,
    String? title,
    int? creatorId,
    Object? description = _Undefined,
    DateTime? createdAt,
  }) {
    return Quiz(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      creatorId: creatorId ?? this.creatorId,
      description: description is String? ? description : this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
