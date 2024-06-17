class DatabaseConstant {
  static const String todoTable = 'todo_table';
  static const String dbName = 'todo_db.db';

  static String sqlForCreateTodoTable = '''
    id          INTEGER UNIQUE
                        PRIMARY KEY,
    title       TEXT    NOT NULL,
    description TEXT    NOT NULL,
    is_fav      BOOL    NOT NULL
  ''';
}
