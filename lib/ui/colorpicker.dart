import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final double width;
  ColorPicker(this.width);
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> _colors = [
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 128, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 128, 255, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 0, 255, 128),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 128, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 127, 0, 255),
    Color.fromARGB(255, 255, 0, 255),
    Color.fromARGB(255, 255, 0, 127),
    Color.fromARGB(255, 128, 128, 128),
  ];

  double _colorSliderPosition;

  _colorChangeHandler(double position) {
    //handle out of bounds positions
    if (position > widget.width) {
      position = widget.width;
    }
    if (position < 0) {
      position = 0;
    }
    print("New pos: $position");
    setState(() {
      _colorSliderPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (DragStartDetails details) {
              print("_-------------------------STARTED DRAG");
              _colorChangeHandler(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            onTapDown: (TapDownDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            //This outside padding makes it much easier to grab the   slider because the gesture detector has
            // the extra padding to recognize gestures inside of
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                width: widget.width,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(colors: _colors),
                ),
                child: CustomPaint(
                  painter: _SliderIndicatorPainter(_colorSliderPosition),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SliderIndicatorPainter extends CustomPainter {
  final double position;
  _SliderIndicatorPainter(this.position);
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    var path2 = Path();
    var myPaint = Paint();
    var center = Offset(position, size.height / 2);

    myPaint.color = Colors.black;

    path.addOval(Rect.fromCircle(center: center, radius: 20.0));
    path2.addOval(Rect.fromCircle(center: center, radius: 19.0));

    canvas.drawShadow(path, Color(0xff000000), 3, true);
    canvas.drawPath(path2, myPaint);
    //canvas.drawCircle(Offset(position, size.height / 2), 12, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_SliderIndicatorPainter old) {
    return true;
  }
}
