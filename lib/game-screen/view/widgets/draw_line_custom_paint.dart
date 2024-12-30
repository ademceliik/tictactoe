import 'package:flutter/material.dart';

import '../../model/direction_enum.dart';

class DrawLineCustomPaint extends CustomPainter {
  final double heightProps;
  final Size moveTo;
  final Size lineTo;
  final Direction direction;
  DrawLineCustomPaint(
      {required this.moveTo,
      required this.lineTo,
      required this.heightProps,
      required this.direction});
  @override
  void paint(Canvas canvas, Size size) {
    double moveToWidth = size.width * moveTo.width;
    double moveToHeight = size.height * moveTo.height;
    double lineToWidth = size.width * lineTo.width;
    double lineToHeight = size.height * lineTo.height;
    // Layer 1
    Paint paintFill0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.0
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    // every container has w*0.25 size, w.0.02 left padding, w*0.02 bottom pading
    // vertical distance is w* 0.33, middle of container is 0.19
    // horizantal distance is w* 0.33, middle of container is 0.165
    Path path_0 = Path();

    if (direction == Direction.drawRowFromLeft) {
      path_0.moveTo(moveToWidth * heightProps, moveToHeight);
    } else if (direction == Direction.drawColumnFromTop) {
      path_0.moveTo(moveToWidth, moveToHeight * heightProps);
    } else {
      path_0.moveTo(moveToWidth, moveToHeight);
    }

    if (direction == Direction.drawRow) {
      path_0.lineTo(lineToWidth * heightProps, lineToHeight);
    } else if (direction == Direction.drawColumn) {
      path_0.lineTo(lineToWidth, lineToHeight * heightProps);
    } else if (direction == Direction.drawCrossFromTop) {
      path_0.lineTo(lineToWidth * heightProps, lineToHeight * heightProps);
    } else if (direction == Direction.drawCrossFromBot) {
      path_0.lineTo(lineToWidth * heightProps,
          size.width * (lineTo.height - heightProps));
    } else {
      path_0.lineTo(lineToWidth, lineToHeight);
    }

    canvas.drawPath(path_0, paintFill0);

    // Layer 1

    Paint paintStroke0 = Paint()
      ..color = const Color.fromARGB(255, 255, 0, 4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
