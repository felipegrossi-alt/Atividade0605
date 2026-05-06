import 'package:sqlite3/sqlite3.dart';
import '../database.dart';
import '../models/sessao.dart';

class SessaoRepository {
  final Database _db = AppDatabase.instance;

  List<Sessao> findAll() {
    final rows = _db.select('''
      SELECT s.*, f.titulo AS filme, f.duracao,
             sa.numero AS sala, sa.capacidade
      FROM sessao s
      JOIN filme f  ON s.filme_id = f.id
      JOIN sala  sa ON s.sala_id  = sa.id
    ''');
    return rows.map((r) => Sessao.fromMap(r)).toList();
  }

  Sessao? findById(int id) {
    final rows = _db.select('''
      SELECT s.*, f.titulo AS filme, f.duracao,
             sa.numero AS sala, sa.capacidade
      FROM sessao s
      JOIN filme f  ON s.filme_id = f.id
      JOIN sala  sa ON s.sala_id  = sa.id
      WHERE s.id = ?
    ''', [id]);
    if (rows.isEmpty) return null;
    return Sessao.fromMap(rows.first);
  }

  List<Sessao> findBySalaEPeriodo(int salaId, String inicio, String fim) {
    final rows = _db.select('''
      SELECT * FROM sessao
      WHERE sala_id = ?
        AND NOT (data_hora_fim <= ? OR data_hora_inicio >= ?)
    ''', [salaId, inicio, fim]);
    return rows.map((r) => Sessao.fromMap(r)).toList();
  }

  Sessao create(Sessao sessao) {
    _db.execute('''
      INSERT INTO sessao
        (data_hora_inicio, data_hora_fim, idioma, formato, preco_ingresso, sala_id, filme_id)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      sessao.dataHoraInicio,
      sessao.dataHoraFim,
      sessao.idioma,
      sessao.formato,
      sessao.precoIngresso,
      sessao.salaId,
      sessao.filmeId,
    ]);
    return Sessao(
      id: _db.lastInsertRowId,
      dataHoraInicio: sessao.dataHoraInicio,
      dataHoraFim: sessao.dataHoraFim,
      idioma: sessao.idioma,
      formato: sessao.formato,
      precoIngresso: sessao.precoIngresso,
      salaId: sessao.salaId,
      filmeId: sessao.filmeId,
    );
  }

  void delete(int id) {
    _db.execute('DELETE FROM sessao WHERE id = ?', [id]);
  }
}
