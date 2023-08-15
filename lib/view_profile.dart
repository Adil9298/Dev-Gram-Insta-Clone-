import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/profile_models.dart';
import 'package:photo_view/photo_view.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Container(
          child: PhotoView(imageProvider: NetworkImage(profile_models?.profile??'')),
        ),
      );
  }
}
