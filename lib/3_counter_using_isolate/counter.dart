import 'dart:isolate';

import 'package:flutter/material.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  final _receivePort = ReceivePort(); // for Isolate.spawn()
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _receivePort.listen((message) {
      _counter = message;
      setState(() {});
    });
  }

  Future<void> _incrementCounter() async {
    await Isolate.spawn(
      _increment,
      [_receivePort.sendPort, _counter],
    );
  }

  static void _increment(List<dynamic> arguments) {
    final SendPort sendPort = arguments.first;
    final int counter = arguments.last;
    sendPort.send(counter + 2);
  }

  @override
  void dispose() {
    _receivePort.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Counter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}