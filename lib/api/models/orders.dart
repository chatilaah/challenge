// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

import 'package:challenge/api/models/base_response.dart';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders extends BaseResponse<List<Datum>> {
  Orders({
    this.data = const [],
    this.code = 0,
    this.message = '',
    this.paginate,
  });

  /// Creates an [Orders] object, but with [hasError] value set to true by default.
  factory Orders.empty({int code = 0}) => Orders(code: code);

  @override
  List<Datum> data;

  @override
  int code;

  @override
  String message;

  final Paginate? paginate;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        code: json["code"],
        message: json["message"],
        paginate: Paginate.fromJson(json["paginate"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "code": code,
        "message": message,
        "paginate": paginate?.toJson(),
      };
}

class Datum {
  Datum({
    required this.total,
    required this.createdAt,
    required this.image,
    required this.currency,
    required this.id,
    required this.address,
    required this.items,
  });

  String total;
  DateTime createdAt;
  String image;
  String currency;
  String id;
  Address address;
  List<Item> items;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        total: json["total"],
        createdAt: DateTime.parse(json["created_at"]),
        image: json["image"],
        currency: json["currency"],
        id: json["id"],
        address: Address.fromJson(json["address"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "image": image,
        "currency": currency,
        "id": id,
        "address": address.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Address {
  Address({
    required this.lat,
    required this.lng,
  });

  final String lat;
  final String lng;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Item {
  Item({
    required this.id,
    required this.name,
    required this.price,
  });

  final int id;
  final String name;
  final String price;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
      };
}

class Paginate {
  Paginate({
    required this.total,
    required this.perPage,
  });

  int total;
  int perPage;

  factory Paginate.fromJson(Map<String, dynamic> json) => Paginate(
        total: json["total"],
        perPage: json["per_page"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
      };
}
