import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:opencv_canny_test/constants/colors.dart';
import 'package:opencv_canny_test/constants/strings.dart';
import 'package:opencv_canny_test/ui/screens/all_images_screen.dart';
import 'package:opencv_canny_test/ui/widgets/image_placeholder_widget.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opencv_canny_test/constants/toasts.dart' as toasts;

class UploadToStorageScreen extends StatefulWidget {
  const UploadToStorageScreen({Key? key}) : super(key: key);

  @override
  _UploadToStorageScreenState createState() => _UploadToStorageScreenState();
}

class _UploadToStorageScreenState extends State<UploadToStorageScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? _image;
  Uint8List? _byte;

  // Process Image
  processImage({
    required String pathString,
    required CVPathFrom pathFrom,
    required double thresholdValue,
    required double maxThresholdValue,
    required int thresholdType,
  }) async {
    try {
      log('Processing', name: 'inside sobel processing ');

      /// [Sobel]
      _byte = await Cv2.sobel(
        pathFrom: pathFrom,
        pathString: pathString,
        depth: -1, // depth of the image (-1)
        dx: 1, // x-derivative. (0 or 1)
        dy: 0, // y-derivative. (0 or 1)
      );
      _byte != null
          ? await _uploadProcessedImage(_byte!)
          : log('not uploading processed image');
      setState(() {
        _byte;
      });
    } on PlatformException catch (e) {
      log(e.message!);
    }
  }

  // Original Image upload
  Future<void> _uploadOrignalImage(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File _image = File(pickedImage.path);

      processImage(
        pathFrom: CVPathFrom.GALLERY_CAMERA,
        pathString: _image.path,
        thresholdValue: 150,
        maxThresholdValue: 200,
        thresholdType: Cv2.THRESH_BINARY,
      );

      try {
        // Upload
        await _storage.ref(fileName).putFile(
              _image,
              SettableMetadata(
                customMetadata: {
                  'uploaded_at': DateTime.now().toString(),
                  'description': 'original'
                },
              ),
            );

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  // Processed Image Upload
  Future<void> _uploadProcessedImage(Uint8List _byte) async {
    // File _processedImageFile = File.fromRawPath(_byte!); // Uint8List to file conversion
    try {
      // Unique id for each processed image
      String _processedImgID = Uuid().v4();
      log('Processed img uploading', name: 'Inside _uploadProcessedImage ');
      await _storage.ref(_processedImgID).putData(
            _byte,
            SettableMetadata(
              customMetadata: {
                'uploaded_at': DateTime.now().toString(),
                'description': 'processed'
              },
            ),
          );
      // Refresh the UI
      // setState(() {});
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _delete(String ref) async {
    await _storage.ref(ref).delete();
    setState(() {});
  }

  Set<String> st = {};
  // Retrieve uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await _storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();

      // HANDLING DUPLICATE ENTRY INTO Firestore, on refresh
      // if the incoming url is not in the set, put into set, then _addToFireStore
      if (st.contains(fileUrl)) {
        //do nothing
      } else {
        // String _docID = Uuid().v4();
        st.add(fileUrl);
        await _addToFireStore(fileUrl);
      }

      log(fileUrl, name: 'DOWNLOADED URL:');
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_at": fileMeta.customMetadata?['uploaded_at'] ?? ':::',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });
    return files;
  }

  //-------------upload img-urls to cloud firestore--------------------------------
  late Map<String, dynamic> dataToAdd;
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("img-urls");

  Future<void> _addToFireStore(String url) async {
    dataToAdd = {
      'img-urls': url,
      'dateTime': DateTime.now(),
    };
    await collectionRef.add(dataToAdd).whenComplete(
          () => toasts.dataAddedToDatabase(),
        );
    // await collectionRef.doc(docID).set(dataToAdd).whenComplete(
    //       () => toasts.dataAddedToDatabase(),
    // );
  }
  //--------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlotlineColors.kBackgroundColor,
        title: const Text(
          PlotlineStrings.uploadImages,
          style: TextStyle(
            color: PlotlineColors.kPrimaryTextColor,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              // begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                PlotlineColors.kTopGradient,
                PlotlineColors.kBottomGradient,
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: _byte != null
                    ? Image.memory(
                        _byte!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      )
                    : SizedBox(
                        width: 150,
                        height: 150,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          PlotlineColors.kBackgroundColor),
                    ),
                    // style: ElevatedButton.styleFrom(
                    //   primary: PlotlineColors.kBackgroundColor,
                    //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    //   textStyle:
                    //       TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    // ),
                    onPressed: () => _uploadOrignalImage('camera'),
                    icon: const Icon(Icons.camera),
                    label: const Text(PlotlineStrings.pickFromCamera),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          PlotlineColors.kBackgroundColor),
                    ),
                    onPressed: () => _uploadOrignalImage('gallery'),
                    icon: const Icon(Icons.library_add),
                    label: const Text(PlotlineStrings.pickFromGallery),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      PlotlineColors.kBackgroundColor),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AllImagesScreen()),
                ),
                icon: const Icon(Icons.camera),
                label: const Text(PlotlineStrings.allImages),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _loadImages(),
                  builder: (context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (ctx, idx) {
                          final Map<String, dynamic> image =
                              snapshot.data![idx];
                          return ImagePlaceHolderWidget(img: image);
                          // return Card(
                          //   margin: const EdgeInsets.symmetric(vertical: 10),
                          //   child: Column(
                          //     children: [
                          //       ListTile(
                          //         dense: false,
                          //         leading: Image.network(image['url']),
                          //         // title: Text(image['uploaded_at']),
                          //         // title: Text((idx + 1).toString()),
                          //         subtitle: Text(image['description']),
                          //         trailing: IconButton(
                          //           onPressed: () => _delete(image['path']),
                          //           icon: const Icon(
                          //             Icons.delete,
                          //             color: Colors.red,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
