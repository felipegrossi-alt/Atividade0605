import 'package:sqlite3/sqlite3.dart';
import '../database.dart';
import '../models/registro_publico.dart';

class RegistroPublicoRepository {
  final Database _db = AppDatabase.instance;

  List<RegistroPublico> findBySessao(int sessaoId) {
    final rows = _db.select(
      'SELECT * FROM registro_publico WHERE sessao_id = ?',
      [sessaoId],
    );
    return rows.map((r) => RegistroPublico.fromMap(r)).toList();
  }

  int totalPorFilme(int filmeId) {
    final row = _db.select('''
      SELECT COALESCE(SUM(rp.qtd_espectadores), 0) AS total
      FROM registro_publico rp
      JOIN sessao s ON rp.sessao_id = s.id
      WHERE s.filme_id = ?
    ''', [filmeId]);
    return row.first['total'] as int;
  }

  RegistroPublico create(RegistroPublico reg) {
    _db.execute('''
      INSERT INTO registro_publico (sessao_id, data, qtd_espectadores)
      VALUES (?, ?, ?)
    ''', [reg.sessaoId, reg.data, reg.qtdEspectadores]);
    return RegistroPublico(
      id: _db.lastInsertRowId,
      sessaoId: reg.sessaoId,
      data: reg.data,
      qtdEspectadores: reg.qtdEspectadores,
    );
  }
}
