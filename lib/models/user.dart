// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

import 'package:groc_server/models/cart.dart';
import 'package:groc_server/models/diet.dart';

class User {
  String name;
  String email;
  int phoneNo;
  String password;
  LatLng location;
  String address;
  Cart cart;
  List<Diet>? diets;
  User({
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.password,
    required this.location,
    required this.address,
    required this.cart,
    this.diets,
  });

  User copyWith({
    String? name,
    String? email,
    int? phoneNo,
    String? password,
    LatLng? location,
    String? address,
    Cart? cart,
    List<Diet>? diets,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      password: password ?? this.password,
      location: location ?? this.location,
      address: address ?? this.address,
      cart: cart ?? this.cart,
      diets: diets ?? this.diets,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'password': password,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude
      },
      'address': address,
      'cart': cart.toMap(),
      'diets': diets?.map((x) => x.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    print(map['location']['latitude'] as double);
    print(map['location']['longitude'] as double);
    var locationMap = map['location'] as Map<String, dynamic>;
    var latitude = locationMap['latitude'] as double;
    var longitude = locationMap['longitude'] as double;
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      phoneNo: map['phoneNo'] as int,
      password: map['password'] as String,
      location: LatLng(latitude, longitude),
      address: map['address'] as String,
      cart: Cart.fromMap(map['cart'] as Map<String, dynamic>),
      diets: map['diets'] != null
          ? List<Diet>.from(
              (map['diets'] as List).map<Diet?>(
                (x) => Diet.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, email: $email, phoneNo: $phoneNo, password: $password, location: $location, address: $address, cart: $cart, diets: $diets)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        other.email == email &&
        other.phoneNo == phoneNo &&
        other.password == password &&
        other.location == location &&
        other.address == address &&
        other.cart == cart &&
        listEquals(other.diets, diets);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phoneNo.hashCode ^
        password.hashCode ^
        location.hashCode ^
        address.hashCode ^
        cart.hashCode ^
        diets.hashCode;
  }
}
