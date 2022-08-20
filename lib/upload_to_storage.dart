import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:uuid/uuid.dart';

class UploadToStorage extends StatefulWidget {
  const UploadToStorage({Key? key}) : super(key: key);

  @override
  _UploadToStorageState createState() => _UploadToStorageState();
}

class _UploadToStorageState extends State<UploadToStorage> {
  FirebaseStorage storage = FirebaseStorage.instance;

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
      _byte != null ? await _uploadProcessedImage(_byte!) : log('not uploading processed image');
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
        await storage.ref(fileName).putFile(
              _image,
              SettableMetadata(
                customMetadata: {
                  'uploaded_at': DateTime.now().toString(),
                  'description': 'original image..'
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
      await storage.ref(_processedImgID).putData(
            _byte,
            SettableMetadata(
              customMetadata: {
                'uploaded_at': DateTime.now().toString(),
                'description': 'processed image'
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

  // Retrieve uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      log(fileUrl, name: 'DOWNLOADED URL:');

      //PROCESS FROM url
      // processImage(
      //   pathFrom: CVPathFrom.URL,
      //   pathString: fileUrl,
      //   thresholdValue: 150,
      //   maxThresholdValue: 200,
      //   thresholdType: Cv2.THRESH_BINARY,
      // );

      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('upload screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: _byte != null
                  ? Image.memory(
                      _byte!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    )
                  : SizedBox(
                      width: 300,
                      height: 300,
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
                    onPressed: () => _uploadOrignalImage('camera'),
                    icon: const Icon(Icons.camera),
                    label: const Text('camera')),
                ElevatedButton.icon(
                    onPressed: () => _uploadOrignalImage('gallery'),
                    icon: const Icon(Icons.library_add),
                    label: const Text('Gallery')),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                            snapshot.data![index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            dense: false,
                            leading: Image.network(image['url']),
                            title: Text(image['uploaded_by']),
                            subtitle: Text(image['description']),
                            trailing: IconButton(
                              onPressed: () => _delete(image['path']),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
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
    );
  }
}
