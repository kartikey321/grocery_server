// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:groc_server/models/grocery.dart';

class Cart {
  List<Grocery> items = [];
  DateTime? updateAt;
  Cart({
    required this.items,
    this.updateAt,
  });

  Cart copyWith({
    List<Grocery>? items,
    DateTime? updateAt,
  }) {
    return Cart(
      items: items ?? this.items,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((x) => x.toMap()).toList(),
      'updateAt': updateAt?.toIso8601String(),
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      items: List<Grocery>.from(
        (map['items'] as List).map<Grocery>(
          (x) => Grocery.fromMap(x as Map<String, dynamic>),
        ),
      ),
      updateAt: map['updateAt'] != null
          ? DateTime.parse(map['updateAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Cart(items: $items, updateAt: $updateAt)';

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.items, items) && other.updateAt == updateAt;
  }

  @override
  int get hashCode => items.hashCode ^ updateAt.hashCode;
}
