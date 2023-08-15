import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/botNav.dart';
import 'package:new_project/login.dart';
import 'package:new_project/myProfile.dart';
import 'package:new_project/profile_models.dart';

import 'firebase_cons.dart';

var postId;

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  AuthController _auth=AuthController();

  File? _pickedMedia;
  String? _mediaUrl;
  var downloadURL;
  Future<void> _pickMedia(ImageSource media) async {
    final pickedFile = await ImagePicker().pickImage(source: media,imageQuality: 50);/*pickVideo(source: ImageSource.gallery);*/
    // For images, use pickImage(source: ImageSource.gallery)

    if (pickedFile != null) {
      setState(() {
        _pickedMedia = File(pickedFile.path);
      });
    }
  }
  Future<void> _uploadMediaToFirebase() async {
    try {
      if (_pickedMedia == null) {
        print("Please pick an image or video first.");
        return;
      }

      // Upload the media file to Firebase Storage
      final TaskSnapshot uploadTaskSnapshot = await FirebaseStorage.instance
          .ref('post/${DateTime.now().millisecondsSinceEpoch}.jpg') // For images, replace '.mp4' with the appropriate file extension like '.jpg'
          .putFile(_pickedMedia as File);

      // Wait for the upload to complete and retrieve the download URL
      downloadURL = await uploadTaskSnapshot.ref.getDownloadURL();


      // profile_models = (await _auth.getUser(FirebaseAuth.instance.currentUser!.uid));
      var mydata=PostModels(post: downloadURL, uploadTime: Timestamp.now(), id: loginId, likes: [],postId: '',description: '');
      await FirebaseFirestore.instance.collection(Constants.userCollections).doc(loginId).collection(Constants.myposts).add(mydata.toJson()).then((value) async {
        post_models= await _auth.getPost(value.id);
        var updid=post_models?.copyWith(postId: value.id,description: description.text);
        postId=value.id;
        value.update(updid!.toJson());
      });
      // var updateData = profile_models!.copyWith(profile: downloadURL);
      // FirebaseFirestore.instance
      //     .collection(Constants.userCollections)
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .update(
      //   updateData.toJson(),
      // );

      // Update the state with the media URL for display or further use.
      setState(() {
        _mediaUrl = downloadURL;
      });

      print('Media uploaded to Firebase Storage and Firestore successfully. Download URL: $_mediaUrl');
    } catch (e) {
      // Handle any exceptions that occur during media upload.
      print('Error: $e');
    }
  }

  TextEditingController description=TextEditingController(text: 'New Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Add Post"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40,),
            Align(
              alignment: Alignment.center,
              child: _pickedMedia==null? Container(
                alignment: Alignment.center,
                height: height*0.35,
                width: width*0.6,
                decoration: BoxDecoration(border: Border.all(color: Colors.white,width: 3)),
                child: Center(
                  child:
                    InkWell(
                      onTap: (){
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            context: context, builder: (context) =>
                            Container(
                                height: height*0.1,
                                child: Container(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 30,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              _pickMedia(ImageSource.gallery);
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red,
                                              child: Icon(Icons.image,color: Colors.white),
                                            ),
                                          ),
                                          Text("Gallery")
                                        ],
                                      ),
                                      SizedBox(width: 30,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              _pickMedia(ImageSource.camera);
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red,
                                              child: Icon(Icons.camera_alt_outlined,color: Colors.white),
                                            ),
                                          ),
                                          Text("Camera")
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            )
                        );
                      },
                      child: Container(
                        height: height*0.05,
                        width: width*0.1,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.white,width: 2)),
                        child: Icon(Icons.add,color: Colors.white,),
                      ),
                    ),
                ),
              ):
                  Container(
                    height: height*0.35,
                    width: width*0.6,
                    child: Image.file(File(_pickedMedia!.path)),
                  )
            ),
            SizedBox(height: 40,),
            Container(
              height: height*.09,
              width: width*.9,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: description,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20)),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.red)
                ),
              ),
            ),
            InkWell(
              onTap: (){
                _uploadMediaToFirebase();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BotNav(),), (route) => false);
              },
              child: Container(
                alignment: Alignment.center,
                height: height*0.05,
                width: width*0.44,
                decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(10)),
                child: Text('Add Post',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
