import 'package:document_scanner_project/models/scanned_image.dart';
import 'package:flutter/material.dart';

class CustomPreviewPage extends StatefulWidget {
  final String imagePath;
  final Function(ScannedImage) onSave;

  const CustomPreviewPage({super.key, required this.imagePath, required this.onSave});

  @override
  State<CustomPreviewPage> createState() => _CustomPreviewPageState();
}

class _CustomPreviewPageState extends State<CustomPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
