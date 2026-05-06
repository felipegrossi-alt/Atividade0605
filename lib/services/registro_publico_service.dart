import '../database.dart';
import '../models/registro_publico.dart';
import '../repositories/registro_publico_repository.dart';

class RegistroPublicoService {
  final RegistroPublicoRepository _repository = RegistroPublicoRepository();

  RegistroPublico registrar(Map<String, dynamic> dados) {
    final sessaoId = dados['sessaoId'] as int?;
    final qtd = dados['qtdEspectadores'] as int?;
    final data = dados['data'] as String?;

    if (sessaoId == null || qtd == null || data == null) {
      throw Exception('Campos obrigatórios: sessaoId, qtdEspectadores, data.');
    }

    // busca sessão com capacidade da sala
    final rows = AppDatabase.instance.select('''
      SELECT s.data_hora_fim, sa.capacidade
      FROM sessao s
      JOIN sala sa ON s.sala_id = sa.id
      WHERE s.id = ?
    ''', [sessaoId]);

    if (rows.isEmpty) throw Exception('Sessão não encontrada.');

    // RN04: sessão deve estar encerrada
    final fimSessao = DateTime.parse(rows.first['data_hora_fim'] as String);
    if (fimSessao.isAfter(DateTime.now())) {
      throw Exception('Sessão ainda não encerrada. Registro só permitido após o fim.');
    }

    // RN03: não exceder capacidade
    final capacidade = rows.first['capacidade'] as int;
    if (qtd > capacidade) {
      throw Exception('Quantidade ($qtd) excede a capacidade da sala ($capacidade).');
    }

    return _repository.create(RegistroPublico(
      sessaoId: sessaoId,
      data: data,
      qtdEspectadores: qtd,
    ));
  }

  List<RegistroPublico> listarPorSessao(int sessaoId) {
    return _repository.findBySessao(sessaoId);
  }

  int totalPorFilme(int filmeId) {
    return _repository.totalPorFilme(filmeId);
  }
}
