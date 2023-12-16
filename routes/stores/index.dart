import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:groc_server/helpers/mongo_helper.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoHelper.startConnection(context, getData(context));
    case HttpMethod.patch:
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> getData(RequestContext context) async {
  final isAuthenticated = context.read<bool>();
  if (isAuthenticated) {
    try {
      final request = context.request;

      var resp = MongoHelper.getStoreData('bigb');
      return resp;
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
  } else {
    return Response.json(
      statusCode: 401,
      body: {
        'status': 401,
        'message': 'You are not authorized to perform this request',
      },
    );
  }
}
