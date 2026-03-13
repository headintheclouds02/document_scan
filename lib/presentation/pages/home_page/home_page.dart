import 'package:document_scanner_project/presentation/components/button/scan_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Scanner Plugins Demo'),
        backgroundColor: Colors.pink.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Questo progetto dimostra diversi plugin Flutter per la scansione di documenti.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ScanButton(
              text: 'Cunning document scanner',
              onPressed: () => context.push("/cunningScanner"),
              color: Colors.pink,
            ),
            SizedBox(height: 20),
            ScanButton(
              text: 'Custom document scanner',
              onPressed: () => context.push("/customScanner"),
              color: Colors.pinkAccent,
            ),
          ],
        ),
      ),
    );
  }
}