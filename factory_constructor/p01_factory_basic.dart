// factory 생성자
// factory 생성자는 객체를 생성하는 방법을 유연하게 제어할 수 있는 생성자이다.
//
// 1. 객체 생성 시 전처리     : 인스턴스 생성 전 입력값 검증, 전처리 등 필요한 추가 처리를 수행할 수 있습니다.
// 2. *동일한 인스턴스 반환*  : 동일한 입력 값에 대해 동일 인스턴스를 반환하도록 "캐싱" 로직이나 "싱글톤 패턴"을 구현할 수 있습니다. ==> 동일하지 않은 인스턴스 반환도 가능
// 3. 선언 방식 다양화        : named 혹은 unnamed 생성자로 선언할 수 있습니다.
// 4. 생성자 반환 타입 지정   : 생성자가 반환할 객체의 타입을 지정할 수 있습니다. ==> factory 생성자가 선언된 "그 class 타입" 또는 그 class를 상속받은 "하위 class 타입"
//
// 하지만, factory 생성자를 사용하는 가장 큰 이유는 "동일한 인스턴스를 반환"하기 위한 것이다.

// 예제1. 전형적인 factory생성자의 예(캐싱)
class MyClass {
  final String name;
  static final Map<String, MyClass> _cache = <String, MyClass>{};

  // factory 생성자
  factory MyClass(String name) {
    // 캐싱 되어 있다면 ==> 캐싱된 MyClass 타입의 인스턴스 반환
    if (_cache.containsKey(name)) {
      return _cache[name]!;
    }
    // 캐싱되어 있지 않다면 ==> 새로운 MyClass 타입의 인스턴스 생성 후 반환
    else {
      final instance = MyClass._internal(name);
      _cache[name] = instance;
      return instance;
    }
  }

  // private 생성자(실제로 인스턴스 생성하는 부분)
  MyClass._internal(this.name);
}

void main() {
  var obj1 = new MyClass('kim');
  var obj2 = new MyClass('kim');

  print(obj1 == obj2); // true
}
