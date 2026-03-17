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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Document Scanner Plugins Demo'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Text(
              'This project shows two open source plugins, cunning_document_scanner and flutter_doc_scanner_local, which has similar behaviour',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),

            Text('Try cunning_document_scanner here'),
            ScanButton(
              text: 'Cunning document scanner',
              onPressed: () => context.push("/cunningScanner"),
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text('Try flutter_doc_scanner_local here'),
            ScanButton(
              text: 'flutter doc scanner',
              onPressed: () => context.push("/flutterDocScanner"),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}