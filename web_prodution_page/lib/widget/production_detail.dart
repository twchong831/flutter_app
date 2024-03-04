import 'package:flutter/material.dart';

class ProductionDetailWidget extends StatelessWidget {
  List<String> name;
  List<String> value;
  Color? background;
  double? baseFontSize;

  ProductionDetailWidget({
    super.key,
    required this.name,
    required this.value,
    Color? background_,
    double? baseFontSize_,
  })  : background = background_ ?? Colors.white,
        baseFontSize = baseFontSize_ ?? 20;

  List<TableRow> _tableGenerator() {
    // const double fontSize1 = 25;
    // const double fontSize2 = 23;
    List<TableRow> list_ = <TableRow>[];

    for (var i = 0; i < name.length; i++) {
      list_.add(TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              '- ${name[i]}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: baseFontSize,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text(
              ':',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: baseFontSize,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 5,
              end: 3,
              top: 3,
              bottom: 3,
            ),
            child: Text(
              value[i],
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: (baseFontSize! * 0.8),
              ),
            ),
          ),
        ],
      ));
    }

    return list_;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: const TableBorder(
        horizontalInside: BorderSide(
          color: Colors.black87,
          width: 1,
        ),
        bottom: BorderSide(
          color: Colors.black87,
          width: 1,
        ),
      ),
      // border: TableBorder.all(),
      children: _tableGenerator(),
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
    );
  }
}
