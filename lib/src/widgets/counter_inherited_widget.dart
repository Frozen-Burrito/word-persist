import 'package:flutter/material.dart';
import 'package:word_persist/src/bloc/counter_model.dart';

class CounterState extends InheritedWidget {

  const CounterState({
    Key? key,
    required this.counter,
    required Widget child,
  }) : super(key: key, child: child);

  final CounterModel counter;

  static CounterState of(BuildContext context) {
    final CounterState? result = context.dependOnInheritedWidgetOfExactType<CounterState>();
    assert(result != null, 'A Counter widget was not found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) 
    => oldWidget is CounterState && counter != oldWidget.counter;
}