import 'package:flutter/material.dart';
import 'bloc.dart';

/*
class Provider extends InheritedWidget {
  final bloc = Bloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Bloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType() as Provider).bloc;

  Provider({Key key, Widget child}) : super(child: child, key: key);
}
*/
class Property with ChangeNotifier {
  List<bool> _visualize;

  Property(this._visualize);

  List<bool> get visualize => _visualize;

  void setVisualize(int n) {
    _visualize[n] = !_visualize[n];
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }
}
