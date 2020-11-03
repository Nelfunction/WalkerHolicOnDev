import 'package:flutter/material.dart';
import 'bloc.dart';

class Provider extends InheritedWidget {
  final bloc = Bloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Bloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType() as Provider).bloc;

  Provider({Key key, Widget child}) : super(child: child, key: key);
}
