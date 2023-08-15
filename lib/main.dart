import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_project/login.dart';
import 'package:new_project/root/root.dart';
import 'package:shared_preferences/shared_preferences.dart';

// const firebaseConfig = {
//   apiKey: "AIzaSyAtK_BmTDg6qyJX0rcLFARDakxww3nR6ms",
//   authDomain: "adil-26a27.firebaseapp.com",
//   projectId: "adil-26a27",
//   storageBucket: "adil-26a27.appspot.com",
//   messagingSenderId: "299399344807",
//   appId: "1:299399344807:web:d151c86bf785ff5beb6182",
//   measurementId: "G-HM8GY9XZDP"
// };

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyAtK_BmTDg6qyJX0rcLFARDakxww3nR6ms",
      appId: "1:299399344807:web:d151c86bf785ff5beb6182",
      messagingSenderId: "299399344807",
      projectId: "adil-26a27")
    );
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RootPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


