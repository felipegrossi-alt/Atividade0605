import 'database.dart';

void main() {
  final db = AppDatabase.instance;

  db.execute("INSERT INTO cinema (nome, cidade, estado) VALUES ('Cine Centro', 'São Paulo', 'SP')");
  db.execute("INSERT INTO cinema (nome, cidade, estado) VALUES ('Cine Norte', 'Campinas', 'SP')");

  db.execute("INSERT INTO sala (numero, capacidade, tipo, cinema_id) VALUES (1, 200, 'COMUM', 1)");
  db.execute("INSERT INTO sala (numero, capacidade, tipo, cinema_id) VALUES (2, 100, 'VIP', 1)");
  db.execute("INSERT INTO sala (numero, capacidade, tipo, cinema_id) VALUES (1, 150, 'COMUM', 2)");

  db.execute("INSERT INTO filme (titulo, duracao, genero, classificacao) VALUES ('Duna: Parte 2', 166, 'Ficção Científica', '12')");
  db.execute("INSERT INTO filme (titulo, duracao, genero, classificacao) VALUES ('Coringa 2', 138, 'Drama', '16')");

  db.execute("""
    INSERT INTO sessao (data_hora_inicio, data_hora_fim, idioma, formato, preco_ingresso, sala_id, filme_id)
    VALUES ('2024-06-15T14:00:00', '2024-06-15T16:46:00', 'Dublado', '2D', 25.00, 1, 1)
  """);
  db.execute("""
    INSERT INTO sessao (data_hora_inicio, data_hora_fim, idioma, formato, preco_ingresso, sala_id, filme_id)
    VALUES ('2024-06-15T19:00:00', '2024-06-15T21:46:00', 'Legendado', 'IMAX', 45.00, 1, 1)
  """);
  db.execute("""
    INSERT INTO sessao (data_hora_inicio, data_hora_fim, idioma, formato, preco_ingresso, sala_id, filme_id)
    VALUES ('2024-06-15T15:00:00', '2024-06-15T17:18:00', 'Dublado', '2D', 28.00, 2, 2)
  """);

  // registros de público (sessões já encerradas no seed)
  db.execute("INSERT INTO registro_publico (sessao_id, data, qtd_espectadores) VALUES (1, '2024-06-15', 187)");
  db.execute("INSERT INTO registro_publico (sessao_id, data, qtd_espectadores) VALUES (2, '2024-06-15', 95)");

  print('Banco populado com sucesso!');
}
