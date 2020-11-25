import 'package:flutter/material.dart';
import 'bloc.dart';
import '../logic/format.dart';

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
class Property extends ChangeNotifier {
  bool _presetUsed;
  int _presetNum;
  ColorTheme _colortheme;
  List<bool> _visualize;

  Property(
    this._presetUsed,
    this._presetNum,
    this._visualize,
    this._colortheme,
  );

  bool get presentUsed => _presetUsed;
  int get presetNum => _presetNum;
  ColorTheme get colortheme => _colortheme;
  List<bool> get visualize => _visualize;

  void setVisualize(int n) {
    _visualize[n] = !_visualize[n];
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }

  void setPreset(int n) {
    _presetUsed = true;
    _presetNum = n;
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }

  void setColor(ColorTheme n) {
    _presetUsed = true;
    _colortheme = n;
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }
}
