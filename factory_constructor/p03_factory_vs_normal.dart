// factory 생성자와 일반 생성자의 비교
// ** 핵심 **
// 일반 생성자로 인스턴스를 생성하면    ==> 항상 새로운 인스턴스를 생성하지만,
// factory 생성자로 인스턴스를 생성하면 ==> 단 하나의 인스턴스를 생성할 수도, 매번 새로운 인스턴스를 생성할 수도 있다.(유연성)

// 예제3. 일반 생성자와 factory 생성자의 차이

// 일반(named) 생성자 사용: 항상 새로운 인스턴스를 생성함
class RegularExample {
  final int number;
  RegularExample(this.number);
}

// factory 생성자 사용: 캐싱을 통해 같은 값에 대해서는 동일 인스턴스를 반환함
class AppCache {
  final int number;

  // 실제 인스턴스 생성을 담당하는 private 네임드 생성자(리턴타입이 없으므로 생성자임)
  AppCache._(this.number);

  // 캐싱을 위한 Map
  static final Map<int, AppCache> _cache = {};

  // factory 생성자: 캐싱 로직 구현
  factory AppCache(int number) {
    // 캐시에 있으면 재사용
    if (_cache.containsKey(number)) {
      return _cache[number]!;
    }
    // 없으면 새 인스턴스를 생성하고 캐시에 저장 후 반환
    else {
      final instance = AppCache._(number);
      _cache[number] = instance;
      return instance;
    }
  }
}

void main() {
  // RegularExample의 경우: 같은 값(5)이어도 매번 새로운 인스턴스가 생성됨
  var regular1 = RegularExample(5);
  var regular2 = RegularExample(5);
  print('RegularExample: regular1 == regular2? ${regular1 == regular2}'); // false

  // AppCache의 경우: 같은 값(5)이면 동일 인스턴스가 재사용됨
  var cached1 = AppCache(5);
  var cached2 = AppCache(5);
  print('AppCache: cached1 == cached2? ${cached1 == cached2}'); // true
}
