import 'dart:async';

class Bloc {
  StreamController<int> colorTheme = StreamController();

  Stream<int> get results => colorTheme.stream; // 바로 스트림에 접근하지 않기 위해 만들었습니다.

  void dispose() {
    colorTheme.close(); // 스트림은 안 쓸 때 닫아줘야합니다.
  }

  void setColorTheme(int i) {
    colorTheme.add(i);
  }
}
