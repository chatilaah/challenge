import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:challenge/api/api.dart';
import 'package:challenge/api/utils/error_type.dart';
import 'package:challenge/api/utils/online_api.dart';
import 'package:challenge/db/repo.dart';
import 'package:equatable/equatable.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final Repo _repo;

  OrdersBloc(this._repo) : super(OrdersInitial()) {
    on<RequestOrders>((event, emit) async {
      emit(OrdersInitial());
      emit(OrdersLoading());
      try {
        final orders = await Api.provider().orders(event.page, event.limit);

        if (orders.code != kApiSuccess) {
          emit(OrdersLoadError(
              message: 'An API error has occurred', code: orders.code));
        } else {
          Map<String, bool> favorites = {};

          for (var i in orders.data) {
            favorites[i.id] = await _repo.getFavoriteState(i.id);
          }

          emit(OrdersLoaded(orders, favorites, _repo));
        }
      } catch (e) {
        if (e is SocketException) {
          emit(OrdersLoadError(message: e.toString(), type: ErrorType.socket));
        } else {
          emit(OrdersLoadError(message: e.toString(), type: ErrorType.parse));
        }
      }
    });
  }
}
