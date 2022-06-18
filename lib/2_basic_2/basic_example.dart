import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

class MyBasicIsolateExample extends StatefulWidget {
  const MyBasicIsolateExample({Key? key}) : super(key: key);

  @override
  State<MyBasicIsolateExample> createState() => _MyBasicIsolateExampleState();
}

class _MyBasicIsolateExampleState extends State<MyBasicIsolateExample> {
  int sum = 0;
  final TextStyle _textStyle = const TextStyle(
    fontSize: 35,
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
            Text('Sum: $sum', style: _textStyle),
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent[100],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const CircularProgressIndicator(color: Colors.red),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sum = heavyTaskWithoutIsolate(1000000000);
                    });
                    print(sum);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Without\nIsolate',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
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
                        sum = calculatedSum;
                      });
                      print(calculatedSum);
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Using\nIsolate',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  sum = 0;
                });
              },
              child: const Text(
                'Reset',
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

/// this method is outside from the main() function
/// and will be used by: [Isolate.spawn()]
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
