import 'package:document_scanner_project/presentation/pages/home_page/home_page.dart';
import 'package:document_scanner_project/utils/routers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Document scan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
