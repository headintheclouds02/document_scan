import 'package:camera/camera.dart';
import 'package:document_scanner_project/presentation/pages/custom/custom_scanner/camera_page.dart';
import 'package:document_scanner_project/presentation/pages/custom/custom_scanner/custom_preview_page.dart';
import 'package:document_scanner_project/presentation/pages/custom/custom_scanner/custom_scanner_page.dart';
import 'package:document_scanner_project/presentation/pages/home_page/home_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/cunning_scanner/cunning_preview_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/cunning_scanner/cunning_saved_scans_page.dart';
import 'package:document_scanner_project/presentation/pages/plugins/cunning_scanner/cunning_scanner_page.dart';
import 'package:go_router/go_router.dart';

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
        builder: (context, state) => CunningSavedScansPage(),
      ),

      GoRoute(
        path: '/customScanner',
        name: '/customScanner',
        builder: (context, state) => CustomScannerPage(cameras: cameras),
      ),

      GoRoute(
        path: '/camera',
        name: '/camera',
        builder: (context, state) => CameraPage(cameras: cameras),
      ),

      GoRoute(
        path: '/previewCustom',
        name: '/previewCustom',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return CustomPreviewPage(
            imagePath: extra['imagePath'],
            onSave: extra['onSave'],
          );
        },
      ),
    ],
  );
}