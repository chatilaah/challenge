import 'package:challenge/api/utils/online_api.dart';
import 'package:challenge/screens/home/bloc/orders_bloc.dart';
import 'package:challenge/screens/home/views/item_tile.dart';
import 'package:challenge/screens/map/map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:number_paginator/number_paginator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// The current page.
  ///
  /// * This is a non-index value and should be treated as
  /// a human-friendly counter.
  int page = 1;

  /// Total pages to be displayed.
  ///
  /// * This value will be updated via an API call.
  int totalPages = 7;

  /// Limit of tiles to be displayed per page.
  ///
  /// * This value will be updated via an API call.
  int limit = 15;

  /// An indicator that tells whether pagination was setup or not.
  bool didSetupPagination = false;

  @override
  void initState() {
    super.initState();

    /// We will refresh our page on initialization.
    refreshPage();
  }

  /// Refreshes orders based on [page] number.
  ///
  /// * Throws a [RangeError] if [page] is less than 1.
  ///
  refreshPage({int page = 1}) {
    if (page < 1) throw RangeError('Cannot set page less than 1');
    this.page = page;
    context.read<OrdersBloc>().add(RequestOrders(page: page, limit: limit));
  }

  /// Creates a centered widget which consists of title, description.
  /// Additionally, if running in debug-mode, the [debugDescription]
  /// may come in handy to display more verbose messages.
  ///
  /// * If [kDebugMode] is true, [debugDescription] will be shown.
  /// Otherwise, it will be hidden.
  ///
  Widget centeredMessage(
      {required String title,
      String description = '',
      String debugDescription = '',
      Widget? child}) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description, textAlign: TextAlign.center)),
        if (kDebugMode)
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(debugDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11))),
        if (child != null) const SizedBox(height: 12),
        if (child != null) child
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrdersBloc, OrdersState>(builder: ((context, state) {
        if (state is OrdersInitial || state is OrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrdersLoadError) {
          return centeredMessage(
              title: state.type.toString(),
              description: state.type.toDescription(code: state.code),
              debugDescription: state.message,
              child: OutlinedButton(
                  onPressed: () => refreshPage(page: page),
                  child: const Text('Retry')));
        } else if (state is OrdersLoaded) {
          if (state.orders.code != kApiSuccess) {
            return centeredMessage(
                title: 'Oops... That\'s bad!',
                description:
                    'An error code (${state.orders.code}) was reported by the server.',
                child: OutlinedButton(
                    onPressed: () => refreshPage(page: page),
                    child: const Text('Retry')));
          }

          if (state.orders.data.isEmpty) {
            return centeredMessage(title: 'No item(s) found');
          }

          if (!didSetupPagination) {
            didSetupPagination = true;

            assert(state.orders.paginate != null);
            final paginate = state.orders.paginate!;

            totalPages = (paginate.total / paginate.perPage).round();
            limit = paginate.perPage;
          }

          final orders = state.orders.data;
          final favorites = state.favorites;

          return Column(
            children: [
              if (state.orders.offline)
                ListTile(
                    dense: true,
                    leading: const Icon(Icons.wifi_off),
                    title: const Text('Viewing in offline mode'),
                    subtitle: const Text('Tap to refresh'),
                    onTap: refreshPage),
              Expanded(
                child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: orders.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final data = orders.elementAt(index);

                      return ItemTile(
                          order: data,
                          onReadFavoriteState: () => favorites[data.id]!,
                          onChangeFavoriteState: (newState) async {
                            await state.repo
                                .setFavoriteState(data.id, newState);

                            if (newState) {
                              await FlutterLocalNotificationsPlugin().show(
                                  1,
                                  "Added order to favorites!",
                                  "You've just added an order to your favorites list.",
                                  const NotificationDetails(),
                                  payload: 'data');
                            } else {
                              SystemSound.play(SystemSoundType.click);
                            }

                            favorites[data.id] = newState;
                          },
                          onLocateMap: () async {
                            final lat = double.tryParse(data.address.lat);
                            final lng = double.tryParse(data.address.lng);

                            if (lat == null || lng == null) {
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) =>
                                    MapScreen(latitude: lat, longitude: lng),
                              ),
                            );
                          });
                    }),
              ),
            ],
          );
        }

        return centeredMessage(
          title: 'Undefined State',
          description: 'Please report this issue to the developer.',
        );
      })),
      bottomNavigationBar: NumberPaginator(
        numberPages: totalPages,
        onPageChange: (int index) {
          setState(() {
            // The API call doesn't play well with index-based
            // pages, so we are incrementing the page with one
            // value to conform with the API's design.
            page = index + 1;
          });

          refreshPage(page: page);
        },
      ),
    );
  }
}
