import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/home.dart';
import 'package:new_project/profile_models.dart';
import 'package:new_project/signup.dart';

var height;
var width;

//Snack bar showing Error
showError(BuildContext context,String msg){
  final snackBar=SnackBar(content: Text(msg),
    backgroundColor: Colors.red,
    action: SnackBarAction(label: "OK", onPressed:(){}),);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController usrmail=TextEditingController();
  TextEditingController password=TextEditingController();

AuthController _auth=AuthController();

FocusNode f1=FocusNode();
  FocusNode f2=FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool passwordVisible=false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Log In",style: TextStyle(fontSize: 30,color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      // Text("Username/Gmail: "),
                      Padding(
                        padding: EdgeInsets.only(left: 15,right: 15),
                        child: Container(
                          height: height*.09,
                          width: width*.9,
                          child: TextFormField(
                            focusNode: f1,
                            onFieldSubmitted: (value) {
                              //f1.unfocus();
                              FocusScope.of(context).requestFocus(f2);
                            },
                            controller: usrmail,
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value){
                              var val=value??'';
                              if(val.isEmpty){
                                return 'Please enter Username or Email';
                              }
                              if(val.length<5){
                                return 'At least 5 Characters';
                              }
                            },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                                labelText: 'Email or Username',
                                labelStyle: TextStyle(color: Colors.red)
                              ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: EdgeInsets.only(left: 15,right: 15),
                        child: Container(
                          height: height*.09,
                          width: width*.9,
                          child: TextFormField(
                            focusNode: f2,
                            controller: password,
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value1){
                              var val1=value1??'';
                              if(val1.isEmpty){
                                return 'Please enter Password';
                              }
                              if(val1.length<8){
                                return 'At least 8 Characters';
                              }
                            },
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.red),
                              suffixIconColor: Colors.black,
                              suffixIcon: IconButton(onPressed: (){
                                setState(
                                      () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                                  icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility)),
                              alignLabelWithHint: false,
                              filled: true
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 250,),
                          Padding(
                            padding: EdgeInsets.only(right: 1),
                              child: InkWell(
                                onTap: (){
                                  _auth.forgotpass(usrmail,context);
                                },
                                  child: Text("Forgot Password??",style: TextStyle(color: Colors.red),))),
                        ],
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          if (_formKey.currentState!.validate()) {
                            _auth.enteruser(usrmail,password,context);


                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text('Logged In')),
                            // );
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: height*.05,
                          width: width*.7,
                          decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
                          child: Text("LOG IN",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){

                          _auth.signInWithGoogle(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: height*.05,
                          width: width*.7,
                          decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20)),
                          child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Image(image: AssetImage("assets/images/google.png")),
                            SizedBox(width: 20,),
                            Text("Continue with Google",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
                          ],
                          )
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Are you a new Member??",style: TextStyle(fontSize: 16)),
                            SizedBox(width: 10,),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  Signup()),
                                );
                              },
                                child: Text("Sign Up",style: TextStyle(fontSize: 16,color: Colors.red),)),
                            SizedBox(width: 150,),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

