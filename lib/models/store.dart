// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:groc_server/models/grocery.dart';

class Store {
  String name;
  String id;
  List<Grocery> items;
  Store({
    required this.name,
    required this.id,
    required this.items,
  });

  Store copyWith({
    String? name,
    String? id,
    List<Grocery>? items,
  }) {
    return Store(
      name: name ?? this.name,
      id: id ?? this.id,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      name: map['name'] as String,
      id: map['id'] as String,
      items: List<Grocery>.from(
        (map['items'] as List).map<Grocery>(
          (x) => Grocery.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) =>
      Store.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Store(name: $name, id: $id, items: $items)';

  @override
  bool operator ==(covariant Store other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        other.id == id &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ items.hashCode;
}
