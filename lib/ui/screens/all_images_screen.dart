import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opencv_canny_test/constants/colors.dart';
import 'package:opencv_canny_test/constants/strings.dart';

class AllImagesScreen extends StatefulWidget {
  const AllImagesScreen({Key? key}) : super(key: key);

  @override
  State<AllImagesScreen> createState() => _AllImagesScreenState();
}

class _AllImagesScreenState extends State<AllImagesScreen> {
  Query ref = FirebaseFirestore.instance
      .collection('img-urls')
      .orderBy('dateTime', descending: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: PlotlineColors.kTransparentColor,
              // color: Colors.white,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                color: PlotlineColors.kMenuBarColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      PlotlineStrings.allImages,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: StreamBuilder(
                  stream: ref.snapshots(),
                  builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (ctx, idx) {
                          var doc = snapshot.data?.docs[idx];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(ctx).size.width * 0.95,
                                height: 320,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    // Text(doc!['dateTime'].toString()),
                                    SizedBox(
                                      width: 200,
                                      height: 300,
                                      child: Image.network(doc!['img-urls']),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Text(PlotlineStrings.noData);
                    }
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
