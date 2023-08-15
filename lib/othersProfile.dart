import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_project/profile_models.dart';

import 'auth_controller.dart';
import 'firebase_cons.dart';
import 'login.dart';

class OthersProfile extends StatefulWidget {
  ProfileModels data;
  OthersProfile({Key? key,required this.data}) : super(key: key);

  @override
  State<OthersProfile> createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfile> with SingleTickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController=TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.data.name,style: TextStyle(fontSize: 30)),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(right: 10,left: 10),
            child: Row(
              children: [
                Container(
                  height: height*0.115,
                  width: width*0.23,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(widget.data.profile),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: height*0.115,
                  width: width*0.23,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("0",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                      Text("Post",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                Container(
                  height: height*0.115,
                  width: width*0.23,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('0',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                      Text("Following",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                Container(
                  height: height*0.115,
                  width: width*0.23,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.data.followers.length.toString(),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                      Text("Followers",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                  Text('Personal blog',style: TextStyle(color: Colors.grey[700],fontSize: 16,fontWeight: FontWeight.bold)),
                  Container(
                      child: Text("BIO",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: ()async{

                  if (widget.data.followers.contains(
                      FirebaseAuth.instance.currentUser!.uid)) {

                    FirebaseFirestore.instance
                        .collection(
                        Constants.userCollections)
                        .doc(widget.data.id)
                        .update({'followers':FieldValue.arrayRemove([loginId])});

                  }



                  else {

                    FirebaseFirestore.instance
                        .collection(
                        Constants.userCollections)
                        .doc(widget.data.id)
                        .update({'followers':FieldValue.arrayUnion([loginId])});
                  }

                },
                child: Container(
                  alignment: Alignment.center,
                  height: height*0.05,
                  width: width*0.44,
                  decoration: BoxDecoration(color: Colors.grey[700],borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.data.followers.contains(
                          loginId)?"Unfollow":"Follow",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Container(
                height: height*0.05,
                width: width*0.44,
                decoration: BoxDecoration(color: Colors.grey[700],borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Share Profile",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              SizedBox(width: 10,),
              Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: CachedNetworkImageProvider(widget.data.profile),
                  ),
                  SizedBox(height: 10,),
                  Text("Memories")
                ],
              ),
              SizedBox(width: 10,),
              Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    child: Icon(Icons.add,color: Colors.white),
                    backgroundColor: Colors.black,
                  ),
                  SizedBox(height: 10,),
                  Text("Add")
                ],
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
            height: height*0.075,
            width: width,
            child: TabBar(
                controller: tabController,
                tabs: [
                  Tab(
                    child: Icon(Icons.grid_on_rounded,color: Colors.black,),
                  ),
                  Tab(
                    child: Icon(FontAwesomeIcons.userTag,color: Colors.black),
                  ),
                ]),
          ),
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: [
                  Container(
                    // width: width,
                    // height: height*0.329,
                    color: Colors.black,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection(Constants.userCollections).doc(widget.data.id).collection(Constants.myposts).snapshots().map((event) => event.docs.map((e) => PostModels.fromJson(e.data())).toList()),
                      builder: (context, snapshot) {
                        var data=snapshot.data;
                        return GridView.builder(
                          itemCount: data?.length,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: width*0.4,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1
                          ), itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,),
                            child: Image(image: CachedNetworkImageProvider(data?[index].post??'')),
                          );
                        },);
                      },
                    ),
                  ),
                  Card(
                    child: Center(child: Text("No Tags Yet.")),
                  )
                ]
            ),
          )
        ],
      ),
    );
  }
}
