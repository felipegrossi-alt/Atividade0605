import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'controllers/sessao_controller.dart';
import 'controllers/registro_publico_controller.dart';

void main() async {
  final app = Router();

  app.mount('/sessoes', SessaoController().router);
  app.mount('/publico', RegistroPublicoController().router);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(app.call);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}
