import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Use [break points] to check the performance of the
/// application
///
void isolateFunction(int finalNum) {
  int count = 0;

  for (int i = 0; i < finalNum; i++) {
    count++;
    if ((count % 100) == 0) {
      debugPrint("isolate: $count");
    }
  }
}

/// Use `break points` to check the performance of the
/// application
///
int computeFunction(int finalNum) {
  int count = 0;

  for (int i = 0; i < finalNum; i++) {
    count++;
    if ((count % 100) == 0) {
      debugPrint("compute: $count");
    }
  }
  return count;
}

class BasicImplementation extends StatefulWidget {
  const BasicImplementation({Key? key}) : super(key: key);

  @override
  State<BasicImplementation> createState() => _BasicImplementationState();
}

class _BasicImplementationState extends State<BasicImplementation> {
  int count = 0;

  @override
  void initState() {
    Isolate.spawn(isolateFunction, 1000); // Isolate in the initState()
    super.initState();
  }

  // compute function
  Future<void> runCompute() async {
    count = await compute(computeFunction, 2000);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Isolates Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Use `break points` to check the performance of the application',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              child: const Text("Normal Addition Loop"),
              onPressed: () async {
                count++;
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: runCompute,
              child: const Text("Isolate Addition Loop"),
            ),
          ],
        ),
      ),
    );
  }
}
