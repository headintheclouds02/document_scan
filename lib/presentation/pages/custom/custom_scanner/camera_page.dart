import 'dart:io';

import 'package:camera/camera.dart';
import 'package:document_scanner_project/models/scanned_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  final List<ScannedImage> capturedImages = [];
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    await _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _captureImage() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });
    try {
      final image = await _controller.takePicture();

      await context.push(
        '/previewCustom',
        extra: {
          'imagePath': image.path,
          'onSave': (scannedImage) {
            setState(() {
              capturedImages.add(scannedImage);
            });
          },
        },
      );
    } catch (e) {
      print('Error capturing image: $e');
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  void _finishScanning() {
    context.pop(capturedImages);
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture (${capturedImages.length}) images'),
        actions: [
          if (capturedImages.isNotEmpty)
            IconButton(onPressed: _finishScanning, icon: Icon(Icons.check)),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller),
          if (capturedImages.isNotEmpty)
            Positioned(
              bottom: 100,
              left: 16,
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width - 32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: capturedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(capturedImages[index].path),
                          fit: BoxFit.cover,
                          width: 60,
                          height: 80,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Positioned(
            bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                 onPressed: _isCapturing ? null : _captureImage,
                  foregroundColor: Colors.white,
                ),
              )
          ),
        ],
      ),
    );
  }
}
