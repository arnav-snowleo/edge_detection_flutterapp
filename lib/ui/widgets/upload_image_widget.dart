// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:opencv_canny_test/constants/strings.dart';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class UploadImageWidget extends StatefulWidget {
//   const UploadImageWidget({Key? key}) : super(key: key);

//   @override
//   _UploadImageWidgetState createState() => _UploadImageWidgetState();
// }

// class _UploadImageWidgetState extends State<UploadImageWidget> {
//   String? imageUrl;

//   uploadImage() async {
//     // final _firebaseStorage = FirebaseStorage.instance;
//     final _imagePicker = ImagePicker();
//     PickedFile image;

//     //Check Permissions
//     await Permission.photos.request();
//     var permissionStatus = await Permission.photos.status;

//     if (permissionStatus.isGranted) {
//       //Select Image
//       image = (await _imagePicker.pickImage(source: ImageSource.gallery))!
//           as PickedFile;
//       var file = File(image.path);

//       if (image != null) {
//         //Upload Image to Firebase

//         FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
//         Reference ref = _firebaseStorage.ref().child("image1" + DateTime.now().toString());
//         UploadTask uploadTask = ref.putFile(file);

//         uploadTask.then((res) {
//           setState(() {
//             imageUrl = res.ref.getDownloadURL() as String;
//           });
//         });

//         // var snapshot = await _firebaseStorage
//         //     .ref()
//         //     .child('images/imageName')
//         //     .putFile(file)
//         //     .onComplete;
//         // var downloadUrl = await snapshot.ref.getDownloadURL();
//         // setState(() {
//         //   imageUrl = downloadUrl;
//         // });
//       } else {
//         log('No Image Path Received');
//       }
//     } else {
//       log('Permission not granted. Try Again with permission access');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           PlotlineStrings.uploadOriginalImage,
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0.0,
//         backgroundColor: Colors.white,
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Column(
//           children: <Widget>[
//             Container(
//                 margin: const EdgeInsets.all(15),
//                 padding: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.all(
//                     Radius.circular(15),
//                   ),
//                   border: Border.all(color: Colors.white),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       offset: Offset(2, 2),
//                       spreadRadius: 2,
//                       blurRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: (imageUrl != Null)
//                     ? Image.network(imageUrl!)
//                     : Image.network('https://i.imgur.com/sUFH1Aq.png')),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // class ImagePlaceholderWidget extends StatelessWidget {
// //   const ImagePlaceholderWidget({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     String imageUrl = 'n';
// //     return Container(
// //       color: Colors.white,
// //       child: Column(
// //         children: <Widget>[
// //           Container(
// //               margin: const EdgeInsets.all(15),
// //               padding: const EdgeInsets.all(15),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: const BorderRadius.all(
// //                   Radius.circular(15),
// //                 ),
// //                 border: Border.all(color: Colors.white),
// //                 boxShadow: const [
// //                   BoxShadow(
// //                     color: Colors.black12,
// //                     offset: Offset(2, 2),
// //                     spreadRadius: 2,
// //                     blurRadius: 1,
// //                   ),
// //                 ],
// //               ),
// //               child: (imageUrl != Null)
// //                   ? Image.network(imageUrl)
// //                   : Image.network('https://i.imgur.com/sUFH1Aq.png')),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class UploadImageButton extends StatefulWidget {
// //   const UploadImageButton({Key? key}) : super(key: key);

// //   @override
// //   State<UploadImageButton> createState() => _UploadImageButtonState();
// // }

// // class _UploadImageButtonState extends State<UploadImageButton> {
// //   uploadImage() async {
// //     final _firebaseStorage = FirebaseStorage.instance;
// //     final _imagePicker = ImagePicker();
// //     PickedFile image;
// //     //Check Permissions
// //     await Permission.photos.request();

// //     var permissionStatus = await Permission.photos.status;

// //     if (permissionStatus.isGranted) {
// //       //Select Image
// //       image = await _imagePicker.getImage(source: ImageSource.gallery);
// //       var file = File(image.path);

// //       if (image != null) {
// //         //Upload to Firebase
// //         var snapshot = await _firebaseStorage
// //             .ref()
// //             .child('images/imageName')
// //             .putFile(file)
// //             .onComplete;
// //         var downloadUrl = await snapshot.ref.getDownloadURL();
// //         setState(() {
// //           imageUrl = downloadUrl;
// //         });
// //       } else {
// //         print('No Image Path Received');
// //       }
// //     } else {
// //       print('Permission not granted. Try Again with permission access');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return RaisedButton(
// //       child: Text("Upload Image",
// //           style: TextStyle(
// //               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
// //       onPressed: () {},
// //       shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(18.0),
// //           side: BorderSide(color: Colors.blue)),
// //       elevation: 5.0,
// //       color: Colors.blue,
// //       textColor: Colors.white,
// //       padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
// //       splashColor: Colors.grey,
// //     );
// //   }
// // }
