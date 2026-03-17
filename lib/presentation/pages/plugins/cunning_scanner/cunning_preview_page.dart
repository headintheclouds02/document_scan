import 'dart:io';
import 'dart:typed_data';

import 'package:document_scanner_project/models/scan_document.dart';
import 'package:document_scanner_project/utils/scan_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class CunningPreviewPage extends StatefulWidget {
  final List<String> images;

  const CunningPreviewPage({
    super.key,
    required this.images,
  });

  @override
  State<CunningPreviewPage> createState() => _CunningPreviewPageState();
}

class _CunningPreviewPageState extends State<CunningPreviewPage> {

  Future<Uint8List> _generatePdfBytes() async {
    final pdf = pw.Document();

    for (final imgPath in widget.images) {
      final image = pw.MemoryImage(
        await File(imgPath).readAsBytes(),
      );

      pdf.addPage(
        pw.Page(
          build: (_) => pw.Center(
            child: pw.Image(image, fit: pw.BoxFit.contain),
          ),
        ),
      );
    }
    return pdf.save();
  }

  Future<void> _exportPdf() async {
    final bytes = await _generatePdfBytes();

    await FlutterFileSaver().writeFileAsBytes(
      fileName: "scan_${DateTime.now().millisecondsSinceEpoch}.pdf",
      bytes: bytes,
    );
    if (!mounted) return;
  }

  Future<void> _saveInAppScans() async {
    final bytes = await _generatePdfBytes();
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      "${dir.path}/scan_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(bytes);
    final doc = ScanDocument(
      name: file.path.split("/").last,
      path: file.path,
      createdAt: DateTime.now(),
      pages: widget.images.length,
    );
    ScanStorageService().addDocument(doc);
    if (!mounted) return;
    _showMessage('Documento salvato nelle scansioni');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildPreviewList() {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FractionallySizedBox(
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(widget.images[index]),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomButtons() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _exportPdf,
                icon: Icon(Icons.download),
                label: Text('Save PDf in device memory'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                    foregroundColor: Colors.white
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _saveInAppScans,
                icon: Icon(Icons.folder),
                label: Text('Save in scans'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("cunning_document_scanner Preview"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildPreviewList(),
          SizedBox(height: 20),
          Text(
            "${widget.images.length} pages",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }
}