import 'package:flutter/material.dart';

class ViewerSetScreen extends StatefulWidget {
  final double _gridSizeMax;
  final double _gridSizeMin;
  final double _pointSize;

  const ViewerSetScreen({
    super.key,
    double? gridMax,
    double? gridMin,
    double? ptSize,
  })  : _gridSizeMax = gridMax ?? 15,
        _gridSizeMin = gridMin ?? 0,
        _pointSize = ptSize ?? 1.0;

  @override
  State<ViewerSetScreen> createState() => _ViewerSetScreenState();
}

class _ViewerSetScreenState extends State<ViewerSetScreen> {
  @override
  void initState() {
    print('check parameter');
    print(widget._gridSizeMax);
    print(widget._gridSizeMin);
    print(widget._pointSize);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          const Text('Grid Setting'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${widget._gridSizeMax}'),
              const Icon(Icons.battery_0_bar_sharp),
              Text('${widget._gridSizeMin}'),
            ],
          ),
          const Text('Point Size'),
          Text('${widget._pointSize}'),
        ],
      ),
    );
  }
}
