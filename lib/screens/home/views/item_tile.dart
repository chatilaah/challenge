import 'package:challenge/api/models/orders.dart';
import 'package:challenge/screens/item_detail/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnChangeFavoriteStateCallback = Future<void> Function(bool);
typedef OnReadFavoriteStateCallback = bool Function();
typedef OnLocateMapCallback = void Function();

class ItemTile extends StatefulWidget {
  final Datum order;
  final OnChangeFavoriteStateCallback onChangeFavoriteState;
  final OnReadFavoriteStateCallback onReadFavoriteState;
  final OnLocateMapCallback onLocateMap;

  const ItemTile({
    Key? key,
    required this.order,
    required this.onChangeFavoriteState,
    required this.onReadFavoriteState,
    required this.onLocateMap,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    final data = widget.order;

    List<Widget> items = [];

    for (int i = 0; i < data.items.length; i++) {
      final item = data.items[i];

      items.add(ListTile(
        dense: true,
        title: Text('${item.name} (${item.id})'),
        subtitle: Text('${item.price} ${data.currency}'),
      ));
    }

    bool isFav = widget.onReadFavoriteState();

    Future<void> _toggleFav() async {
      await widget.onChangeFavoriteState(!isFav);
      setState(() => isFav = widget.onReadFavoriteState());
    }

    items.add(
      Padding(
          padding: const EdgeInsets.all(8),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              icon: isFav.toFavoriteIcon(),
              tooltip: isFav.toFavoriteString(),
              onPressed: _toggleFav,
            ),
            IconButton(
                icon: const Icon(Icons.pin_drop),
                onPressed: widget.onLocateMap,
                tooltip: 'Locate on Map'),
            IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemDetailScreen(
                                item: data,
                                onToggleFavorites: _toggleFav,
                                onReadFavoriteState: () => isFav,
                                onLocateMap: widget.onLocateMap,
                              )));
                },
                tooltip: 'Show details')
          ])),
    );

    return Card(
      child: ExpansionTile(
        title: Text('\n# ${widget.order.id}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            '${widget.order.total} ${widget.order.currency}\n\n${DateFormat.yMMMEd().format(widget.order.createdAt)}\n'),
        maintainState: true,
        children: items,
      ),
    );
  }
}

extension BoolExtension on bool {
  String toFavoriteString() =>
      this ? 'Remove from favorites' : 'Add to favorites';

  Icon toFavoriteIcon() => this
      ? const Icon(Icons.favorite, color: Colors.red)
      : const Icon(Icons.favorite_border_outlined);
}
