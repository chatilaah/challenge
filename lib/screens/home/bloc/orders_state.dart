part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final Orders orders;
  final Map<String, bool> favorites;
  final Repo repo;

  const OrdersLoaded(this.orders, this.favorites, this.repo);
}

class OrdersLoadError extends OrdersState {
  final ErrorType type;
  final String message;
  final int? code;

  const OrdersLoadError(
      {required this.message, this.type = ErrorType.unknown, this.code});
}
