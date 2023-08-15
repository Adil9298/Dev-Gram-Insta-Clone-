import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_project/add_post.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/edit_profile.dart';
import 'package:new_project/firebase_cons.dart';
import 'package:new_project/followers.dart';
import 'package:new_project/following.dart';
import 'package:new_project/login.dart';
import 'package:new_project/profile_models.dart';
import 'package:new_project/saved.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> with SingleTickerProviderStateMixin {

  TabController? tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController=TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController?.dispose();
  }

  AuthController _auth=AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("adil_._.__",style: TextStyle(fontSize: 30)),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPictureSize: Size.fromRadius(40),
              accountEmail: Text(profile_models?.email??'',style: TextStyle(color: Colors.black)),
              accountName: Text(profile_models?.name??'',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
              currentAccountPicture: CircleAvatar(

                radius: 20,
                backgroundImage: CachedNetworkImageProvider(profile_models?.profile??''),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(image: CachedNetworkImageProvider('https://blog.sebastiano.dev/content/images/2019/07/1_l3wujEgEKOecwVzf_dqVrQ.jpeg'),fit: BoxFit.fill)
              ),
              onDetailsPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile(),));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.home_outlined,color: Colors.black),
            //   title: Text("Home",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            //   onTap: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.follow_the_signs_sharp,color: Colors.black),
            //   title: Text("Followers",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            //   onTap: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => Followers(),));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.directions_walk_outlined,color: Colors.black),
            //   title: Text("Following",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            //   onTap: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => Following(),));
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.bookmark,color: Colors.black),
              title: Text("Saved",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Saved(),));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined,color: Colors.black),
              title: Text("Log Out",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
              onTap: (){
                _auth.signOut(context);
              },
            ),
          ],
        ),
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
                    backgroundImage: CachedNetworkImageProvider(profile_models!.profile),
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
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Following(),));
                  },
                  child: Container(
                    height: height*0.115,
                    width: width*0.23,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$peplength',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                        Text("Following",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Followers(),));
                  },
                  child: Container(
                    height: height*0.115,
                    width: width*0.23,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(profile_models!.followers.length.toString(),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                        Text("Followers",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold))
                      ],
                    ),
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
                  Text(profile_models!.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
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
              Container(
                alignment: Alignment.centerLeft,
                height: height*0.07,
                width: width*0.9,
                decoration: BoxDecoration(color: Colors.grey[700],borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Professional dashboard",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
                        Text("227 accounts reached in the last 30 days.",style: TextStyle(fontSize: 14,color: Colors.white),)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(),));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: height*0.05,
                  width: width*0.44,
                  decoration: BoxDecoration(color: Colors.grey[700],borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Edit Profile",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
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
                    backgroundImage: CachedNetworkImageProvider(profile_models!.profile),
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
                  stream: FirebaseFirestore.instance.collection(Constants.userCollections).doc(loginId).collection(Constants.myposts).snapshots().map((event) => event.docs.map((e) => PostModels.fromJson(e.data())).toList()),
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
