class RegistroPublico {
  final int? id;
  final int sessaoId;
  final String data;
  final int qtdEspectadores;

  RegistroPublico({
    this.id,
    required this.sessaoId,
    required this.data,
    required this.qtdEspectadores,
  });

  factory RegistroPublico.fromMap(Map<String, dynamic> map) {
    return RegistroPublico(
      id: map['id'] as int?,
      sessaoId: map['sessao_id'] as int,
      data: map['data'] as String,
      qtdEspectadores: map['qtd_espectadores'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessaoId': sessaoId,
      'data': data,
      'qtdEspectadores': qtdEspectadores,
    };
  }
}
