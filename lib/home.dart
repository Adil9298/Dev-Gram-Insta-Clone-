import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_project/UserList.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/edit_profile.dart';
import 'package:new_project/feed.dart';
import 'package:new_project/firebase_cons.dart';
import 'package:new_project/followers.dart';
import 'package:new_project/following.dart';
import 'package:new_project/login.dart';
import 'package:new_project/messaging.dart';
import 'package:new_project/myProfile.dart';
import 'package:new_project/othersProfile.dart';
import 'package:new_project/profile_models.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          title: Text("DevGram",style: TextStyle(fontFamily: 'Dancing',fontWeight: FontWeight.w800,fontSize: 35)),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Messenger(),));
            },
              child: Icon(FontAwesomeIcons.facebookMessenger,color: Colors.white,size: 30)),
          SizedBox(width: 20,),
        ],
         ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       UserAccountsDrawerHeader(
      //         currentAccountPictureSize: Size.fromRadius(40),
      //         accountEmail: Text(profile_models?.email??'',style: TextStyle(color: Colors.black)),
      //         accountName: Text(profile_models?.name??'',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
      //         currentAccountPicture: CircleAvatar(
      //
      //           radius: 20,
      //           backgroundImage: CachedNetworkImageProvider(profile_models?.profile??''),
      //         ),
      //         decoration: BoxDecoration(
      //           image: DecorationImage(image: CachedNetworkImageProvider('https://blog.sebastiano.dev/content/images/2019/07/1_l3wujEgEKOecwVzf_dqVrQ.jpeg'),fit: BoxFit.fill)
      //         ),
      //         onDetailsPressed: (){
      //           Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile(),));
      //         },
      //         ),
      //       ListTile(
      //         leading: Icon(Icons.home_outlined,color: Colors.black),
      //         title: Text("Home",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
      //         onTap: (){
      //           Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.follow_the_signs_sharp,color: Colors.black),
      //         title: Text("Followers",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
      //         onTap: (){
      //           Navigator.push(context, MaterialPageRoute(builder: (context) => Followers(),));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.directions_walk_outlined,color: Colors.black),
      //         title: Text("Following",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
      //         onTap: (){
      //           Navigator.push(context, MaterialPageRoute(builder: (context) => Following(),));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.people,color: Colors.black),
      //         title: Text("Users List",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
      //         onTap: (){
      //           Navigator.push(context, MaterialPageRoute(builder: (context) => UsersList(),));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.logout_outlined,color: Colors.black),
      //         title: Text("Log Out",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
      //         onTap: (){
      //           _auth.signOut(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
              SizedBox(height: 10,),
              StreamBuilder<List<PostModels>>(
                stream: FirebaseFirestore.instance.collectionGroup(Constants.myposts).snapshots().map((event) => event.docs.map((e) => PostModels.fromJson(e.data())).toList()),
                builder: (context, snapshot) {
                  print(snapshot.error);
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);

                }
                  List<PostModels>? data=snapshot.data;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(profile_models!.profile),
                            radius: 40,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    radius: 10,
                                    child: Icon(Icons.add,size: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            height: height*0.1,
                            width: width*0.75,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: height*.7,
                        width: width,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                            itemCount: data?.length,
                            itemBuilder: (context, index) {
                              // for(int i=0;i<data!.length;i++){
                              //   if(data[i].id==loginId){
                              //     inx=i;
                              //     break;
                              //   }
                              // }
                              return Feed(data: data!,index: index,);
                            }
                        ),
                      ),
                    ],
                  );
              },),
          ],
        ),
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   height: height*0.07,
      //     backgroundColor: Colors.white,
      //     color: Colors.red,
      //     items: <Widget>[
      //       Icon(Icons.home,color: Colors.white,size: 30),
      //       Icon(Icons.search,color: Colors.white,size: 30),
      //       Icon(Icons.add_box_outlined,color: Colors.white,size: 30),
      //       Icon(FontAwesomeIcons.facebookMessenger,color: Colors.white,size: 30),
      //       CircleAvatar(
      //         radius: 18,
      //         backgroundImage: CachedNetworkImageProvider(profile_models?.profile??''),
      //       )
      //
      //     ]),
    );
  }
}