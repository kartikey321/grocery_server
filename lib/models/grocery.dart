// ignore_for_file: public_member_api_docs, non_constant_identifier_names, sort_constructors_first, avoid_equals_and_hash_code_on_mutable_classes

import 'dart:convert';

class Grocery {
  final String name;
  final String id;
  final String category;
  final String current_price;
  final String store;
  final String quantity;
  final String last_price;
  final String normal_price;
  Grocery({
    required this.name,
    required this.id,
    required this.category,
    required this.current_price,
    required this.store,
    required this.quantity,
    required this.last_price,
    required this.normal_price,
  });

  Grocery copyWith({
    String? name,
    String? id,
    String? category,
    String? current_price,
    String? store,
    String? quantity,
    String? last_price,
    String? normal_price,
  }) {
    return Grocery(
      name: name ?? this.name,
      id: id ?? this.id,
      category: category ?? this.category,
      current_price: current_price ?? this.current_price,
      store: store ?? this.store,
      quantity: quantity ?? this.quantity,
      last_price: last_price ?? this.last_price,
      normal_price: normal_price ?? this.normal_price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'category': category,
      'current_price': current_price,
      'store': store,
      'quantity': quantity,
      'last_price': last_price,
      'normal_price': normal_price,
    };
  }

  factory Grocery.fromMap(Map<String, dynamic> map) {
    return Grocery(
      name: map['name'] as String,
      id: map['id'] as String,
      category: map['category'] as String,
      current_price: map['current_price'] as String,
      store: map['store'] as String,
      quantity: map['quantity'] as String,
      last_price: map['last_price'] as String,
      normal_price: map['normal_price'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Grocery.fromJson(String source) =>
      Grocery.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Grocery(name: $name, id: $id, category: $category, current_price: $current_price, store: $store, quantity: $quantity, last_price: $last_price, normal_price: $normal_price)';
  }

  @override
  bool operator ==(covariant Grocery other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        other.category == category &&
        other.current_price == current_price &&
        other.store == store &&
        other.quantity == quantity &&
        other.last_price == last_price &&
        other.normal_price == normal_price;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        category.hashCode ^
        current_price.hashCode ^
        store.hashCode ^
        quantity.hashCode ^
        last_price.hashCode ^
        normal_price.hashCode;
  }
}
