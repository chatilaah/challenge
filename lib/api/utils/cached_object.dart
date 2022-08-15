// To parse this JSON data, do
//
//     final cachedObject = cachedObjectFromJson(jsonString);

import 'dart:convert';

CachedObject cachedObjectFromJson(String str) =>
    CachedObject.fromJson(json.decode(str));

String cachedObjectToJson(CachedObject data) => json.encode(data.toJson());

class CachedObject {
  CachedObject({
    required this.lastUpdated,
    required this.data,
  });

  DateTime lastUpdated;
  dynamic data;

  factory CachedObject.fromJson(Map<String, dynamic> json) => CachedObject(
        lastUpdated: DateTime.parse(json["lastUpdated"]),
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "lastUpdated": lastUpdated.toIso8601String(),
        "data": data,
      };
}
