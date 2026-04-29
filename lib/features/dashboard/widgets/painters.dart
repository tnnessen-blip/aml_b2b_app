import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class FlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 640;
    final scaleY = size.height / 300;
    Offset p(double x, double y) => Offset(x * scaleX, y * scaleY);

    final gridPaint = Paint()
      ..color = AppColors.line.withAlpha(140)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    void drawFlow(List<Offset> points, Color color) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var index = 1; index < points.length; index += 3) {
        if (index + 2 < points.length) {
          path.cubicTo(
            points[index].dx,
            points[index].dy,
            points[index + 1].dx,
            points[index + 1].dy,
            points[index + 2].dx,
            points[index + 2].dy,
          );
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
    }

    drawFlow([p(116, 143), p(214, 48), p(307, 57), p(395, 117)], AppColors.red);
    drawFlow([p(124, 161), p(234, 233), p(335, 233), p(474, 184)], AppColors.amber);
    drawFlow([p(404, 132), p(485, 93), p(543, 103), p(590, 152)], const Color(0xFF708C88));
    drawFlow([p(385, 146), p(307, 181), p(247, 199), p(181, 219)], AppColors.red);

    final nodes = [
      (p(104, 152), 33.0 * scaleX, 'NI', AppColors.red),
      (p(402, 128), 26.0 * scaleX, 'DX', AppColors.amber),
      (p(494, 180), 22.0 * scaleX, 'PEP', AppColors.green),
      (p(595, 156), 18.0 * scaleX, 'HK', AppColors.teal),
      (p(175, 221), 21.0 * scaleX, 'LT', AppColors.indigo),
    ];

    for (final node in nodes) {
      canvas.drawCircle(node.$1, node.$2, Paint()..color = Colors.white);
      canvas.drawCircle(node.$1, node.$2 - 3, Paint()..color = node.$4);
      final painter = TextPainter(
        text: TextSpan(
          text: node.$3,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, node.$1 - Offset(painter.width / 2, painter.height / 2 + 3));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrendPainter extends CustomPainter {
  TrendPainter(this.range);

  final String range;

  @override
  void paint(Canvas canvas, Size size) {
    final values = switch (range) {
      '7 d' => [44, 39, 48, 53, 57, 62, 69, 76],
      '30 d' => [58, 61, 56, 64, 72, 70, 82, 91],
      _ => [18, 25, 21, 34, 29, 43, 52, 61],
    };
    final minValue = values.reduce((a, b) => a < b ? a : b) - 10;
    final maxValue = values.reduce((a, b) => a > b ? a : b) + 10;
    const padding = 22.0;

    final gridPaint = Paint()
      ..color = AppColors.line
      ..strokeWidth = 1;
    for (var index = 0; index < 4; index += 1) {
      final y = padding + index * ((size.height - padding * 2) / 3);
      canvas.drawLine(Offset(padding, y), Offset(size.width - padding, y), gridPaint);
    }

    final points = <Offset>[];
    for (var index = 0; index < values.length; index += 1) {
      final x = padding + index * ((size.width - padding * 2) / (values.length - 1));
      final y = size.height -
          padding -
          ((values[index] - minValue) / (maxValue - minValue)) * (size.height - padding * 2);
      points.add(Offset(x, y));
    }

    final fillPath = Path()
      ..moveTo(points.first.dx, size.height - padding)
      ..addPolygon(points, false)
      ..lineTo(points.last.dx, size.height - padding)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = AppColors.teal.withAlpha(38));

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.teal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    for (final point in points) {
      canvas.drawCircle(point, 5, Paint()..color = Colors.white);
      canvas.drawCircle(
        point,
        5,
        Paint()
          ..color = AppColors.teal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TrendPainter oldDelegate) => oldDelegate.range != range;
}
