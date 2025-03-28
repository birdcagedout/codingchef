// 일반(named) 생성자 사용: 항상 새로운 인스턴스를 생성함
class RegularExample {
  final int value;

  RegularExample(this.value);

  // JSON 데이터를 받아 인스턴스를 생성하는 named constructor
  RegularExample.fromJson(Map<String, dynamic> json)
      : this.value = json['key'];
}


// factory 생성자 사용: 캐싱을 통해 같은 값에 대해서는 동일 인스턴스를 반환함
class FactoryExample {
  final int value;

  FactoryExample(this.value);

  // 캐싱을 위한 static 변수
  static final Map<int, FactoryExample> _cache = {};

  // factory 생성자는 로직에 따라 객체를 새로 생성하거나 재사용할 수 있음
  factory FactoryExample.fromJson(Map<String, dynamic> json) {

    int value = json['key'];

    if (_cache.containsKey('key')) {
      // 이미 존재하는 경우 캐싱된 인스턴스를 반환
      return _cache[value]!;
    } else {
      // 없으면 새 인스턴스를 생성하고 캐싱한 후 반환
      final instance = FactoryExample(value);
      _cache[value] = instance;
      return instance;
    }
  }
}

void main() {
  // RegularExample의 경우 같은 JSON이어도 항상 새로운 객체가 생성됨
  var regular1 = RegularExample.fromJson({'key': 10});
  var regular2 = RegularExample.fromJson({'key': 10});
  print('regular1 == regular2: ${regular1 == regular2}'); // 출력: false

  // FactoryExample의 경우 같은 JSON이면 캐싱된 동일 인스턴스가 반환됨
  var factory1 = FactoryExample.fromJson({'key': 10});
  var factory2 = FactoryExample.fromJson({'key': 10});
  print('factory1 == factory2: ${factory1 == factory2}'); // 출력: true
}
