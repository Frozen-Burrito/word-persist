import 'package:flutter/material.dart';
import 'package:word_persist/src/bloc/counter_model.dart';
import 'package:word_persist/src/widgets/counter_inherited_widget.dart';

void main() {
  runApp(const WordPersistApp());
}

class WordPersistApp extends StatelessWidget {
  const WordPersistApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CounterState(
      counter: CounterModel(),
      child: MaterialApp(
        title: 'Word Persist',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(title: 'Words'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  const HomePage({
    Key? key, 
    required this.title
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            _CountText(),

            _ModifyCounterButton(change: 1, color: Colors.blue,),
            _ModifyCounterButton(change: -1, color: Colors.red,),
          ],
        ),
      ),
    );
  }
}

class _CountText extends StatelessWidget {
  const _CountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final counter = CounterState.of(context).counter;

    return StreamBuilder<int>(
      initialData: 0,
      stream: counter.value,
      builder: (context, snapshot) {

        final value = snapshot.data ?? 0;

        return Text(
          '$value',
          style: Theme.of(context).textTheme.headline4,
        );
      }
    );
  }
}

class _ModifyCounterButton extends StatelessWidget {
  const _ModifyCounterButton({
    Key? key,
    required this.change,
    this.color = Colors.blue,
  }) : super(key: key);

  final int change;
  final Color color;

  @override
  Widget build(BuildContext context) {

    final counter = CounterState.of(context).counter;

    return ElevatedButton.icon(
      onPressed: () {
        counter.incrBtnTapSink.add(change);
      },
      label: Text(change.isNegative ? 'Decrement' : 'Increment'),
      icon: Icon(change.isNegative ? Icons.remove : Icons.add),
      style: ElevatedButton.styleFrom(
        primary: color,
      ),
    );
  }
}
