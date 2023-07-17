import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

class MyBasicIsolateExample extends StatefulWidget {
  const MyBasicIsolateExample({Key? key}) : super(key: key);

  @override
  State<MyBasicIsolateExample> createState() => _MyBasicIsolateExampleState();
}

class _MyBasicIsolateExampleState extends State<MyBasicIsolateExample> {
  int _sum = 0;
  bool _isMultithreadingOn = false;
  final TextStyle _textStyle = const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolate Example 2')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isMultithreadingOn
                      ? Text('Multithreading: ON', style: _textStyle)
                      : Text('Multithreading: OFF', style: _textStyle),
                  Switch.adaptive(
                    value: _isMultithreadingOn,
                    onChanged: (newValue) {
                      setState(() {
                        _isMultithreadingOn = newValue;
                      });
                      log('isMultithreadingOn: $_isMultithreadingOn');
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text('Sum: $_sum', style: _textStyle),
            const SizedBox(height: 100),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.lightBlueAccent[100],
              child: const CircularProgressIndicator(color: Colors.red),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () async {
                if (_isMultithreadingOn) {
                  final receivePort = ReceivePort(); // for Isolate.spawn()

                  try {
                    await Isolate.spawn(
                      heavyTaskUsingIsolate,
                      receivePort.sendPort,
                    );
                  } catch (e) {
                    log('Error: $e');
                  }

                  receivePort.listen((calculatedSum) {
                    setState(() {
                      _sum = calculatedSum;
                    });
                    print(calculatedSum);
                  });
                } else {
                  setState(() {
                    _sum = heavyTaskWithoutIsolate(1000000000);
                  });
                  print(_sum);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const StadiumBorder(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Calculate',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _sum = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                '↺ Reset',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// this [heavyTaskWithoutIsolate] function will pause
  /// the Circular progress indicator
  ///
  int heavyTaskWithoutIsolate(int value) {
    debugPrint('task started.. 😴');
    int sum = 0;
    for (int i = 0; i < value; i++) {
      sum += i;
    }
    debugPrint('task finished.. 😄');
    return sum;
  }
}

/// this method is outside from the main() thread
/// and will be using: [Isolate.spawn()]
///
heavyTaskUsingIsolate(SendPort sendPort) {
  debugPrint('task started.. 😴');
  int sum = 0;
  for (int i = 0; i < 1000000000; i++) {
    sum += i;
  }
  debugPrint('task finished.. 😄');
  sendPort.send(sum);
}
