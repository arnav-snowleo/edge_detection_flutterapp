import 'package:flutter/material.dart';
import 'package:opencv_canny_test/constants/colors.dart';
import 'package:opencv_canny_test/home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:opencv_canny_test/ui/ui_theme.dart' as theme;
import 'package:opencv_canny_test/ui/widgets/upload_image_widget.dart';
import 'package:opencv_canny_test/ui/screens/upload_to_storage_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PlotlineApp());
}

class PlotlineApp extends StatelessWidget {
  const PlotlineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edge detection',
      theme: theme.kDarkTheme,
      darkTheme: theme.kDarkTheme,
      // home: const Home(title: 'Edge detection'),
      // home: const UploadImageWidget(),
      home: const UploadToStorageScreen(),
    );
  }
}
