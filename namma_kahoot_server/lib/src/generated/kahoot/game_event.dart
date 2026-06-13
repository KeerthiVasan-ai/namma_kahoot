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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class GameEvent
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  GameEvent._({
    required this.eventType,
    required this.dataJson,
  });

  factory GameEvent({
    required String eventType,
    required String dataJson,
  }) = _GameEventImpl;

  factory GameEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return GameEvent(
      eventType: jsonSerialization['eventType'] as String,
      dataJson: jsonSerialization['dataJson'] as String,
    );
  }

  String eventType;

  String dataJson;

  /// Returns a shallow copy of this [GameEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GameEvent copyWith({
    String? eventType,
    String? dataJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GameEvent',
      'eventType': eventType,
      'dataJson': dataJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GameEvent',
      'eventType': eventType,
      'dataJson': dataJson,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _GameEventImpl extends GameEvent {
  _GameEventImpl({
    required String eventType,
    required String dataJson,
  }) : super._(
         eventType: eventType,
         dataJson: dataJson,
       );

  /// Returns a shallow copy of this [GameEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GameEvent copyWith({
    String? eventType,
    String? dataJson,
  }) {
    return GameEvent(
      eventType: eventType ?? this.eventType,
      dataJson: dataJson ?? this.dataJson,
    );
  }
}
