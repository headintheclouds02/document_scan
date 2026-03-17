import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

class FlutterPreviewPage extends StatefulWidget {
  final String pdfPath;

  const FlutterPreviewPage({super.key, required this.pdfPath});

  @override
  State<FlutterPreviewPage> createState() => _FlutterPreviewPageState();
}

class _FlutterPreviewPageState extends State<FlutterPreviewPage> {
  int pages = 0;
  int currentPage = 0;
  late File sourceFile;

  @override
  void initState() {
    super.initState();

    final path = widget.pdfPath.startsWith("file://")
        ? Uri.parse(widget.pdfPath).toFilePath()
        : widget.pdfPath;

    sourceFile = File(path);
  }

  Future<void> exportPdf() async {
    try {
      final bytes = await sourceFile.readAsBytes();

      await FlutterFileSaver().writeFileAsBytes(
        fileName: "scan_${DateTime.now().millisecondsSinceEpoch}.pdf",
        bytes: bytes,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF saved in device memory")),
      );
    } catch (e) {
      print("Export error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Preview PDF"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),

            onPressed: () {
              context.pop(widget.pdfPath);
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              exportPdf();
              context.pop(widget.pdfPath);
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: sourceFile.path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        onRender: (pagesCount) {
          setState(() {
            pages = pagesCount!;
          });
        },
        onPageChanged: (page, total) {
          setState(() {
            currentPage = page!;
          });
        },
      ),
    );
  }
}
