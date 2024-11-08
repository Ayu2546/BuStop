import 'package:flutter/material.dart';
import 'dart:math';

class StarPuzzle extends StatefulWidget {
  @override
  _StarPuzzlePageState createState() => _StarPuzzlePageState();
}

class _StarPuzzlePageState extends State<StarPuzzle> {
  int? selectedSection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('五芒星パズル')),
      body: Center(
        child: GestureDetector(
          onTapUp: (details) {
            setState(() {
              selectedSection = getTappedSection(details.localPosition);
            });
          },
          child: CustomPaint(
            size: Size(300, 300),
            painter: StarPainter(selectedSection),
          ),
        ),
      ),
    );
  }

  // タップされたセクションを取得
  int? getTappedSection(Offset position) {
    double centerX = 150; // 中心座標
    double centerY = 150;
    double outerRadius = 150;
    double innerRadius = outerRadius / 2.5; // 内円の半径

    // 外円の頂点を計算
    List<Offset> outerPoints = [];
    double angle = (360.0 / 5) * (pi / 180);
    for (int i = 0; i < 5; i++) {
      double currentAngle = i * angle;
      outerPoints.add(Offset(
        centerX + outerRadius * cos(currentAngle),
        centerY + outerRadius * sin(currentAngle),
      ));
    }

    // 内円の頂点を計算
    List<Offset> innerPoints = [];
    for (int i = 0; i < 5; i++) {
      double currentAngle = (i + 0.5) * angle;
      innerPoints.add(Offset(
        centerX + innerRadius * cos(currentAngle),
        centerY + innerRadius * sin(currentAngle),
      ));
    }

    // クリック位置が外側の三角形に触れたかどうかを判定
    for (int i = 0; i < 5; i++) {
      if (isPointInTriangle(position, centerX, centerY, outerPoints[i], innerPoints[i], outerPoints[(i + 1) % 5])) {
        return i; // 外側三角形
      }
    }

    // 中央の五角形に触れたかどうかを判定
    if (isPointInPolygon(position, innerPoints)) {
      return 5; // 中央五角形
    }

    return null; // どれにも触れていない
  }

  // 点が三角形の内部にあるかどうかを判定する
  bool isPointInTriangle(Offset p, double x1, double y1, Offset p1, Offset p2, Offset p3) {
    double area1 = area(p1, p2, p3);
    double area2 = area(p, p2, p3);
    double area3 = area(p1, p, p3);
    double area4 = area(p1, p2, p);

    return (area1 == area2 + area3 + area4);
  }

  // 三角形の面積を計算する (ベクトルの外積を使って計算)
  double area(Offset p1, Offset p2, Offset p3) {
    return 0.5 * (-p2.dy * p3.dx + p1.dy * (-p2.dx + p3.dx) + p1.dx * (p2.dy - p3.dy) + p2.dx * p3.dy);
  }

  // 点が五角形の内部にあるかどうかを判定する
  bool isPointInPolygon(Offset p, List<Offset> polygon) {
    int i, j = polygon.length - 1;
    bool oddNodes = false;
    for (i = 0; i < polygon.length; i++) {
      if (p.dy < polygon[i].dy && p.dy >= polygon[j].dy ||
          p.dy < polygon[j].dy && p.dy >= polygon[i].dy) {
        if (p.dx <= (polygon[j].dx - polygon[i].dx) * (p.dy - polygon[i].dy) / (polygon[j].dy - polygon[i].dy) + polygon[i].dx) {
          oddNodes = !oddNodes;
        }
      }
      j = i;
    }
    return oddNodes;
  }
}

class StarPainter extends CustomPainter {
  final int? highlightedSection;

  StarPainter(this.highlightedSection);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;

    // 外側三角形と中心五角形を描画
    drawFivePointStar(canvas, size, paint);
  }

  void drawFivePointStar(Canvas canvas, Size size, Paint paint) {
    Path path = Path();

    // 外円と内円の半径
    double outerRadius = size.width / 2;
    double innerRadius = outerRadius / 2.5;

    // 星の中心座標
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // 5角形の角度（360度 / 5）
    double angle = (360.0 / 5) * (pi / 180);  // ラジアンに変換

    // 角度のオフセット（傾きの調整）
    double offsetAngle = 60; // 60度傾ける

    // 外円の頂点を描画
    List<Offset> outerPoints = [];
    for (int i = 0; i < 5; i++) {
      double currentAngle = i * angle + offsetAngle;
      outerPoints.add(Offset(
        centerX + outerRadius * cos(currentAngle),
        centerY + outerRadius * sin(currentAngle),
      ));
    }

    // 内円の頂点を描画
    List<Offset> innerPoints = [];
    for (int i = 0; i < 5; i++) {
      double currentAngle = (i + 0.5) * angle + offsetAngle;
      innerPoints.add(Offset(
        centerX + innerRadius * cos(currentAngle),
        centerY + innerRadius * sin(currentAngle),
      ));
    }

    // 外円の頂点と内円の頂点を交互に結ぶ
    paint.color = Colors.blue;
    path.moveTo(outerPoints[0].dx, outerPoints[0].dy); // 最初の外円の点
    for (int i = 0; i < 5; i++) {
      path.lineTo(innerPoints[i].dx, innerPoints[i].dy); // 内円の点
      path.lineTo(outerPoints[(i + 1) % 5].dx, outerPoints[(i + 1) % 5].dy); // 次の外円の点
    }

    path.close(); // パスを閉じて五芒星にする

// セクションが選ばれている場合、そのセクションを赤色で塗りつぶす
    if (highlightedSection != null) {
      if (highlightedSection == 5) {
        // 中央五角形
        paint.color = Colors.red;
        path.reset();

        // 中央五角形を描く
        for (int i = 0; i < 5; i++) {
          path.lineTo(innerPoints[i].dx, innerPoints[i].dy);
          path.lineTo(innerPoints[(i + 1) % 5].dx, innerPoints[(i + 1) % 5].dy);
        }
        path.close();
        canvas.drawPath(path, paint);
      } else {
        // 内側三角形（五芒星の内部の三角形）
        paint.color = Colors.red;
        path.reset();

        // 内側三角形の描画
        path.moveTo(innerPoints[highlightedSection!].dx, innerPoints[highlightedSection!].dy); // 内円の頂点
        path.lineTo(innerPoints[(highlightedSection! + 1) % 5].dx, innerPoints[(highlightedSection! + 1) % 5].dy); // 隣の内円の頂点
        path.lineTo(outerPoints[highlightedSection!].dx, outerPoints[highlightedSection!].dy); // 外円の頂点
        path.close();

        canvas.drawPath(path, paint);
      }
    } else {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}