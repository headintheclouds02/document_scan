import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:go_router/go_router.dart';

class FlutterScannerPage extends StatefulWidget {
  const FlutterScannerPage({super.key});

  @override
  State<FlutterScannerPage> createState() => _FlutterScannerPageState();
}

class _FlutterScannerPageState extends State<FlutterScannerPage> {
  List<String> scannedDocuments = [];

  Future<void> scanDocument() async {
    try {
      final result = await FlutterDocScanner()
          .getScannedDocumentAsPdf(page: 10);


      if (result != null && context.mounted) {
        final savedPdf = await context.push<String>(
          '/flutterPreviewPage',
          extra: result,
        );

        if (savedPdf != null) {
          setState(() {
            scannedDocuments.add(savedPdf);
          });
        }
      }
    } catch (e) {
      print("Scan error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("flutter_doc_scanner_local Page"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Text(''),
          scannedDocuments.isEmpty
              ? const Center(child: Text("No documents scanned"))
              : Expanded(
                child: ListView.builder(
                    itemCount: scannedDocuments.length,
                    itemBuilder: (context, index) {
                      final pdfPath = scannedDocuments[index];
                      return Card(
                        child: ListTile(
                          tileColor: Colors.white,
                          leading: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),
                          title: Text("Document ${index + 1}"),
                          subtitle: Text(pdfPath.split('/').last),
                          onTap: () {
                            context.push('/flutterPreviewPage', extra: pdfPath);
                          },
                        ),
                      );
                    },
                  ),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanDocument,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: Icon(Icons.document_scanner),
      ),
    );
  }
}