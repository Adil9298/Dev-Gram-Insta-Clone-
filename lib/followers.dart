import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/profile_models.dart';
import 'package:new_project/login.dart';

import 'firebase_cons.dart';



class Followers extends StatefulWidget {
  const Followers({Key? key}) : super(key: key);

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {

  var inx;

  TextEditingController search=TextEditingController();


  // AuthController _auth=AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Followers"),
        backgroundColor: Colors.red,
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
                    controller: search,
                    onChanged: (value) {
                      setState(() {

                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(onPressed: (){search.clear();}, icon: Icon(Icons.clear)),
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            StreamBuilder<ProfileModels>(
              stream: FirebaseFirestore.instance.collection(Constants.userCollections).doc(loginId).snapshots().map((event) => ProfileModels.fromJson(event.data()!)),
              builder: (context, snapshot) {
                ProfileModels? data=snapshot.data;
                // print(data?.length);
                print('-----------------');
                return Container(
                  height: height*.79,
                  width: width,
                  child: ListView.builder(
                      itemCount: data?.followers.length,
                      itemBuilder: (context, index) {
                        final userdata=data?.followers[index];
                        if(!snapshot.hasData || snapshot.hasError){
                          return CircularProgressIndicator();
                        }
                        // for(int i=0;i<data!.length;i++){
                        //   if(data[i].id==loginId){
                        //     inx=i;
                        //     break;
                        //   }
                        // }
                        // if ((profile_models?.followers??[]).contains(data![index].id)) {
                          return StreamBuilder<ProfileModels>(
                            stream: FirebaseFirestore.instance.collection(Constants.userCollections).doc(userdata).snapshots().map((event) => ProfileModels.fromJson(event.data()!)),
                            builder: (context, snapshot) {
                              ProfileModels? userid=snapshot.data;
                              if(!snapshot.hasData || snapshot.hasError){
                                return CircularProgressIndicator();
                              }
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
                                        backgroundImage: NetworkImage(userid!.profile.toString()),
                                      ),
                                      // SizedBox(width: 10,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(userid.name.toString(),style: TextStyle(fontSize: 16)),
                                          SizedBox(height: 10,),
                                          Text(userid.email.toString(),style: TextStyle(fontSize: 16),)
                                        ],
                                      ),
                                      // SizedBox(width: 10,),
                                      InkWell(
                                        onTap: ()async{

                                          if (userid.followers.contains(
                                              FirebaseAuth.instance.currentUser!.uid)) {


                                            //Remove id from followers of friend
                                            userid.followers.remove(
                                                FirebaseAuth.instance
                                                    .currentUser!
                                                    .uid);
                                            var upddatee = userid.copyWith(
                                              followers: userid.followers,);
                                            FirebaseFirestore.instance
                                                .collection(
                                                Constants.userCollections)
                                                .doc(userid.id)
                                                .update(upddatee.toJson());


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
                                            userid.followers.add(
                                                FirebaseAuth.instance
                                                    .currentUser!
                                                    .uid);
                                            var updda = userid.copyWith(
                                              followers: userid.followers,);
                                            FirebaseFirestore.instance
                                                .collection(
                                                Constants.userCollections)
                                                .doc(userid.id)
                                                .update(updda.toJson());


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
                                          child: Text(userid.followers.contains(
                                              FirebaseAuth.instance.currentUser!.uid)?"Unfollow":"Follow",style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );


                        // }
                        // else{
                        //   return Container();
                        // }
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

