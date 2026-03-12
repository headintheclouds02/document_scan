import 'package:document_scanner_project/utils/scan_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class CunningSavedScansPage extends StatelessWidget {
  const CunningSavedScansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = ScanStorageService().documents;

    return Scaffold(
      appBar: AppBar(
        title: Text("Le mie scansioni"),
      ),
      body: docs.isEmpty
          ? _buildEmptyState()
          : _buildDocumentsList(docs),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Nessuna scansione salvata',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(List docs) {
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(
              Icons.picture_as_pdf,
              color: Colors.pinkAccent,
              size: 40,
            ),
            title: Text(doc.name, style: TextStyle(fontSize: 14),),
            subtitle: Text("${doc.pages} pagine"),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _openPdf(doc.path),
          ),
        );
      },
    );
  }

  void _openPdf(String path) {
    OpenFilex.open(path);
  }
}