import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:groc_server/helpers/hash.dart';
import 'package:groc_server/helpers/mongo_helper.dart';
import 'package:groc_server/models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return MongoHelper.startConnection(context, signUp(context));
    case HttpMethod.patch:
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> signUp(RequestContext context) async {
  final request = context.request;

  final requestBody = await request.body();
  final requestData = jsonDecode(requestBody) as Map<String, dynamic>;
  print(requestData);
  final user = User.fromMap(requestData);
  user.password = hashPassword(
    user.password,
  );
  print(user);

  return MongoHelper.signup(user);
}
