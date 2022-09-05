import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/providers.dart';

class MockCounter extends Mock implements Counter {}

class ApiCallTester extends Mock implements PageNotifier {}

class CounterTestMock extends Mock implements CounterTesting {}

void main() {
  group('counter test', () {
    test('our counter test', () {
      var x = MockCounter();

      when(() => x.increment()).thenReturn(1);

      // verify(() => x.increment()).called(2);

      expect(x.increment(), 1);
    });

    test('our personal counter test', () {
      var x = CounterTestMock();

      when(() => x.increment()).thenReturn(10);

      x.increment();

      // verify(() => x.increment()).called(2);

      expect(x.increment(), 0);
    });

    test('our Api Call test', () {
      var x = ApiCallTester();

      when(() => x.rateMovie(id: '2', rating: 2))
          .thenAnswer((_) => Future.delayed(Duration(seconds: 2)));

      // verify(() => x.increment()).called(2);

      expect(x.rateMovie(rating: 3, id: '2'), isA<Future>());
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
    _state = _state * 5;

    return _state;
  }
}
