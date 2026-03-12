import '../models/scan_document.dart';

/// Service singleton che gestisce l'archivio dei documenti scansionati.
/// Mantiene in memoria una lista di ScanDocument accessibile da tutta l'app.
/// Utilizza il pattern Singleton per garantire un'unica istanza condivisa.
///
/// Attualmente i documenti sono salvati solo in memoria (non persistenti):
/// se l'app viene chiusa la lista viene persa.

class ScanStorageService {
  static final ScanStorageService _instance = ScanStorageService._internal();

  factory ScanStorageService() {
    return _instance;
  }

  ScanStorageService._internal();
  final List<ScanDocument> _documents = [];
  List<ScanDocument> get documents => _documents;
  void addDocument(ScanDocument doc) {
    _documents.add(doc);
  }
}