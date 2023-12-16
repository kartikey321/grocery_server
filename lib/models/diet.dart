// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:groc_server/models/grocery.dart';

class Diet {
  String name;
  List<Grocery> items;
  Map<String, dynamic> extraData;
  Diet({
    required this.name,
    required this.items,
    required this.extraData,
  });

  Diet copyWith({
    String? name,
    List<Grocery>? items,
    Map<String, dynamic>? extraData,
  }) {
    return Diet(
      name: name ?? this.name,
      items: items ?? this.items,
      extraData: extraData ?? this.extraData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'items': items.map((x) => x.toMap()).toList(),
      'extraData': extraData,
    };
  }

  factory Diet.fromMap(Map<String, dynamic> map) {
    return Diet(
      name: map['name'] as String,
      items: List<Grocery>.from(
        (map['items'] as List).map<Grocery>(
          (x) => Grocery.fromMap(x as Map<String, dynamic>),
        ),
      ),
      extraData: Map<String, dynamic>.from(
        (map['extraData'] as Map<String, dynamic>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Diet.fromJson(String source) =>
      Diet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Diet(name: $name, items: $items, extraData: $extraData)';

  @override
  bool operator ==(covariant Diet other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        collectionEquals(other.items, items) &&
        collectionEquals(other.extraData, extraData);
  }

  @override
  int get hashCode => name.hashCode ^ items.hashCode ^ extraData.hashCode;
}
