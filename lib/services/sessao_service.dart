import '../models/sessao.dart';
import '../repositories/sessao_repository.dart';

class SessaoService {
  final SessaoRepository _repository = SessaoRepository();

  static const int intervaloMinimoMinutos = 30;

  List<Sessao> listar() {
    return _repository.findAll();
  }

  Sessao buscar(int id) {
    final sessao = _repository.findById(id);
    if (sessao == null) throw Exception('Sessão não encontrada.');
    return sessao;
  }

  Sessao criar(Map<String, dynamic> dados) {
    // RN05: campos obrigatórios
    final salaId = dados['salaId'] as int?;
    final filmeId = dados['filmeId'] as int?;
    final inicioStr = dados['dataHoraInicio'] as String?;
    final fimStr = dados['dataHoraFim'] as String?;

    if (salaId == null || filmeId == null || inicioStr == null || fimStr == null) {
      throw Exception('Campos obrigatórios: salaId, filmeId, dataHoraInicio, dataHoraFim.');
    }

    final inicio = DateTime.parse(inicioStr);
    final fim = DateTime.parse(fimStr);

    if (!fim.isAfter(inicio)) {
      throw Exception('dataHoraFim deve ser posterior a dataHoraInicio.');
    }

    // RN01 e RN02: verificar sobreposição com buffer de 30 min
    final inicioBuffer = inicio.subtract(const Duration(minutes: intervaloMinimoMinutos));
    final fimBuffer = fim.add(const Duration(minutes: intervaloMinimoMinutos));

    final conflitos = _repository.findBySalaEPeriodo(
      salaId,
      inicioBuffer.toIso8601String(),
      fimBuffer.toIso8601String(),
    );

    if (conflitos.isNotEmpty) {
      throw Exception('Conflito: sala ocupada ou intervalo mínimo de 30 min não respeitado.');
    }

    final sessao = Sessao(
      dataHoraInicio: inicioStr,
      dataHoraFim: fimStr,
      idioma: dados['idioma'] as String? ?? 'Portugues',
      formato: dados['formato'] as String? ?? '2D',
      precoIngresso: (dados['precoIngresso'] as num?)?.toDouble(),
      salaId: salaId,
      filmeId: filmeId,
    );

    return _repository.create(sessao);
  }

  void excluir(int id) {
    buscar(id); // valida existência
    _repository.delete(id);
  }
}
