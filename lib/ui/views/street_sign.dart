import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StreetSign extends SingleChildRenderObjectWidget {
  final StreetSignType type;
  const StreetSign(
      {required super.child, this.type = StreetSignType.streetName, super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderStreetSign(
      type,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderStreetSign renderObject) {}
}

class RenderStreetSign extends RenderProxyBox {
  final StreetSignType type;
  RenderStreetSign(
    this.type,
  );

  @override
  bool get isRepaintBoundary => false;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final double indent = size.longestSide * .05;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        type == StreetSignType.streetName
            ?
        Rect.fromLTWH(0, 0, size.width, size.height)
            : Rect.fromLTWH(0, 0, size.longestSide, size.longestSide),
        const Radius.circular(2.5),
      ),
      Paint()..color = CupertinoColors.activeBlue,
    );
    if (type == StreetSignType.houseNumber) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            indent,
            indent,
            size.longestSide - (indent * 2),
            size.longestSide - (indent * 2),
          ),
          const Radius.circular(5.0),
        ),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = indent,
      );
    }

    if (child != null) {
      context.paintChild(
          child!,
          type == StreetSignType.streetName
              ? Offset(size.width / 2 - child!.size.width / 2,
                  size.height / 2 - child!.size.height / 2)
              : Offset(size.longestSide / 2 - child!.size.width / 2,
                  size.longestSide / 2 - child!.size.height / 2));
    }
    canvas.restore();
  }
}

enum StreetSignType {
  streetName,
  houseNumber,
}
