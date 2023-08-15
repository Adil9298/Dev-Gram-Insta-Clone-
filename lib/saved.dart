import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/profile_models.dart';

import 'auth_controller.dart';
import 'firebase_cons.dart';
import 'login.dart';

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Saved'),
      ),
      body: Container(
        // width: width,
        // height: height*0.329,
        color: Colors.black,
        child: GridView.builder(
              itemCount: profile_models?.saved.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: width*0.4,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1
              ), itemBuilder: (context, index) {
                var postId=profile_models?.saved[index];
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collectionGroup(Constants.myposts).where('postId',isEqualTo: postId).snapshots().map((event) => event.docs.map((e) => PostModels.fromJson(e.data())).toList()),
                builder: (context, snapshot) {
                  List<PostModels>? data=snapshot.data;
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,),
                    child: Image(image: CachedNetworkImageProvider(data?[0].post.toString()??'')),
                  );
                }
              );
            },)
      ),
    );
  }
}
