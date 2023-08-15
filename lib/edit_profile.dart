import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/botNav.dart';
import 'package:new_project/firebase_cons.dart';
import 'package:new_project/home.dart';
import 'package:new_project/profile_models.dart';
import 'package:new_project/login.dart';
import 'package:new_project/view_profile.dart';



class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  AuthController _auth=AuthController();

  File? _pickedMedia;
  String? _mediaUrl;
  Future<void> _pickMedia(ImageSource media) async {
    final pickedFile = await ImagePicker().pickImage(source: media);/*pickVideo(source: ImageSource.gallery);*/
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
          .ref('media/${DateTime.now().millisecondsSinceEpoch}.mp4') // For images, replace '.mp4' with the appropriate file extension like '.jpg'
          .putFile(_pickedMedia as File);

      // Wait for the upload to complete and retrieve the download URL
      final String downloadURL = await uploadTaskSnapshot.ref.getDownloadURL();


      profile_models = (await _auth.getUser(FirebaseAuth.instance.currentUser!.uid));
      var updateData = profile_models!.copyWith(profile: downloadURL);
      FirebaseFirestore.instance
          .collection(Constants.userCollections)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        updateData.toJson(),
      );

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


  final _formKey = GlobalKey<FormState>();

  TextEditingController username=TextEditingController(text: profile_models!.name);
  TextEditingController phone=TextEditingController(text: profile_models!.phone);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(onPressed: () async {
            if(_formKey.currentState!.validate()){
              profile_models=await _auth.getUser(FirebaseAuth.instance.currentUser!.uid);
              var edtprof=profile_models!.copyWith(name: username.text,phone: phone.text);
              profile_models!.reference!.update(edtprof.toJson());
              _uploadMediaToFirebase();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BotNav(),), (route) => false);
            }
          }, icon: Icon(Icons.done_outline_sharp,size: 30,)),
          SizedBox(width: 30,),
        ],
      ),
      body: SafeArea(
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfile(),));
                      },
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(profile_models?.profile??''),
                        radius: 60,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: InkWell(
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
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.camera_alt_outlined,color: Colors.white,),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  child: Container(
                    height: height*.09,
                    width: width*.9,
                    child: TextFormField(
                      controller: username,
                      validator: (value){
                        var val=value??'';
                        if(val.isEmpty){
                          return 'Please enter Username';
                        }
                        if(val.length<5){
                          return 'At least 5 Characters';
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.red)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  child: Container(
                    height: height*.09,
                    width: width*.9,
                    child: IntlPhoneField(
                      controller: phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
