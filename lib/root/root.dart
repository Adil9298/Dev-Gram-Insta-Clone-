import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/botNav.dart';
import 'package:new_project/home.dart';
import 'package:new_project/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}


class _RootPageState extends State<RootPage> {

  getLocalStatus()async{
    SharedPreferences pref=await SharedPreferences.getInstance();

    if(pref.containsKey('uid')){
      loginId=pref.getString('uid');
      upd=pref.getString('uid');

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BotNav(),), (route) => false);

    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login(),), (route) => false);

    }

  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {

      getLocalStatus() ;

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
