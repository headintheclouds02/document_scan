import 'dart:io';

import 'package:camera/camera.dart';
import 'package:document_scanner_project/models/scanned_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class CustomScannerPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CustomScannerPage({super.key, required this.cameras});

  @override
  State<CustomScannerPage> createState() => _CustomScannerPageState();
}

class _CustomScannerPageState extends State<CustomScannerPage> {
  final List<ScannedImage> _scannedImages = [];

  void _navigateToCamera() async {
    final result = await context.push('/camera');
    if (result != null && result is List<ScannedImage>) {
      setState(() {
        _scannedImages.addAll(result);
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _scannedImages.removeAt(index);
    });
  }

  Future<void> _createPdf() async {
    if (_scannedImages.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No images to create pdf')));
      return;
    }

    final pdf = pw.Document();
    for (final scannedImage in _scannedImages) {
      final image = pw.MemoryImage(File(scannedImage.path).readAsBytesSync());

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image));
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/scanned_images.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'Scanned document!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera PDF Scanner'),
        actions: [
          IconButton(onPressed: _createPdf, icon: Icon(Icons.picture_as_pdf)),
        ],
      ),
      body: _scannedImages.isEmpty
          ? Center(
              child: Text(
                'No scanned document yet \nTap + to start scanning',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _scannedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Image.file(
                        File(_scannedImages[index].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteImage(index),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _scannedImages[index].isFiltered
                              ? 'Filtered'
                              : 'Original',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: _navigateToCamera,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
