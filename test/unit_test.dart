import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/providers.dart';

class MockCounter extends Mock implements Counter {}

void main() {
  group('counter test', () {
    test('our counter test', () {
      var x = MockCounter();

      // when(() => x.increment()).thenReturn(1);
      x.increment();
      x.increment();

      verify(() => x.increment()).called(2);

  // expect(x.increment(), 1);tititi
    });

    test('our counter 2 test', () {
      var x = CounterTesting();
      x.increment();
      x.increment();

      expect(x.state, 2);
    });
  });
}

class CounterTesting {
  int _state = 0;

  int get state => _state;
  increment() {
    // Counter can use the "ref" to read other providers
    // final repository = ref.read();
    // repository.post('...');
    _state++;
    return _state;
  }
}
