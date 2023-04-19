import 'package:flutter/material.dart';

class NameWidget extends StatelessWidget {
  final String name;
  const NameWidget({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 6,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(
          name,
        ),
      ),
    );
  }
}
