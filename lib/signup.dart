import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/login.dart';
import 'package:new_project/home.dart';


class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController username=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController confpass=TextEditingController();



  AuthController _auth=AuthController();

  bool passwordVisible1=false;
  bool passwordVisible2=false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Sign Up",style: TextStyle(fontSize: 30,color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
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
                            controller: username,
                            validator: (value){
                              var val=value??'';
                              if(val.isEmpty){
                                return 'Please enter Username';
                              }
                              if(val.length<5){
                                return 'At least 5 Characters';
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                                labelText: 'Username',
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
                            controller: email,
                            validator: (value1){
                              var val1=value1??'';
                              if(val1.isEmpty){
                                return 'Please enter Email';
                              }
                              else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val1)){
                                return 'Required a Valid Email';
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                                labelText: 'Email',
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
                          child: IntlPhoneField(
                            controller: phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(color: Colors.red),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: EdgeInsets.only(left: 15,right: 15),
                        child: Container(
                          height: height*.09,
                          width: width*.9,
                          child: TextFormField(
                            controller: password,
                            validator: (passCurrentValue){
                              RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              var passNonNullValue=passCurrentValue??'';
                              if(passNonNullValue.isEmpty){
                                return ("Password is Required");
                              }
                              else if(passNonNullValue.length<8){
                                return ("Password must have at least 8 characters");
                              }
                              else if(!regex.hasMatch(passNonNullValue)){
                                return ("Password should contain a A-Z, a-z, 0-9 and @!# ");
                              }
                              return null;
                              },
                            obscureText: !passwordVisible1,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.red),
                                suffixIconColor: Colors.black,
                                suffixIcon: IconButton(onPressed: (){
                                  setState(
                                        () {
                                      passwordVisible1 = !passwordVisible1;
                                    },
                                  );
                                },
                                    icon: Icon(passwordVisible1 ? Icons.visibility_off : Icons.visibility)),
                                alignLabelWithHint: false,
                                filled: true
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
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
                            controller: confpass,
                            validator: (value2){
                              var val2=value2??'';
                              if(val2.isEmpty){
                                return 'Please Re-enter Password';
                              }
                              if(password.text != confpass.text){
                                return 'Password Mismatch';
                              }
                            },
                            obscureText: !passwordVisible2,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red),borderRadius: BorderRadius.circular(20)),
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(color: Colors.red),
                                suffixIconColor: Colors.black,
                                suffixIcon: IconButton(onPressed: (){
                                  setState(
                                        () {
                                      passwordVisible2 = !passwordVisible2;
                                    },
                                  );
                                },
                                    icon: Icon(passwordVisible2 ? Icons.visibility_off : Icons.visibility)),
                                alignLabelWithHint: false,
                                filled: true
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Signing In')),
                            );
                            _auth.usrenter(email,password,username,email,phone,password,context);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: height*.05,
                          width: width*.7,
                          decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
                          child: Text("SIGN UP",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
