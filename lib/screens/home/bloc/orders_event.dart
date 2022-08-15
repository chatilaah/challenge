part of 'orders_bloc.dart';

abstract class OrdersEvent {}

class RequestOrders extends OrdersEvent {
  final int page;
  final int limit;

  RequestOrders({required this.page, this.limit = 15});
}
