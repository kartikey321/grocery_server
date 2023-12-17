import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:groc_server/helpers/mongo_helper.dart';
import 'package:groc_server/models/grocery.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoHelper.startConnection(context, addItemToCart(context));
    case HttpMethod.delete:
    case HttpMethod.patch:
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> addItemToCart(RequestContext context) async {
  final request = context.request;
  final isAuthenticated = context.read<bool>();
  if (!isAuthenticated) {
    return Response(
      statusCode: HttpStatus.unauthorized,
      body: MongoHelper.getReturnMap(
        success: false,
        message: 'You are not authorized to perform this request',
      ),
    );
  }

  final requestBody = await request.body();
  final requestData = jsonDecode(requestBody) as Map<String, dynamic>;
  if (!(requestData.containsKey('email'))) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: MongoHelper.getReturnMap(
        success: false,
        message: 'Give storeId as well',
      ),
    );
  }
  print(requestData);
  var id = requestData['email'] as String;
  requestData.remove('email');

  final data = Grocery.fromMap(requestData);
  var res = await MongoHelper.addItemToCart(id, data);
  return res;
}

Future<Response> delItemFromCart(RequestContext context) async {
  final request = context.request;
  final isAuthenticated = context.read<bool>();
  if (!isAuthenticated) {
    return Response(
      statusCode: HttpStatus.unauthorized,
      body: MongoHelper.getReturnMap(
        success: false,
        message: 'You are not authorized to perform this request',
      ),
    );
  }
  final requestBody = await request.body();
  final requestData = jsonDecode(requestBody) as Map<String, dynamic>;
  if (!(requestData.containsKey('email'))) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: MongoHelper.getReturnMap(
        success: false,
        message: 'Give storeId as well',
      ),
    );
  }
  print(requestData);
  var email = requestData['email'] as String;
  var itemName = requestData['itemName'] as String;
  var res = await MongoHelper.removeItemFromCart(email, itemName);
  return res;
}
