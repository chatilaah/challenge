import 'package:challenge/db/repo.dart';
import 'package:challenge/screens/home/bloc/orders_bloc.dart';
import 'package:challenge/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeApp extends StatelessWidget {
  ChallengeApp(String applicationSupportPath, {Key? key, required this.repo})
      : super(key: key) {
    _path = applicationSupportPath;
  }

  static String _path = '';
  static String get applicationSupportPath => _path;

  final Repo repo;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: bool,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OrdersBloc(repo),
          ),
        ],
        child: _AppRoot(key: key),
      ),
    );
  }
}

class _AppRoot extends StatelessWidget {
  const _AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
