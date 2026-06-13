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

abstract class Player implements _i1.SerializableModel {
  Player._({
    this.id,
    required this.gameSessionId,
    required this.name,
    required this.score,
  });

  factory Player({
    int? id,
    required int gameSessionId,
    required String name,
    required int score,
  }) = _PlayerImpl;

  factory Player.fromJson(Map<String, dynamic> jsonSerialization) {
    return Player(
      id: jsonSerialization['id'] as int?,
      gameSessionId: jsonSerialization['gameSessionId'] as int,
      name: jsonSerialization['name'] as String,
      score: jsonSerialization['score'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int gameSessionId;

  String name;

  int score;

  /// Returns a shallow copy of this [Player]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Player copyWith({
    int? id,
    int? gameSessionId,
    String? name,
    int? score,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Player',
      if (id != null) 'id': id,
      'gameSessionId': gameSessionId,
      'name': name,
      'score': score,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlayerImpl extends Player {
  _PlayerImpl({
    int? id,
    required int gameSessionId,
    required String name,
    required int score,
  }) : super._(
         id: id,
         gameSessionId: gameSessionId,
         name: name,
         score: score,
       );

  /// Returns a shallow copy of this [Player]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Player copyWith({
    Object? id = _Undefined,
    int? gameSessionId,
    String? name,
    int? score,
  }) {
    return Player(
      id: id is int? ? id : this.id,
      gameSessionId: gameSessionId ?? this.gameSessionId,
      name: name ?? this.name,
      score: score ?? this.score,
    );
  }
}
