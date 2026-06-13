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

abstract class GameSession
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = GameSessionTable();

  static const db = GameSessionRepository._();

  @override
  int? id;

  String pin;

  int quizId;

  int hostId;

  String status;

  int currentQuestionIndex;

  DateTime? startTime;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static GameSessionInclude include() {
    return GameSessionInclude._();
  }

  static GameSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<GameSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GameSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GameSessionTable>? orderByList,
    GameSessionInclude? include,
  }) {
    return GameSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GameSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GameSession.t),
      include: include,
    );
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

class GameSessionUpdateTable extends _i1.UpdateTable<GameSessionTable> {
  GameSessionUpdateTable(super.table);

  _i1.ColumnValue<String, String> pin(String value) => _i1.ColumnValue(
    table.pin,
    value,
  );

  _i1.ColumnValue<int, int> quizId(int value) => _i1.ColumnValue(
    table.quizId,
    value,
  );

  _i1.ColumnValue<int, int> hostId(int value) => _i1.ColumnValue(
    table.hostId,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<int, int> currentQuestionIndex(int value) => _i1.ColumnValue(
    table.currentQuestionIndex,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startTime(DateTime? value) =>
      _i1.ColumnValue(
        table.startTime,
        value,
      );
}

class GameSessionTable extends _i1.Table<int?> {
  GameSessionTable({super.tableRelation}) : super(tableName: 'game_sessions') {
    updateTable = GameSessionUpdateTable(this);
    pin = _i1.ColumnString(
      'pin',
      this,
    );
    quizId = _i1.ColumnInt(
      'quizId',
      this,
    );
    hostId = _i1.ColumnInt(
      'hostId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    currentQuestionIndex = _i1.ColumnInt(
      'currentQuestionIndex',
      this,
    );
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
  }

  late final GameSessionUpdateTable updateTable;

  late final _i1.ColumnString pin;

  late final _i1.ColumnInt quizId;

  late final _i1.ColumnInt hostId;

  late final _i1.ColumnString status;

  late final _i1.ColumnInt currentQuestionIndex;

  late final _i1.ColumnDateTime startTime;

  @override
  List<_i1.Column> get columns => [
    id,
    pin,
    quizId,
    hostId,
    status,
    currentQuestionIndex,
    startTime,
  ];
}

class GameSessionInclude extends _i1.IncludeObject {
  GameSessionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => GameSession.t;
}

class GameSessionIncludeList extends _i1.IncludeList {
  GameSessionIncludeList._({
    _i1.WhereExpressionBuilder<GameSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GameSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => GameSession.t;
}

class GameSessionRepository {
  const GameSessionRepository._();

  /// Returns a list of [GameSession]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<GameSession>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<GameSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GameSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GameSessionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GameSession>(
      where: where?.call(GameSession.t),
      orderBy: orderBy?.call(GameSession.t),
      orderByList: orderByList?.call(GameSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GameSession] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<GameSession?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<GameSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<GameSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GameSessionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GameSession>(
      where: where?.call(GameSession.t),
      orderBy: orderBy?.call(GameSession.t),
      orderByList: orderByList?.call(GameSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GameSession] by its [id] or null if no such row exists.
  Future<GameSession?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GameSession>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GameSession]s in the list and returns the inserted rows.
  ///
  /// The returned [GameSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<GameSession>> insert(
    _i1.DatabaseSession session,
    List<GameSession> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<GameSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [GameSession] and returns the inserted row.
  ///
  /// The returned [GameSession] will have its `id` field set.
  Future<GameSession> insertRow(
    _i1.DatabaseSession session,
    GameSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GameSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [GameSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<GameSession>> update(
    _i1.DatabaseSession session,
    List<GameSession> rows, {
    _i1.ColumnSelections<GameSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<GameSession>(
      rows,
      columns: columns?.call(GameSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GameSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GameSession> updateRow(
    _i1.DatabaseSession session,
    GameSession row, {
    _i1.ColumnSelections<GameSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GameSession>(
      row,
      columns: columns?.call(GameSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GameSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GameSession?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<GameSessionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<GameSession>(
      id,
      columnValues: columnValues(GameSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GameSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<GameSession>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<GameSessionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<GameSessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GameSessionTable>? orderBy,
    _i1.OrderByListBuilder<GameSessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<GameSession>(
      columnValues: columnValues(GameSession.t.updateTable),
      where: where(GameSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GameSession.t),
      orderByList: orderByList?.call(GameSession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [GameSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<GameSession>> delete(
    _i1.DatabaseSession session,
    List<GameSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GameSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [GameSession].
  Future<GameSession> deleteRow(
    _i1.DatabaseSession session,
    GameSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GameSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<GameSession>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<GameSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<GameSession>(
      where: where(GameSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<GameSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GameSession>(
      where: where?.call(GameSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GameSession] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<GameSessionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GameSession>(
      where: where(GameSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
