// factory 생성자를 이용한 싱글턴 패턴 구현
// 클래스의 인스턴스를 단 하나만 생성하는 디자인 패턴

// 예제2. 싱글턴 패턴 구현 예
class Singleton {
  static Singleton? _instance;

  // factory 생성자
  factory Singleton() {
    // 인스턴스가 존재하지 않는다면 ==> 새로운 인스턴스 생성 후 반환
    if (_instance == null) {
      _instance = Singleton._internal();
    }
    return _instance!;
  }

  // private 생성자
  Singleton._internal();
}

void main() {
  var obj1 = Singleton();
  var obj2 = Singleton();

  print(obj1 == obj2); // true
}
