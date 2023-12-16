import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:groc_server/helpers/mongo_helper.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoHelper.startConnection(context, addGroc(context));
    case HttpMethod.patch:
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> addGroc(RequestContext context) async {
  return await MongoHelper.getCheapestItem('aashirvaad Atta');
}
