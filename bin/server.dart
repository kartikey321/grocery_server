// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/index.dart' as index;
import '../routes/user/cart/index.dart' as user_cart_index;
import '../routes/stores/index.dart' as stores_index;
import '../routes/stores/data/[id].dart' as stores_data_$id;
import '../routes/stores/cheapest_item/[id].dart' as stores_cheapest_item_$id;
import '../routes/auth/signup/index.dart' as auth_signup_index;
import '../routes/auth/signin/index.dart' as auth_signin_index;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  createServer(address, port);
}

Future<HttpServer> createServer(InternetAddress address, int port) async {
  final handler = Cascade().add(buildRootHandler()).handler;
  final server = await serve(handler, address, port);
  print('\x1B[92m✓\x1B[0m Running on http://${server.address.host}:${server.port}');
  return server;
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/auth/signin', (context) => buildAuthSigninHandler()(context))
    ..mount('/auth/signup', (context) => buildAuthSignupHandler()(context))
    ..mount('/stores/cheapest_item', (context) => buildStoresCheapestItemHandler()(context))
    ..mount('/stores/data', (context) => buildStoresDataHandler()(context))
    ..mount('/stores', (context) => buildStoresHandler()(context))
    ..mount('/user/cart', (context) => buildUserCartHandler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildAuthSigninHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => auth_signin_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildAuthSignupHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => auth_signup_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildStoresCheapestItemHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<id>', (context,id,) => stores_cheapest_item_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildStoresDataHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<id>', (context,id,) => stores_data_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildStoresHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => stores_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildUserCartHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => user_cart_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

