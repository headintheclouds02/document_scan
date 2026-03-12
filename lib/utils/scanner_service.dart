import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class CunningScannerService {
  Future<List<String>?> scanDocuments() async {
    try {
      final images = await CunningDocumentScanner.getPictures(
        isGalleryImportAllowed: true,
        iosScannerOptions: IosScannerOptions(
          imageFormat: IosImageFormat.jpg,
          jpgCompressionQuality: 0.5,
        ),
      );
      return images;
    } catch (e) {
      return null;
    }
  }
}