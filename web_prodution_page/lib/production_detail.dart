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
            padding: const EdgeInsets.all(5.0),
            child: Text(
              name[i],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(value[i]),
          ),
        ],
      ));
    }

    return list_;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: _tableGenerator(),
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
      },
    );
  }
}
