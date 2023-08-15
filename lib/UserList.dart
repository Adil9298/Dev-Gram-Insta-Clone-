import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/edit_profile.dart';
import 'package:new_project/firebase_cons.dart';
import 'package:new_project/followers.dart';
import 'package:new_project/following.dart';
import 'package:new_project/login.dart';
import 'package:new_project/profile_models.dart';
import 'package:new_project/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {

    AuthController _auth=AuthController();

    TextEditingController search=TextEditingController();

    bool follow=false;

    userpro() {
      FirebaseFirestore.instance
          .collection(Constants.userCollections)
          .doc(loginId)
          .get()
          .then(
            (value) {
          profile_models = ProfileModels.fromJson(value.data()!);
          if (mounted) {
            setState(() {});

          }
        },
      );
    }

    // usersList() {
    //   FirebaseFirestore.instance
    //       .collection(Constants.userCollections)
    //       .where("id",isNotEqualTo: loginId)
    //       .snapshots()
    //       .listen(
    //         (value) {
    //           data!.clear();
    //           for(var a in value.docs){
    //             data!.add(ProfileModels.fromJson(a.data()));
    //           }
    //       if (mounted) {
    //         setState(() {});
    //
    //       }
    //     },
    //   );
    // }

    @override
    void initState() {
      print(loginId);
      userpro();
      super.initState();
    }
    // Stream<List<ProfileModels>> user() {
    //   return FirebaseFirestore.instance
    //       .collection(Constants.firebaseCollections).orderBy('createTime',descending: true)
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
    int inx=0;
    @override
    Widget build(BuildContext context) {

      return profile_models==null?
      Container(
        child: Center(child: CircularProgressIndicator()),
      )
          :Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text("Users List"),
            ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: height*.08,
                    width: width*.8,
                    alignment: Alignment.center,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: search,
                      onChanged: (value) {
                        setState(() {

                        });
                      },
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20)),
                        suffixIcon: IconButton(onPressed: (){search.clear();}, icon: Icon(Icons.clear,color: Colors.white,)),
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search,color: Colors.white,),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              StreamBuilder<List<ProfileModels>>(
                stream: _auth.user(),
                builder: (context, snapshot) {
                  print(snapshot.error);
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);

                  }
                  List<ProfileModels>? data=snapshot.data;
                  return Container(
                    height: height*.79,
                    width: width,
                    child: ListView.builder(
                        itemCount: data?.length,
                        itemBuilder: (context, index) {
                          // for(int i=0;i<data!.length;i++){
                          //   if(data[i].id==loginId){
                          //     inx=i;
                          //     break;
                          //   }
                          // }
                          if (search.text.isEmpty){
                            // return Users(index: index, data: data!,inx: inx,);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                height: height*.1,
                                width: width*.6,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // SizedBox(width: 20,),
                                    Text('${index+1}',style: TextStyle(fontSize: 20),),
                                    // SizedBox(width: 20,),
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(data![index].profile.toString()),
                                    ),
                                    // SizedBox(width: 10,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(data[index].name.toString(),style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 10,),
                                        Text(data[index].email.toString(),style: TextStyle(fontSize: 16),)
                                      ],
                                    ),
                                    // SizedBox(width: 10,),
                                    InkWell(
                                      onTap: ()async{

                                        if (data[index].followers.contains(
                                            FirebaseAuth.instance.currentUser!.uid)) {


                                          //Remove id from followers of friend
                                          // data[index].followers.remove(
                                          //     FirebaseAuth.instance
                                          //         .currentUser!
                                          //         .uid);
                                          // var upddatee = data[index].copyWith(
                                          //     followers: data[index].followers,);
                                          FirebaseFirestore.instance
                                              .collection(
                                              Constants.userCollections)
                                              .doc(data[index].id)
                                              .update({'followers':FieldValue.arrayRemove([loginId])});


                                          //Remove id from following of me
                                          // usersModel = (obj.getUser(widget.data[widget.index].uid));
                                          // profile_models!.following.remove(
                                          //     data[index].id);
                                          // var upddate = profile_models!.copyWith(
                                          //     following: profile_models!.following);
                                          // FirebaseFirestore.instance
                                          //     .collection(
                                          //     Constants.firebaseCollections)
                                          //     .doc(profile_models!.id)
                                          //     .update(upddate.toJson());
                                        }



                                        else {

                                          //Add id to followers of friend
                                          // data[index].followers.add(
                                          //     FirebaseAuth.instance
                                          //         .currentUser!
                                          //         .uid);
                                          // var upddate = data[index].copyWith(
                                          //     followers: data[index].followers,);
                                          FirebaseFirestore.instance
                                              .collection(
                                              Constants.userCollections)
                                              .doc(data[index].id)
                                              .update({'followers':FieldValue.arrayUnion([loginId])});


                                          //Add id to following of me
                                          // profile_models!.following.add(
                                          //     data[index].id);
                                          // var updd = profile_models!.copyWith(
                                          //     following: profile_models!.following);
                                          // FirebaseFirestore.instance
                                          //     .collection(
                                          //     Constants.firebaseCollections)
                                          //     .doc(profile_models!.id)
                                          //     .update(updd.toJson());
                                        }

                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: height*.03,
                                        width: width*.2,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.red),
                                        child: Text(data[index].followers.contains(
                                            loginId)?"Unfollow":"Follow",style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          else if(data![index].name.toLowerCase().toString().contains(search.text.toLowerCase()) || data[index].email.toLowerCase().toString().contains(search.text.toLowerCase())){
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                height: height*.1,
                                width: width*.6,
                                decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // SizedBox(width: 20,),
                                    Text('${index+1}',style: TextStyle(fontSize: 20),),
                                    // SizedBox(width: 20,),
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(data[index].profile.toString()),
                                    ),
                                    // SizedBox(width: 20,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(data[index].name.toString(),style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 10,),
                                        Text(data[index].email.toString(),style: TextStyle(fontSize: 16),)
                                      ],
                                    ),
                                    // SizedBox(width: 10,),
                                    Container(
                                      alignment: Alignment.center,
                                      height: height*.03,
                                      width: width*.2,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.blue),
                                      child: Text(data[index].followers.contains(FirebaseAuth.instance.currentUser!.uid)?"Unfollow":"Follow",style: TextStyle(fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          else{
                            return Container();
                          }
                        }
                    ),
                  );
                },)
            ],
          ),
        ),
      );
    }
  }
