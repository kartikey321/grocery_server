import 'package:dart_frog/dart_frog.dart';
import 'package:groc_server/middlewares/authorization.dart';
import 'package:groc_server/middlewares/cors_header.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(corsHeaders()).use(authorize());
}
