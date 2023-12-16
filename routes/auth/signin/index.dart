import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:groc_server/helpers/mongo_helper.dart';
import 'package:groc_server/models/user.dart';
import 'package:mongo_pool/mongo_pool.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return MongoHelper.startConnection(context, signIn(context));
    case HttpMethod.patch:
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> signIn(RequestContext context) async {
  try {
    final request = context.request;
    final requestBody = await request.body();
    final requestData = jsonDecode(requestBody) as Map<String, dynamic>;
    return await MongoHelper.signin(
        email: requestData['email'] as String,
        password: requestData['password'] as String);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {
        'status': 500,
        'message': 'Server error. Something went wrong',
        'error': e.toString(),
      },
    );
  }
}


/*
try {
    final request = context.request;
    final requestBody = await request.body();
    final requestData = jsonDecode(requestBody) as Map<String, dynamic>;
    return await MongoHelper.signin(
        email: requestData['email'] as String,
        password: requestData['password'] as String);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {
        'status': 500,
        'message': 'Server error. Something went wrong',
        'error': e.toString(),
      },
    );
  }
*/