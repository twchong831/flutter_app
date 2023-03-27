import 'package:flutter/material.dart';
import 'package:pointcloud_data_viewer/ditredi_/viewer_config_controller.dart';

class ViewerSetScreen extends StatefulWidget {
  final ViewerConfigController vConfigController;

  ViewerSetScreen({
    super.key,
    ViewerConfigController? configController,
  }) : vConfigController = configController ?? ViewerConfigController();

  @override
  State<ViewerSetScreen> createState() => _ViewerSetScreenState();
}

class _ViewerSetScreenState extends State<ViewerSetScreen> {
  final textController = TextEditingController();
  // RangeValues _rangeValues = const RangeValues(0, 20);
  late ViewerConfigController? updateController;

  @override
  void initState() {
    super.initState();
    updateController = widget.vConfigController;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          const Text('Grid Setting'),
          const Text('X-Axis'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 20,
                child: Text('${updateController!.getGridRangeXStart.toInt()}'),
              ),
              Expanded(
                child: RangeSlider(
                  values: updateController!.getGridRangeX,
                  max: updateController!.getMaxRangeX.end,
                  min: updateController!.getMaxRangeX.start,
                  divisions: updateController!.rangeXdivision(),
                  onChanged: (value) {
                    setState(() {
                      updateController!.updateGridRangeX(value);
                    });
                  },
                ),
              ),
              SizedBox(
                width: 20,
                child: Text('${updateController!.getGridRangeXEnd.toInt()}'),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const Text('Y-Axis'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 20,
                child: Text('${updateController!.getGridRangeYStart.toInt()}'),
              ),
              Expanded(
                child: RangeSlider(
                  values: updateController!.getGridRangeY,
                  max: updateController!.getMaxRangeY.end,
                  min: updateController!.getMaxRangeY.start,
                  divisions: updateController!.rangeYdivision(),
                  onChanged: (value) {
                    setState(() {
                      updateController!.updateGridRangeY(value);
                      print('range Change : $widget._rangeValues');
                    });
                  },
                ),
              ),
              SizedBox(
                width: 20,
                child: Text('${updateController!.getGridRangeYEnd.toInt()}'),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          Text('Point Size : ${updateController!.getPointSize}'),
          // Text('${widget._pointSize}'),
          Slider(
            value: updateController!.getPointSize,
            max: 5.0,
            min: 1.0,
            divisions: 4,
            onChanged: (value) {
              setState(() {
                updateController!.updatePointSize(double.parse(
                  value.toStringAsFixed(1),
                ));
              });
            },
          )
        ],
      ),
    );
  }
}
