import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/sessao_service.dart';

class SessaoController {
  final SessaoService _service = SessaoService();

  Router get router {
    final router = Router();

    router.get('/', _listar);
    router.post('/', _criar);
    router.get('/<id>', _buscar);
    router.delete('/<id>', _excluir);

    return router;
  }

  Response _listar(Request req) {
    try {
      final sessoes = _service.listar();
      return Response.ok(
        jsonEncode(sessoes.map((s) => s.toJson()).toList()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _erro(500, e.toString());
    }
  }

  Future<Response> _criar(Request req) async {
    try {
      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      final sessao = _service.criar(body);
      return Response(
        201,
        body: jsonEncode(sessao.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _erro(400, e.toString());
    }
  }

  Response _buscar(Request req, String id) {
    try {
      final sessao = _service.buscar(int.parse(id));
      return Response.ok(
        jsonEncode(sessao.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return _erro(404, e.toString());
    }
  }

  Response _excluir(Request req, String id) {
    try {
      _service.excluir(int.parse(id));
      return Response(204);
    } catch (e) {
      return _erro(404, e.toString());
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
