

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_project/add_post.dart';
import 'package:new_project/firebase_cons.dart';
import 'package:new_project/login.dart';
import 'package:new_project/profile_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

var upd;
var loginId;
// var followersId;

// Map<String,dynamic> myProfile={};

class AuthController{



  //Sign in with Google
  void signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser= await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth=await googleUser?.authentication;
    final credential=GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
      var userdata=ProfileModels(
          name: googleUser!.displayName!,
          profile: googleUser.photoUrl!,
          email: googleUser.email,
          id: value.user!.uid,
          phone: "",
          createTime: Timestamp.now(),
          loginTime: Timestamp.now(),
          following: [],
          followers: [],
        saved: []
      );
      loginId=FirebaseAuth.instance.currentUser!.uid;
      upd=value.user!.uid;
      if(value.additionalUserInfo!.isNewUser == true) {
        FirebaseFirestore.instance.collection(Constants.userCollections)
            .doc(value.user!.uid).set(userdata.toJson()
          //     {
          //   'name':googleUser!.displayName,
          //   'email':googleUser.email,
          //   'id':googleUser.id,
          //   'profile':googleUser.photoUrl,
          //   'create time':FieldValue.serverTimestamp(),
          //   'phone':""
          // }
        );
      }
      else {
        profile_models=await getUser(upd);
        SharedPreferences pref=await SharedPreferences.getInstance();

        pref.setString('uid', upd);
        // var user=ProfileModels(loginTime: Timestamp.now());
        // FirebaseFirestore.instance.collection(Constants.firebaseCollections).doc(value.user!.uid).update(userdata.copyWith(loginTime: Timestamp.now()));
        var userof=profile_models!.copyWith(loginTime: Timestamp.now());
        FirebaseFirestore.instance.collection(Constants.userCollections).doc(value.user!.uid).update(userof.toJson());
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
    } );

  }



  //Sign out
  signOut(BuildContext context)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.remove('uid');
    FirebaseAuth.instance.signOut().then((value) =>
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login(),), (route) => false));

  }


  //Signup with email and password along with details
  usrenter(mail,pass,name,email,phone,password,BuildContext context){
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: mail.text, password: pass.text).then((value) {
      FirebaseFirestore.instance.collection('user').doc(
          value.user!.uid).set(
          {'name': name.text,
            'mail': email.text,
            'phone': phone.text,
            'password': password.text,
            'createdDate': FieldValue.serverTimestamp()
          });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
    ).onError((error, stackTrace) {
      showError(context, error.toString());
    });
  }





  //Logging in with email and password
  enteruser(a1,b1,BuildContext context)async {
    // UserCredential user;
    // try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: a1.text, password: b1.text).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
      ).onError((error, stackTrace) {
        showError(context, error.toString());
     });

      // FirebaseFirestore.instance.collection('user').doc('igpBguJFQkPrm0kE0Xe1TTGsetd2').update(
      //     {'date':DateTime.now(),
      //     'name':'adil'});
    // } catch (e) {
    //   showError(context, e.toString());
    // }
  }




  //forgot password email send
  forgotpass(a1,BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email Send")));
    FirebaseAuth.instance.sendPasswordResetEmail(email: a1.text);
  }

  //update loginTime in each signIn
  getUser(String upd) async {
    // FirebaseFirestore.instance.collection(Constants.firebaseCollections).doc(upd.id).update(upd.toJson());
    DocumentSnapshot<Map<String,dynamic>> snapshot=await FirebaseFirestore.instance.collection(Constants.userCollections).doc(upd).get();
    if(snapshot.exists){
      var data=ProfileModels.fromJson(snapshot.data()!);
      return data;
    }
  }


  getPost(String upd) async {
    // FirebaseFirestore.instance.collection(Constants.firebaseCollections).doc(upd.id).update(upd.toJson());
    DocumentSnapshot<Map<String,dynamic>> snapshot=await FirebaseFirestore.instance.collection(Constants.userCollections).doc(loginId).collection(Constants.myposts).doc(upd).get();
    if(snapshot.exists){
      var data=PostModels.fromJson(snapshot.data()!);
      return data;
    }
  }


  getComment(String a,String b,String upd) async {
    // FirebaseFirestore.instance.collection(Constants.firebaseCollections).doc(upd.id).update(upd.toJson());
    DocumentSnapshot<Map<String,dynamic>> snapshot=await FirebaseFirestore.instance.collection(Constants.userCollections).doc(a).collection(Constants.myposts).doc(b).collection(Constants.mycomments).doc(upd).get();
    if(snapshot.exists){
      var data=CommentModels.fromJson(snapshot.data()!);
      return data;
    }
  }




  Stream<List<ProfileModels>> user() {
    return FirebaseFirestore.instance
        .collection(Constants.userCollections).where('id',isNotEqualTo : loginId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => ProfileModels.fromJson(
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<List<ProfileModels>> userMe() {
    return FirebaseFirestore.instance
        .collection(Constants.userCollections).where('id',isEqualTo : loginId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => ProfileModels.fromJson(
          doc.data(),
        ),
      )
          .toList(),
    );
  }


  Stream<List<ProfileModels>> following() {
    return FirebaseFirestore.instance
        .collection(Constants.userCollections).where('followers',arrayContains : loginId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => ProfileModels.fromJson(
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  // Stream<List<ProfileModels>> followers(List userFollowers) {
  //   return FirebaseFirestore.instance
  //       .collection(Constants.userCollections)
  //       .where('followers', isEqualTo: userFollowers)
  //       .snapshots()
  //       .map(
  //         (snapshot) => snapshot.docs
  //         .map(
  //           (doc) => ProfileModels.fromJson(
  //         doc.data(),
  //       ),
  //     )
  //         .toList(),
  //   );
  // }

  // Future<List<ProfileModels>> getAllFollowers(List<String> followersId) async{
  //   List<ProfileModels> allFollowers=[];
  //
  //   int groupSize=10;
  //   final groups=<List<String>>[];
  //   for(var i=0;i<followersId.length;i=i+groupSize) {
  //     groups.add(followersId.sublist(i,
  //         i + groupSize > followersId.length ? followersId.length : i + groupSize));
  //   }
  //
  //     for(var group in groups){
  //       final querySnapshot=await FirebaseFirestore.instance.collection(Constants.userCollections).where('id',whereIn: group).get();
  //
  //       final followers= querySnapshot.docs.map((value) => ProfileModels.fromJson(value.data())).toList();
  //       allFollowers.addAll(followers);
  //     }
  //
  //     return allFollowers;
  //
  // }


  // myUser(){
  //   FirebaseFirestore.instance.collection('settings').doc('adil').update(
  //       {
  //     'test.name':FieldValue.delete()
  //   });
  // }

}

