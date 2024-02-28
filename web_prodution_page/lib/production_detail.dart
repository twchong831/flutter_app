import 'package:flutter/material.dart';

class ProductionDetailWidget extends StatelessWidget {
  List<String> name;
  List<String> value;
  Color? background;

  ProductionDetailWidget({
    super.key,
    required this.name,
    required this.value,
    Color? background_,
  }) : background = background_ ?? Colors.white;

  List<TableRow> _tableGenerator() {
    List<TableRow> list_ = <TableRow>[];

    for (var i = 0; i < name.length; i++) {
      list_.add(TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name[i],
              style: const TextStyle(
                // fontStyle: FontStyle.,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(value[i]),
          ),
        ],
      ));
    }

    return list_;
  }

  final GlobalKey key_ = GlobalKey();

  Size? getWidgetSize() {
    return key_.currentContext?.size;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      key: key_,
      border: TableBorder.all(),
      // defaultColumnWidth: FixedColumnWidth(30),
      children: _tableGenerator(),
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
      },
    );
  }
}
