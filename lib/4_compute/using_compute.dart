import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<int> computeFactorial(int n) async {
  return await compute(_factorial, n);
}

int _factorial(int n) {
  return (n == 0) ? 1 : n * _factorial(n - 1);
  // int sum = 0;
  // for (int i = 0; i < n; i++) {
  //   sum += i;
  // }
  // return sum;
}

class UsingCompute extends StatefulWidget {
  const UsingCompute({Key? key}) : super(key: key);

  @override
  State<UsingCompute> createState() => _UsingComputeState();
}

class _UsingComputeState extends State<UsingCompute> {
  int _factorial = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compute')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Factorial: $_factorial',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.lightBlueAccent[100],
              child: const CircularProgressIndicator(color: Colors.red),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () async {
                final result = await computeFactorial(45);

                setState(() {
                  _factorial = result;
                });
              },
              child: const Text(
                'Calculate Factorial',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _factorial = 0;
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
}
