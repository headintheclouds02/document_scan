import 'package:document_scanner_project/utils/cunning_scanner_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class CunningScannerPage extends StatefulWidget {
  const CunningScannerPage({super.key});

  @override
  State<CunningScannerPage> createState() => _CunningScannerPageState();
}

class _CunningScannerPageState extends State<CunningScannerPage> {
  final CunningScannerService _scannerService = CunningScannerService();

  Future<void> _startScan() async {
    print("SCAN STARTED");

    final status = await Permission.camera.status;
    print("Camera status before request: $status");

    final result = await Permission.camera.request();
    print("Camera status after request: $result");

    if (result.isPermanentlyDenied) {
      openAppSettings();
      return;
    }

    if (!status.isGranted) {
      print("Camera permission denied");
      _showNoScanMessage();
      return;
    }

    final images = await _scannerService.scanDocuments();

    print("SCAN RESULT: $images");

    if (!mounted) return;

    if (images == null || images.isEmpty) {
      _showNoScanMessage();
      return;
    }

    _goToPreview(images);
  }

  void _goToPreview(List<String> images) {
    context.push('/cunningPreview', extra: images);
  }

  void _showNoScanMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nessuna scansione effettuata'),
      ),
    );
  }

  void _openSavedScans() {
    context.push("/cunningSavedScans");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cunning Scanner")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text(
              'Cunning Document Scanner is a Flutter-based document scanner application that enables you to capture images of paper documents and convert them into digital files effortlessly. This application is designed to run on Android and iOS devices with minimum API levels of 21 and 13, respectively.',
            ),
            SizedBox(height: 24,),
            ElevatedButton.icon(
              icon: Icon(Icons.document_scanner),
              label: Text("Start Scan"),
              onPressed: _startScan,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openSavedScans,
        child: Icon(Icons.folder),
      ),
    );
  }
}
