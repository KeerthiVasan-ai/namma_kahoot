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
import 'kahoot/game_event.dart' as _i2;
import 'kahoot/game_session.dart' as _i3;
import 'kahoot/player.dart' as _i4;
import 'kahoot/question.dart' as _i5;
import 'kahoot/quiz.dart' as _i6;
import 'package:namma_kahoot_client/src/protocol/kahoot/quiz.dart' as _i7;
import 'package:namma_kahoot_client/src/protocol/kahoot/question.dart' as _i8;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i9;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i10;
export 'kahoot/game_event.dart';
export 'kahoot/game_session.dart';
export 'kahoot/player.dart';
export 'kahoot/question.dart';
export 'kahoot/quiz.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.GameEvent) {
      return _i2.GameEvent.fromJson(data) as T;
    }
    if (t == _i3.GameSession) {
      return _i3.GameSession.fromJson(data) as T;
    }
    if (t == _i4.Player) {
      return _i4.Player.fromJson(data) as T;
    }
    if (t == _i5.Question) {
      return _i5.Question.fromJson(data) as T;
    }
    if (t == _i6.Quiz) {
      return _i6.Quiz.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.GameEvent?>()) {
      return (data != null ? _i2.GameEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.GameSession?>()) {
      return (data != null ? _i3.GameSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Player?>()) {
      return (data != null ? _i4.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Question?>()) {
      return (data != null ? _i5.Question.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Quiz?>()) {
      return (data != null ? _i6.Quiz.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i7.Quiz>) {
      return (data as List).map((e) => deserialize<_i7.Quiz>(e)).toList() as T;
    }
    if (t == List<_i8.Question>) {
      return (data as List).map((e) => deserialize<_i8.Question>(e)).toList()
          as T;
    }
    try {
      return _i9.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i10.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.GameEvent => 'GameEvent',
      _i3.GameSession => 'GameSession',
      _i4.Player => 'Player',
      _i5.Question => 'Question',
      _i6.Quiz => 'Quiz',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'namma_kahoot.',
        '',
      );
    }

    switch (data) {
      case _i2.GameEvent():
        return 'GameEvent';
      case _i3.GameSession():
        return 'GameSession';
      case _i4.Player():
        return 'Player';
      case _i5.Question():
        return 'Question';
      case _i6.Quiz():
        return 'Quiz';
    }
    className = _i9.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i10.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'GameEvent') {
      return deserialize<_i2.GameEvent>(data['data']);
    }
    if (dataClassName == 'GameSession') {
      return deserialize<_i3.GameSession>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i4.Player>(data['data']);
    }
    if (dataClassName == 'Question') {
      return deserialize<_i5.Question>(data['data']);
    }
    if (dataClassName == 'Quiz') {
      return deserialize<_i6.Quiz>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i9.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i10.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i9.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i10.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
