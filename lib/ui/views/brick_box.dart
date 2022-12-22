import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi;

const url =
    'https://media.istockphoto.com/id/1189847414/vector/seamless-brick-wall.jpg?s=170667a&w=0&k=20&c=77CvQmJO54rL-FV9l3D7f24ZmGshxQtaFpB-2vqnfj0=';

class BoxWidget extends StatefulWidget {
  final BoxWidgetController controller;
  final Widget child;
  final Widget? back;
  final Duration duration;
  final VoidCallback onFinished;
  const BoxWidget(
      {required this.onFinished,
      this.duration = const Duration(seconds: 1),
      super.key,
      required this.controller,
      required this.child,
      this.back});

  @override
  State<StatefulWidget> createState() => BoxWidgetState();
}

class BoxWidgetState extends State<BoxWidget> with TickerProviderStateMixin {
  late AnimationController animationController;
  bool front = true;
  double _tilt = .0;

  void tilt(double delta) {
    setState(() {
      _tilt = clampDouble(delta, -1.0, 1.0);
    });
  }

  Future rotate() async {
    if (animationController.isAnimating) return;
    front = !front;
    if (front) {
      await animationController.reverse();
    } else {
      await animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, child) {
        final angle = animationController.value * -pi;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, .001)
            ..rotateX(pi / 10 / 2 * _tilt)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isFrontSide(angle.abs())
              ? widget.child
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child:
                      Frame(
                    isFront: false,
                    lampColor: Colors.amber,
                    sides: List.generate(
                      5,
                      (index) => Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            url,
                          ),
                        )),
                      ),
                    ),
                    scale: 1,
                    z: -10.0,
                    relativeExtent: 200.0,
                    widget.back ?? Container(),
                  ),
                ),
        );
      },
      animation: animationController,
    );
  }

  bool isFrontSide(double angle) {
    const bias = pi * .05;
    const deg90 = pi / 2;
    const deg270 = 3 * pi / 2;
    return angle <= deg90 - bias || angle >= deg270;
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished();
      }
    });
    widget.controller._state = this;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class BoxWidgetController {
  BoxWidgetState? _state;

  bool get isFront => _state?.front ?? true;

  Future rotate() async => _state?.rotate();

  void tilt(double angle) => _state?.tilt(angle);
}

class Frame extends StatelessWidget {
  final Widget child;
  final double scale;
  final double z;
  final Color lampColor;
  final double _intensity;
  final bool isFront;
  final Offset refractiveIndex;
  final double _relativeExtent;
  final double? relativeExtent;
  final List<Widget> sides; //left top right bottom center

  const Frame(this.child,
      {super.key,
      this.isFront = true,
      this.relativeExtent,
      this.z = .0,
      this.refractiveIndex = const Offset(.5, .2),
      double intensity = .0,
      this.lampColor = Colors.transparent,
      this.scale = .959,
      this.sides = const [
        Placeholder(),
        Placeholder(),
        Placeholder(),
        Placeholder(),
        Placeholder(),
      ]})
      : _intensity = intensity,
        _relativeExtent = relativeExtent ?? z * -2;
  final Alignment _talignment = Alignment.bottomCenter;
  @override
  Widget build(BuildContext context) {
    final bool lights = lampColor != Colors.transparent;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(.0, _relativeExtent / 2)
              ..rotateX(-pi / 2),
            child: Container(
              height: _relativeExtent,
              foregroundDecoration: lights
                  ? BoxDecoration(
                      gradient: RadialGradient(
                          radius: 2.5,
                          colors: [
                            lampColor
                                .withOpacity(refractiveIndex.dx + _intensity),
                            lampColor
                                .withOpacity(refractiveIndex.dy + _intensity)
                          ],
                          transform: const GradientZoom(1.0)))
                  : null,
              child: sides[3],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(.0, _relativeExtent / -2)
              ..rotateX(pi / 2),
            child: Container(
              height: _relativeExtent,
              foregroundDecoration: lights
                  ? BoxDecoration(
                      gradient: RadialGradient(colors: [
                      lampColor.withOpacity(refractiveIndex.dy + _intensity),
                      lampColor.withOpacity(refractiveIndex.dx + _intensity),
                    ], transform: const GradientZoom(.9)))
                  : null,
              child: sides[1],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(.0, .0, _relativeExtent / 2),
            child: Container(
              foregroundDecoration: lights
                  ? BoxDecoration(
                      gradient: RadialGradient(
                          focal: Alignment.topCenter,
                          focalRadius: .5,
                          colors: [
                            lampColor
                                .withOpacity(refractiveIndex.dx + _intensity),
                            lampColor
                                .withOpacity(refractiveIndex.dy + _intensity),
                          ],
                          transform: GradientZoom(.9)))
                  : null,
              child: sides[4],
            ),
          ),
        ),
        ...zOrderByDepth(lights),
      ],
    );
  }

  Iterable<Widget> zOrderByDepth(bool lights) {
    final _ = [
      Align(
        alignment: Alignment.bottomLeft,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(.0, .0, z)
            ..scale(scale),
          child: child,
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Transform(
          alignment: _talignment,
          transform: Matrix4.identity()
            ..translate(
              _relativeExtent / 2,
            )
            ..rotateY(-pi / 2),
          child: Container(
            width: _relativeExtent,
            foregroundDecoration: lights
                ? BoxDecoration(
                    gradient: RadialGradient(
                        focal: Alignment.topCenter,
                        focalRadius: .5,
                        colors: [
                          lampColor
                              .withOpacity(refractiveIndex.dx + _intensity),
                          lampColor
                              .withOpacity(refractiveIndex.dy / 2 + _intensity),
                        ],
                        transform: const GradientZoom(.9)))
                : null,
            child: sides[2],
          ),
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Transform(
          alignment: _talignment,
          transform: Matrix4.identity()
            ..translate(_relativeExtent / -2)
            ..rotateY(-pi / 2),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(pi),
            child: Container(
              width: _relativeExtent,
              foregroundDecoration: lights
                  ? BoxDecoration(
                      gradient: RadialGradient(
                          focal: Alignment.topCenter,
                          focalRadius: .5,
                          colors: [
                            lampColor
                                .withOpacity(refractiveIndex.dx + _intensity),
                            lampColor.withOpacity(
                                refractiveIndex.dy / 2 + _intensity),
                          ],
                          transform: const GradientZoom(.9)))
                  : null,
              child: sides[0],
            ),
          ),
        ),
      ),
    ];

    return isFront ? [_.last,_.first] : [_.last,_.first,_[1]];
  }
}

class GradientZoom extends GradientTransform {
  final double z;
  const GradientZoom(this.z);
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()..scale(1.0, z);
  }
}
