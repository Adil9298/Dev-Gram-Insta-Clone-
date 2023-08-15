import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_project/UserList.dart';
import 'package:new_project/add_post.dart';
import 'package:new_project/followers.dart';
import 'package:new_project/messaging.dart';
import 'package:new_project/myProfile.dart';
import 'package:new_project/profile_models.dart';
import 'package:new_project/reels.dart';

import 'home.dart';
import 'login.dart';

class BotNav extends StatefulWidget {
  const BotNav({Key? key}) : super(key: key);

  @override
  State<BotNav> createState() => _BotNavState();
}

class _BotNavState extends State<BotNav> {
  int _selectedIndex=0;

  pageCaller(int index) {
    switch (index) {
      case 0:
        {
          return Home();
        }
      case 1:
        {
          return UsersList();
        }
      case 2:
        {
          return AddPost();
        }
      case 3:
        {
          return Reels();
        }
      case 4:
        {
          return MyProfile();
        }
    }
  }

  void _onItemTapped(int index) {

      setState(() {
        _selectedIndex = index;
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: pageCaller(_selectedIndex)
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: _onItemTapped,
          index: _selectedIndex,
          height: height*0.07,
          backgroundColor: Colors.black,
          color: Colors.red,
          items: <Widget>[
            Icon(Icons.home,color: Colors.white,size: 30),
            Icon(Icons.search,color: Colors.white,size: 30),
            Icon(Icons.add_box_outlined,color: Colors.white,size: 30),
            Image(image: AssetImage('assets/images/instagram-reels-icon.png'),height: 25,width: 50,),
            CircleAvatar(
              radius: 18,
              backgroundImage: CachedNetworkImageProvider(profile_models?.profile??''),
            )

          ]),
    );
  }
}