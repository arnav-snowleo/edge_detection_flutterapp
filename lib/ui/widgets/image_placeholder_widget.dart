import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:opencv_canny_test/constants/colors.dart';

class ImagePlaceHolderWidget extends StatefulWidget {
  const ImagePlaceHolderWidget({Key? key, required this.img}) : super(key: key);
  final Map<String, dynamic> img;

  @override
  State<ImagePlaceHolderWidget> createState() => _ImagePlaceHolderWidgetState();
}

class _ImagePlaceHolderWidgetState extends State<ImagePlaceHolderWidget> {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _delete(String ref) async {
    await _storage.ref(ref).delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: PlotlineColors.kSecondaryTextColor,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 150,
      width: MediaQuery.of(context).size.width * 0.40,
      child: Column(
        children: [
          Text(widget.img['description']),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Image.network(widget.img['url']),
          ),
          IconButton(
            onPressed: () => _delete(widget.img['path']),
            icon: const Icon(
              Icons.delete,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

                        // return Card(
                        //   margin: const EdgeInsets.symmetric(vertical: 10),
                        //   child: ListTile(
                        //     dense: false,
                        //     leading: Image.network(image['url']),
                        //     title: Text(image['uploaded_at']),
                        //     subtitle: Text(image['description']),
                        //     trailing: IconButton(
                        //       onPressed: () => _delete(image['path']),
                        //       icon: const Icon(
                        //         Icons.delete,
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ),
                        // );