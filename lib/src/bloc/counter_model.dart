import 'dart:async';

class CounterModel {

  int _value = initialValue;
  bool _isClosed = false;

  Stream<int> get value => _countController.stream;
  bool get isClosed => _isClosed;

  static const int initialValue = 0;

  Sink<int> get incrBtnTapSink => _incrBtnTapController.sink;
  Sink<int> get decrBtnTapSink => _decrBtnTapController.sink;

  final StreamController<int> _countController = StreamController.broadcast();
  final StreamController<int> _incrBtnTapController = StreamController();
  final StreamController<int> _decrBtnTapController = StreamController();

  CounterModel() {
    _countController.onListen = () {
      _countController.add(_value);
    };

    _incrBtnTapController.stream.listen((amount) {
      _increment(amount);
    });

    _decrBtnTapController.stream.listen((amount) {
      _decrement(amount);
    });
  }

  void dispose() {
    _isClosed = true;
    _incrBtnTapController.close();
    _decrBtnTapController.close();
    _countController.close();
  }
  
  void _increment([int value = 1]) {
    _value += value;
    _countController.add(_value);
  }

  void _decrement([int amount = 1]) {
    _value -= amount;
    _countController.add(_value);
  }

  @override
  bool operator==(Object other) {

    if (other is! CounterModel) return false;

    final areCountsEqual = _value == other._value;
    final areCountControllersEqual = _countController == other._countController;
    final areTapControllersEqual = _incrBtnTapController == other._incrBtnTapController 
      && _decrBtnTapController == other._decrBtnTapController;

    return areCountsEqual && areCountControllersEqual && areTapControllersEqual;
  }

  @override
  int get hashCode => Object.hashAll([ 
    _value, 
    _countController,
    _incrBtnTapController,
    _decrBtnTapController
  ]); 
}