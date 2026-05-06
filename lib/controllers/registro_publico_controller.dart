import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/registro_publico_service.dart';

class RegistroPublicoController {
  final RegistroPublicoService _service = RegistroPublicoService();

  Router get router {
    final router = Router();

    router.post('/', _registrar);
    router.get('/sessao/<sessaoId>', _listarPorSessao);
    router.get('/filme/<filmeId>/total', _totalPorFilme);

    return router;
  }

  Future<Response> _registrar(Request req) async {
    try {
      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      final registro = _service.registrar(body);
      return Response(
        201,
        body: jsonEncode(registro.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _erro(400, e.toString());
    }
  }

  Response _listarPorSessao(Request req, String sessaoId) {
    try {
      final lista = _service.listarPorSessao(int.parse(sessaoId));
      return Response.ok(
        jsonEncode(lista.map((r) => r.toJson()).toList()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _erro(500, e.toString());
    }
  }

  Response _totalPorFilme(Request req, String filmeId) {
    try {
      final total = _service.totalPorFilme(int.parse(filmeId));
      return Response.ok(
        jsonEncode({'filmeId': int.parse(filmeId), 'totalPublico': total}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _erro(500, e.toString());
    }
  }

  Response _erro(int status, String mensagem) {
    return Response(
      status,
      body: jsonEncode({'erro': mensagem}),
      headers: {'content-type': 'application/json'},
    );
  }
}
