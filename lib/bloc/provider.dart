import 'package:flutter/material.dart';

class Property extends ChangeNotifier {
  int _presetNum;
  List<bool> _visualize;
  Color _textColor;

  //randombox
  int _number;

  Property(
    this._presetNum,
    this._visualize,
    this._textColor,
    this._number,
  );

  void minusNumber() {
    _number--;
    notifyListeners();
  }

  void plusNumber() {
    _number++;
    notifyListeners();
  }

  int get number => _number;
  int get presetNum => _presetNum;
  Color get textColor => _textColor;
  List<bool> get visualize => _visualize;

  void setVisualize(int n) {
    _visualize[n] = !_visualize[n];
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }

  void setPreset(int n) {
    _presetNum = n;
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }

  void setColor(Color color) {
    _textColor = color;
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }
}
