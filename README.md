# Cinema System – Dart

Arquitetura: MVC + Service + Repository  
Persistência: SQLite (pacote `sqlite3`)  
Servidor HTTP: `shelf` + `shelf_router`

## Estrutura

```
lib/
  app.dart                        # ponto de entrada, rotas
  database.dart                   # conexão e criação das tabelas
  models/
    sessao.dart
    registro_publico.dart
  repositories/
    sessao_repository.dart        # acesso ao SQLite
    registro_publico_repository.dart
  services/
    sessao_service.dart           # regras de negócio (RN01–RN05)
    registro_publico_service.dart # regras de negócio (RN03, RN04)
  controllers/
    sessao_controller.dart        # rotas HTTP de sessão
    registro_publico_controller.dart
  seed.dart                       # dados iniciais para teste
```

## Como rodar

```bash
dart pub get
dart run lib/seed.dart    # popula o banco (opcional)
dart run lib/app.dart     # inicia o servidor na porta 8080
```

## Endpoints

### Sessões

| Método | Rota            | Descrição                        |
|--------|-----------------|----------------------------------|
| GET    | /sessoes/       | Lista todas as sessões           |
| GET    | /sessoes/:id    | Busca sessão por ID              |
| POST   | /sessoes/       | Cria nova sessão                 |
| DELETE | /sessoes/:id    | Remove uma sessão                |

### Registro de Público

| Método | Rota                          | Descrição                        |
|--------|-------------------------------|----------------------------------|
| POST   | /publico/                     | Registra público de uma sessão   |
| GET    | /publico/sessao/:sessaoId     | Lista registros de uma sessão    |
| GET    | /publico/filme/:filmeId/total | Total de público de um filme     |

## Exemplos de uso (curl)

### Criar sessão
```bash
curl -X POST http://localhost:8080/sessoes/ \
  -H "Content-Type: application/json" \
  -d '{
    "filmeId": 1,
    "salaId": 1,
    "dataHoraInicio": "2025-07-10T14:00:00",
    "dataHoraFim": "2025-07-10T16:46:00",
    "idioma": "Dublado",
    "formato": "2D",
    "precoIngresso": 25.00
  }'
```

### Registrar público
```bash
curl -X POST http://localhost:8080/publico/ \
  -H "Content-Type: application/json" \
  -d '{
    "sessaoId": 1,
    "data": "2024-06-15",
    "qtdEspectadores": 150
  }'
```

### Total de público por filme
```bash
curl http://localhost:8080/publico/filme/1/total
```

## Regras de negócio implementadas

- **RN01/RN02** – Intervalo mínimo de 30 min entre sessões na mesma sala; sem sobreposição de horários  
- **RN03** – Público não pode exceder a capacidade da sala  
- **RN04** – Registro de público só permitido após o encerramento da sessão  
- **RN05** – Campos obrigatórios validados no service antes de persistir  
