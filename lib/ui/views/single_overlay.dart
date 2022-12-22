import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef EntryBuilder = Widget Function(
    void Function() remove);

Offset _target = Offset.zero;
double _width = 10;
double _height = 1000;
EntryBuilder? _entryBuilder;


mixin SingleOverlayMixin on Diagnosticable {

  void insertOverlay(BuildContext context, EntryBuilder? builder,
      {Offset? target, double? width, double? height}) {
    final size = MediaQuery.of(context).size;
    _insertOverlay(context, builder,
        target: target, width: width ?? size.width, height: height ?? size.height,);
  }

  void remove(){
    if(_overlay.mounted) {
      _overlay.remove();
    }
  }

}

void _insertOverlay(BuildContext context, EntryBuilder? builder,
    {Offset? target, double? width, double? height}) {
  if (target != null) {
    _target = target;
  }
  if (width != null) {
    _width = width;
  }
  if (height != null) {
    _height = height;
  }

  if (_overlay.mounted) {
    _overlay.remove();
  }
  _entryBuilder = builder;
  return Overlay.of(context)?.insert(_overlay);
}

var _overlay = OverlayEntry(builder: (context) {
  debugPrint('$_target w:$_width h:$_height');

  return Positioned(
    width: _width,
    height: _height,
    top: _target.dy,
    left: _target.dx,
    child: _entryBuilder != null
        ? _entryBuilder!(_overlay.remove)
        : Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => _overlay.remove(),
        child: Container(
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle, color: Colors.redAccent),
          child: const Text('Add an entryBuilder'),
        ),
      ),
    ),
  );
});
