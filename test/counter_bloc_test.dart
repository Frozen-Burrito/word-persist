import 'package:flutter_test/flutter_test.dart';
import 'package:word_persist/src/bloc/counter_model.dart';

void main() {
  group('Counter bloc model tests', () {

    late CounterModel counterBloc;

    setUp(() {
      counterBloc = CounterModel();
    });

    tearDown(() {
      counterBloc.dispose();
    });

    test('counterBloc.value is initialized with CounterModel.initialValue', () {
      // Arrange
      const int expected = CounterModel.initialValue;

      // Act
      counterBloc.value.listen((event) { });

      // Assert
      expectLater(counterBloc.value, emits(expected));
    });

    test('Adding 1 to counterBloc.incrBtnTapSink emits a 1 in counterBloc.value', () {
      // Arrange
      const int expected = 1;
      const int increment = 1;

      // Act
      counterBloc.value.listen((event) { });
      counterBloc.incrBtnTapSink.add(increment);

      // Assert
      expectLater(counterBloc.value, emits(expected));
    });

    test('Adding 1 to counterBloc.decrBtnTapSink emits a -1 in counterBloc.value', () {
      // Arrange
      const int expected = -1;
      const int increment = 1;

      // Act
      counterBloc.value.listen((event) { });
      counterBloc.decrBtnTapSink.add(increment);

      // Assert
      expectLater(counterBloc.value, emits(expected));
    });

    test('Adding [1, 3, 4, 5] to the increment sink emits [1, 4, 8, 13] as values for the count, in order', () {
      // Arrange
      const List<int> increments = [1, 3, 4, 5];
      const List<int> expectedValues = [1, 4, 8, 13];

      // Act
      counterBloc.value.listen((event) { });
      for (int value in increments) {
        counterBloc.incrBtnTapSink.add(value);
      }

      // Assert
      expectLater(counterBloc.value, emitsInOrder(expectedValues));
    });
  });
}