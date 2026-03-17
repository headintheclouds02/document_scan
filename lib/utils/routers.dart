import 'package:camera/camera.dart';
import 'package:document_scanner_project/presentation/pages/home_page/home_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/cunning_scanner/cunning_preview_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/cunning_scanner/cunning_saved_scans_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/cunning_scanner/cunning_scanner_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/flutter_scanner/flutter_scanner_page.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/plugins/flutter_scanner/flutter_preview_page.dart';

class AppRouter {
  final List<CameraDescription> cameras;

  AppRouter({required this.cameras});

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: '/',
        builder: (context, state) => HomePage(),
      ),

      GoRoute(
        path: '/cunningScanner',
        name: '/cunningScanner',
        builder: (context, state) => CunningScannerPage(),
      ),

      GoRoute(
        path: '/cunningPreview',
        name: '/cunningPreview',
        builder: (context, state) {
          final imagePath = state.extra as List<String>;
          return CunningPreviewPage(images: imagePath);
        },
      ),

      GoRoute(
        path: '/cunningSavedScans',
        name: '/cunningSavedScans',
        builder: (context, state) => CunningSavedScansPage()
      ),

      GoRoute(
        path: '/flutterDocScanner',
        name: '/flutterDocScanner',
        builder: (context, state) => FlutterScannerPage(),
      ),

      GoRoute(
        path: '/flutterPreviewPage',
        name: '/flutterPreviewPage',
        builder: (context, state) {
          final pdfPath = state.extra as String;
          return FlutterPreviewPage(pdfPath: pdfPath);
        },
      ),
    ],
  );
}