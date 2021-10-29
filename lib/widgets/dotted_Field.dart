import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDottedBorder extends StatelessWidget {
  final Widget myChild;
  final Color background;
  final Color borderColor;
  final List<double> random;
  final bool fixedWidthRatio;
  final double chosenWidth;
  const InputDottedBorder({
    this.myChild,
    this.background,
    this.borderColor,
    this.random,
    this.fixedWidthRatio = true,
    this.chosenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: borderColor,
      borderType: BorderType.RRect,
      radius: Radius.circular(50),
      strokeWidth: 4,
      strokeCap: StrokeCap.round,
      dashPattern: random,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width:
            MediaQuery.of(context).size.width * (fixedWidthRatio ? 0.85 : chosenWidth),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: myChild,
      ),
    );
  }
}
