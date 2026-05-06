class Sessao {
  final int? id;
  final String dataHoraInicio;
  final String dataHoraFim;
  final String idioma;
  final String formato;
  final double? precoIngresso;
  final int salaId;
  final int filmeId;

  // campos extras vindos do JOIN
  final String? filmeNome;
  final int? filmeDuracao;
  final int? salaNumero;
  final int? salaCapacidade;

  Sessao({
    this.id,
    required this.dataHoraInicio,
    required this.dataHoraFim,
    this.idioma = 'Portugues',
    this.formato = '2D',
    this.precoIngresso,
    required this.salaId,
    required this.filmeId,
    this.filmeNome,
    this.filmeDuracao,
    this.salaNumero,
    this.salaCapacidade,
  });

  factory Sessao.fromMap(Map<String, dynamic> map) {
    return Sessao(
      id: map['id'] as int?,
      dataHoraInicio: map['data_hora_inicio'] as String,
      dataHoraFim: map['data_hora_fim'] as String,
      idioma: map['idioma'] as String? ?? 'Portugues',
      formato: map['formato'] as String? ?? '2D',
      precoIngresso: map['preco_ingresso'] as double?,
      salaId: map['sala_id'] as int,
      filmeId: map['filme_id'] as int,
      filmeNome: map['filme'] as String?,
      filmeDuracao: map['duracao'] as int?,
      salaNumero: map['sala'] as int?,
      salaCapacidade: map['capacidade'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'data_hora_inicio': dataHoraInicio,
      'data_hora_fim': dataHoraFim,
      'idioma': idioma,
      'formato': formato,
      'preco_ingresso': precoIngresso,
      'sala_id': salaId,
      'filme_id': filmeId,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataHoraInicio': dataHoraInicio,
      'dataHoraFim': dataHoraFim,
      'idioma': idioma,
      'formato': formato,
      'precoIngresso': precoIngresso,
      'salaId': salaId,
      'filmeId': filmeId,
      if (filmeNome != null) 'filme': filmeNome,
      if (salaNumero != null) 'sala': salaNumero,
      if (salaCapacidade != null) 'capacidade': salaCapacidade,
    };
  }
}
