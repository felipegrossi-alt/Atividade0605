import 'package:sqlite3/sqlite3.dart';

class AppDatabase {
  static Database? _instance;

  static Database get instance {
    _instance ??= _init();
    return _instance!;
  }

  static Database _init() {
    final db = sqlite3.open('cinema.db');

    db.execute('''
      CREATE TABLE IF NOT EXISTS cinema (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        cidade TEXT NOT NULL,
        estado TEXT NOT NULL,
        telefone TEXT
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS sala (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero INTEGER NOT NULL,
        capacidade INTEGER NOT NULL,
        tipo TEXT DEFAULT 'COMUM',
        cinema_id INTEGER NOT NULL,
        FOREIGN KEY (cinema_id) REFERENCES cinema(id)
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS filme (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        duracao INTEGER NOT NULL,
        genero TEXT,
        classificacao TEXT
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS sessao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data_hora_inicio TEXT NOT NULL,
        data_hora_fim TEXT NOT NULL,
        idioma TEXT DEFAULT 'Portugues',
        formato TEXT DEFAULT '2D',
        preco_ingresso REAL,
        sala_id INTEGER NOT NULL,
        filme_id INTEGER NOT NULL,
        FOREIGN KEY (sala_id) REFERENCES sala(id),
        FOREIGN KEY (filme_id) REFERENCES filme(id)
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS registro_publico (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessao_id INTEGER NOT NULL,
        data TEXT NOT NULL,
        qtd_espectadores INTEGER NOT NULL,
        FOREIGN KEY (sessao_id) REFERENCES sessao(id)
      );
    ''');

    return db;
  }
}
