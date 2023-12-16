import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:groc_server/helpers/mongo_helper.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoHelper.startConnection(context, fetchStore(context, id));
    case HttpMethod.delete:
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> fetchStore(RequestContext context, String id) async {
  final data = await MongoHelper.getStoreData(id);
  return data;
}
