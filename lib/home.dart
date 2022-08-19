// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:opencv_4/factory/pathfrom.dart';
// import 'package:opencv_4/opencv_4.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:opencv_canny_test/constants/strings.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key, this.title}) : super(key: key);
//   final String? title;

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   File? _image;
//   Uint8List? _byte;
//   bool _visible = false;
//   final picker = ImagePicker();

//   // TODO: uncomment initstate and dispose if needed
//   // @override
//   // void initState() {
//   //   super.initState();
//   // }

//   // @override
//   // void dispose() {
//   //   super.dispose();
//   // }

//   processImage({
//     required String pathString,
//     required CVPathFrom pathFrom,
//     required double thresholdValue,
//     required double maxThresholdValue,
//     required int thresholdType,
//   }) async {
//     try {
//       // testing with Sobel
//       _byte = await Cv2.sobel(
//         pathFrom: pathFrom,
//         pathString: pathString,
//         depth: -1,   // depth of the image (-1)
//         dx: 1,       // x-derivative. (0 or 1)
//         dy: 0,       // y-derivative. (0 or 1)
//       );
//       setState(() {
//         _byte;
//         _visible = false;
//       });
//     } on PlatformException catch (e) {
//       log(e.message!);
//     }
//   }

//   // _testFromAssets() async {
//   //   processImage(
//   //     pathFrom: CVPathFrom.ASSETS,
//   //     pathString: 'assets/Test.JPG',
//   //     thresholdValue: 150,
//   //     maxThresholdValue: 200,
//   //     thresholdType: Cv2.THRESH_BINARY,
//   //   );
//   //   setState(() {
//   //     _visible = true;
//   //   });
//   // }

//   // _testFromUrl() async {
//   //   processImage(
//   //     pathFrom: CVPathFrom.URL,
//   //     pathString:
//   //         'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/16fe9f114930481.6044f05fca574.jpeg',
//   //     thresholdValue: 150,
//   //     maxThresholdValue: 200,
//   //     thresholdType: Cv2.THRESH_BINARY,
//   //   );
//   //   setState(() {
//   //     _visible = true;
//   //   });
//   // }

//   _testFromCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     _image = File(pickedFile!.path);
//     processImage(
//       pathFrom: CVPathFrom.GALLERY_CAMERA,
//       pathString: _image!.path,
//       thresholdValue: 150,
//       maxThresholdValue: 200,
//       thresholdType: Cv2.THRESH_BINARY,
//     );

//     setState(() {
//       _visible = true;
//     });
//   }

//   _testFromGallery() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     _image = File(pickedFile!.path);
//     processImage(
//       pathFrom: CVPathFrom.GALLERY_CAMERA,
//       pathString: _image!.path,
//       thresholdValue: 150,
//       maxThresholdValue: 200,
//       thresholdType: Cv2.THRESH_BINARY,
//     );

//     setState(() {
//       _visible = true;
//     });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title!),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//                 margin: const EdgeInsets.only(top: 20),
//                 child: Center(
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.only(top: 5),
//                         child: _byte != null
//                             ? Image.memory(
//                                 _byte!,
//                                 width: 300,
//                                 height: 300,
//                                 fit: BoxFit.fill,
//                               )
//                             : SizedBox(
//                                 width: 300,
//                                 height: 300,
//                                 child: Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                       ),
//                       Visibility(
//                         maintainAnimation: true,
//                         maintainState: true,
//                         visible: _visible,
//                         child: const CircularProgressIndicator(),
//                       ),
//                       // SizedBox(
//                       //   width: MediaQuery.of(context).size.width - 40,
//                       //   child: TextButton(
//                       //     child: const Text(PlotlineStrings.pickFromAssets),
//                       //     onPressed: _testFromAssets,
//                       //     style: TextButton.styleFrom(
//                       //       primary: Colors.white,
//                       //       backgroundColor: Colors.teal,
//                       //       onSurface: Colors.grey,
//                       //     ),
//                       //   ),
//                       // ),
//                       // SizedBox(
//                       //   width: MediaQuery.of(context).size.width - 40,
//                       //   child: TextButton(
//                       //     child: const Text(PlotlineStrings.pickFromURL),
//                       //     onPressed: _testFromUrl,
//                       //     style: TextButton.styleFrom(
//                       //       primary: Colors.white,
//                       //       backgroundColor: Colors.teal,
//                       //       onSurface: Colors.grey,
//                       //     ),
//                       //   ),
//                       // ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.60,
//                         child: TextButton(
//                           child: const Text(PlotlineStrings.pickFromGallery),
//                           onPressed: _testFromGallery,
//                           style: TextButton.styleFrom(
//                             primary: Colors.white,
//                             backgroundColor: Colors.teal,
//                             onSurface: Colors.grey,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.60,
//                         child: TextButton(
//                           child: const Text(PlotlineStrings.pickFromCamera),
//                           onPressed: _testFromCamera,
//                           style: TextButton.styleFrom(
//                             primary: Colors.white,
//                             backgroundColor: Colors.teal,
//                             onSurface: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
