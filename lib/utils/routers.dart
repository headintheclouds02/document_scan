import 'package:document_scanner_project/presentation/pages/home_page/home_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/cunning_scanner/cunning_preview_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/cunning_scanner/cunning_saved_scans_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/cunning_scanner/cunning_scanner_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {

  static final GoRouter router = GoRouter(
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
        builder: (context, state) => CunningSavedScansPage(),
      ),
    ],
  );
}