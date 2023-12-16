import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';
import 'package:groc_server/config/config.dart';
import 'package:groc_server/data/store_data.dart';
import 'package:groc_server/middlewares/authorization.dart';
import 'package:groc_server/helpers/hash.dart';
import 'package:groc_server/models/grocery.dart';
import 'package:groc_server/models/store.dart';
import 'package:groc_server/models/user.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:mongo_pool/mongo_pool.dart';

class MongoHelper {
  static mongo.Db? db;

  static Future<void> openDbPool(MongoDbPoolService service) async {
    try {
      await service.open();
    } on Exception catch (e) {
      /// handle the exception here
      print(e);
    }
  }

  static MongoDbPoolService poolService = MongoDbPoolService(
    const MongoPoolConfiguration(
      maxLifetimeMilliseconds: 100000,
      leakDetectionThreshold: 90000,
      uriString:
          'mongodb+srv://kartikey321:kartikey321@cluster0.ykqbrjy.mongodb.net/groc_server',
      poolSize: 100,
    ),
  );
  // static Future<mongo.Db> initiaize() async {
  //   await openDbPool(poolService);
  //
  //   /// Get a connection from pool
  //   db = await poolService.acquire();
  //   print(db!);
  //   return db!;
  // }
  static Response? callBack1;
  static Future<Response> startConnection(
    RequestContext context,
    Future<Response> callBack,
  ) async {
    try {
      db = await poolService.acquire();

      callBack1 = await callBack;
      return callBack1!;
    } catch (e) {
      return Response.json(
        statusCode: 500,
        body: {'message': e.toString()},
      );
    } finally {
      await poolService.release(db!);
    }
  }

  static Future<void> clearAllCollections() async {
    // Open the database connection if not already opened

    var collections = await db!.getCollectionNames();
    for (var collectionName in collections) {
      var collection = db!.collection(collectionName!);
      await collection.drop();
      print('Collection $collectionName cleared.');
    }
  }

  static String getReturnMap(
      {required bool success, required String message, dynamic data}) {
    Map<String, dynamic> returnMap = {"success": success, 'message': message};
    Map<String, dynamic> returnMapData = {
      "success": success,
      'message': message,
      'data': data
    };
    return jsonEncode(data == null ? returnMap : returnMapData);
  }

  static Future<Response> addGrocData() async {
    var storeCollection = db!.collection('stores');

    try {
      await storeCollection.insert(
        Store(
          name: 'BigBazaar',
          id: 'bigb',
          items: groc_data.map((e) => Grocery.fromMap(e)).toList(),
        ).toMap(),
      );
      print('Groceries added!');
      return Response(
        body: getReturnMap(success: true, message: 'Groceries added'),
      );
    } catch (e) {
      // Handle other errors, if any
      print('Error: $e');
      return Response(
        body: getReturnMap(success: false, message: 'Error $e'),
        statusCode: 500,
      );
    }
  }

  static Future<Response> signup(User user) async {
    final userCollection = db!.collection('users');

    final foundUser = await userCollection.findOne({'email': user.email});
    if (foundUser != null) {
      return Response.json(
        statusCode: 400,
        body: {
          'status': 400,
          'message': 'A user with the provided email already exists',
          'error': 'user_exists',
        },
      );
    }

    await userCollection.insertOne(user.toMap());
    return Response(
        body: getReturnMap(
            success: true, message: 'User registered successfully'));
  }

  static Future<Response> signin(
      {required String email, required String password}) async {
    final usersCollection = db!.collection('users');

    final foundUser = await usersCollection.findOne({'email': email});
    if (foundUser == null) {
      return Response(
          statusCode: 400,
          body: getReturnMap(
              success: false,
              message: 'No user found with the provided credentials'));
    }
    final foundUserPassword = foundUser['password'] as String;
    final hashedPassword = hashPassword(
      password,
    );
    if (hashedPassword != foundUserPassword) {
      return Response(
          statusCode: 400,
          body: getReturnMap(
              success: false, message: 'Incorrect email or password'));
    }

    final foundUserId = (foundUser['_id'] as ObjectId).$oid;
    final token = issueToken(foundUserId);
    return Response(
      statusCode: 200,
      body: getReturnMap(
        success: true,
        message: 'User logged in successfully',
        data: {'token': token},
      ),
    );
  }

  static Future<Response> getStoreData(String storeId) async {
    var storeCollection = db!.collection('stores');
    var data = await storeCollection.findOne(mongo.where.eq('id', storeId));
    print(data);
    if (data != null) {
      var store = Store.fromMap(data);
      return Response(
        body: getReturnMap(
            success: true, message: 'Found Store Data', data: store.toMap()),
      );
    } else {
      return Response(
          body: getReturnMap(
            success: false,
            message: 'No store with this id exists',
          ),
          statusCode: 500);
    }
  }

  static Future<Response> addItemToCart(String email, Grocery item) async {
    var userCollection = db!.collection('users');
    final query = mongo.where.eq('email', email);
    var updateBuilder = mongo.modify;

    updateBuilder.push('cart.items',
        item.toMap()); // replace with the actual item you want to add
    updateBuilder.set('cart.updateAt', DateTime.now().toIso8601String());

    var res = await userCollection.update(query, updateBuilder);

    print(res);

    print('Update operation was successful');
    return Response(
      body: getReturnMap(
        success: true,
        message: 'Update operation was successful',
      ),
    );
  }

  static Future<Response> getCheapestItem(String groceryName) async {
    var storeCollection = db!.collection('stores');
    var pipeline = [
      {'\$unwind': '\$items'},
      {
        '\$match': {
          'items.name': {
            '\$regex': '^${groceryName}\$',
            '\$options': 'i', // i option for case insensitive
          }
        }
      }
    ];

    Stream<Map<String, dynamic>> result =
        await storeCollection.aggregateToStream(pipeline);
    var res = await result.toList();
    List<Grocery> groceries = [];
    for (var data in res) {
      print(data);
      groceries.add(Grocery.fromMap(data['items'] as Map<String, dynamic>));
    }
    groceries.sort((a, b) => double.parse(a.current_price)
        .compareTo(double.parse((b.current_price))));
    if (groceries.isEmpty) {
      return Response(
          statusCode: HttpStatus.notFound,
          body: getReturnMap(success: false, message: 'Grocery not found'));
    }
    return Response(
        body: getReturnMap(
            success: true,
            message: 'Grocery found at store ${groceries[0].store}',
            data: groceries[0].toMap()));
  }
}
