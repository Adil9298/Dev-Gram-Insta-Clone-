import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/profile_models.dart';

import 'firebase_cons.dart';
import 'login.dart';

class Likes extends StatefulWidget {
  List<PostModels> data;
  var index;
  Likes({Key? key,required this.data,required this.index}) : super(key: key);

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Likes'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Liked by ${widget.data[widget.index].likes.length} people',style: TextStyle(fontSize: 25),)
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: height*0.7,
                  width: width,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection(Constants.userCollections).snapshots().map((event) => event.docs.map((e) => ProfileModels.fromJson(e.data())).toList()),
                    builder: (context, snapshot) {
                      List<ProfileModels>? postData=snapshot.data;
                      return ListView.builder(
                        itemCount: postData?.length,
                        itemBuilder: (context, index) {
                            if(!snapshot.hasData || snapshot.hasError){
                              return CircularProgressIndicator();
                            }
                            if(widget.data[widget.index].likes.contains(postData?[index].id)){
                              if(postData?[index].id!=loginId){
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
                                        // Text('${index+1}',style: TextStyle(fontSize: 20),),
                                        // SizedBox(width: 20,),
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(postData?[index].profile.toString()??""),
                                        ),
                                        // SizedBox(width: 10,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(postData?[index].name.toString()??'',style: TextStyle(fontSize: 16)),
                                            SizedBox(height: 10,),
                                            Text(postData?[index].email.toString()??'',style: TextStyle(fontSize: 16),)
                                          ],
                                        ),
                                        // SizedBox(width: 10,),
                                        InkWell(
                                          onTap: ()async{

                                            if ((postData?[index].followers??[]).contains(
                                                FirebaseAuth.instance.currentUser!.uid)) {


                                              //Remove id from followers of friend
                                              postData?[index].followers.remove(
                                                  FirebaseAuth.instance
                                                      .currentUser!
                                                      .uid);
                                              var upddatee = postData?[index].copyWith(
                                                followers: postData[index].followers,);
                                              FirebaseFirestore.instance
                                                  .collection(
                                                  Constants.userCollections)
                                                  .doc(postData?[index].id)
                                                  .update(upddatee!.toJson());


                                              //Remove id from following of me
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
                                              postData?[index].followers.add(
                                                  FirebaseAuth.instance
                                                      .currentUser!
                                                      .uid);
                                              var updda = postData?[index].copyWith(
                                                followers: postData[index].followers,);
                                              FirebaseFirestore.instance
                                                  .collection(
                                                  Constants.userCollections)
                                                  .doc(postData?[index].id)
                                                  .update(updda!.toJson());


                                              //Add id to following of me
                                              // profile_models!.following.add(
                                              //     data[index].id);
                                              // var updd = profile_models!.copyWith(
                                              //   following: profile_models!.following,);
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
                                            child: Text((postData?[index].followers??[]).contains(
                                                FirebaseAuth.instance.currentUser!.uid)?"Unfollow":"Follow",style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              else{
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
                                        // Text('${index+1}',style: TextStyle(fontSize: 20),),
                                        // SizedBox(width: 20,),
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(postData?[index].profile.toString()??''),
                                        ),
                                        // SizedBox(width: 10,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(postData?[index].name.toString()??'',style: TextStyle(fontSize: 16)),
                                            SizedBox(height: 10,),
                                            Text(postData?[index].email.toString()??'',style: TextStyle(fontSize: 16),)
                                          ],
                                        ),
                                        // SizedBox(width: 10,),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                            else{
                              return Container();
                            }



                      },);
                    }
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
