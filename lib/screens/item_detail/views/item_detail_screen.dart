import 'package:challenge/api/models/orders.dart';
import 'package:challenge/screens/home/views/item_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef OnToggleFavoritesCallback = Future<void> Function();

class ItemDetailScreen extends StatefulWidget {
  final Datum item;
  final OnReadFavoriteStateCallback onReadFavoriteState;
  final OnToggleFavoritesCallback onToggleFavorites;
  final OnLocateMapCallback onLocateMap;

  const ItemDetailScreen({
    Key? key,
    required this.item,
    required this.onToggleFavorites,
    required this.onReadFavoriteState,
    required this.onLocateMap,
  }) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    var isFav = widget.onReadFavoriteState();

    return Scaffold(
      appBar: AppBar(title: Text('Order ID# ${widget.item.id}')),
      body: ListView(shrinkWrap: true, children: [
        Container(
          color: theme.dialogBackgroundColor,
          height: 220,
          width: mediaQuery.size.width,
          child: Image.network(widget.item.image,
              errorBuilder: ((context, error, stackTrace) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.error, color: theme.errorColor),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Failed to load image',
                          style: TextStyle(color: theme.errorColor))),
                  if (kDebugMode)
                    Text(error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11))
                ]));
          }), loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress?.cumulativeBytesLoaded ==
                loadingProgress?.expectedTotalBytes) {
              return child;
            }

            return const Center(child: CircularProgressIndicator());
          }),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12.0),
            itemCount: widget.item.items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = widget.item.items[index];

              return Card(
                  child: ListTile(
                title: Text(item.name),
                trailing: Text('${item.price} ${widget.item.currency}'),
                subtitle: Text('# ${item.id}'),
              ));
            }),
        ListTile(
            trailing: Text('${widget.item.total} ${widget.item.currency}',
                style: const TextStyle(fontSize: 22))),
        const Divider(),
        const Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0),
            child:
                Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
              child: Column(children: [
            ListTile(
                leading: isFav.toFavoriteIcon(),
                title: Text(isFav.toFavoriteString()),
                onTap: () async {
                  await widget.onToggleFavorites();

                  setState(() {
                    // do nothing.
                  });
                }),
            ListTile(
              leading: const Icon(Icons.pin_drop),
              title: const Text('Locate on Map'),
              onTap: widget.onLocateMap,
            )
          ])),
        )
      ]),
    );
  }
}
