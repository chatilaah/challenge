import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState.authenticated()) {
    on<AppUserChanged>(_onUserChanged);
    (user) => add(const AppUserChanged());
    on<AuthenticationLogoutRequested>((event, emit) {
      emit(const AppState.unauthenticated());
    });
  }

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) =>
      emit(const AppState.authenticated());
}
