import 'package:challenge/api/models/orders.dart';

class ItemEx extends Item {
  final bool isFavorite;

  ItemEx({
    required super.id,
    required super.name,
    required super.price,
    this.isFavorite = false,
  });
}
