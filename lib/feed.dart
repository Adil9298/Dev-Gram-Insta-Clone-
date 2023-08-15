import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_project/add_post.dart';
import 'package:new_project/auth_controller.dart';
import 'package:new_project/likes.dart';
import 'package:new_project/myProfile.dart';
import 'package:new_project/profile_models.dart';

import 'firebase_cons.dart';
import 'login.dart';
import 'othersProfile.dart';

class Feed extends StatefulWidget {
  List<PostModels> data;
  var index;
  Feed({Key? key,required this.index,required this.data});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  AuthController _auth=AuthController();
bool saved=false;
  Stream<ProfileModels> getFeed(){
   return FirebaseFirestore.instance.collection(Constants.userCollections).doc(widget.data[widget.index].id)
        .snapshots().map((event) => ProfileModels.fromJson(event.data()!));
  }

  @override
  void initState() {

    setState(() {
      (profile_models?.saved??[]).contains(widget.data[widget.index].postId)?saved=true:saved=false;
    });

    super.initState();
  }

  TextEditingController comments=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getFeed(),
      builder: (context, snapshot) {
        ProfileModels? postData=snapshot.data;
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          height: height*.67,
          width: width,
          // color: Colors.blue,
          decoration: BoxDecoration(color: Colors.black,),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 10,),
                  CircleAvatar(
                    backgroundImage: NetworkImage(postData?.profile.toString()??''),
                  ),
                  SizedBox(width: 10,),
                  InkWell(
                      onTap: (){
                        if(postData?.id!=loginId) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                OthersProfile(data: postData!),));
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                MyProfile(),));
                        }
                      },
                      child: Text(postData?.name.toString()??'',style: TextStyle(fontSize: 16,color: Colors.white))),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: height*0.5,
                    width: width*0.99,
                    child: InteractiveViewer(child: Image(image: CachedNetworkImageProvider(widget.data[widget.index].post??''))),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                        height: height*0.084,
                        width: width,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                Text("${postData?.name}  ${widget.data[widget.index].description}",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 20,),
                                InkWell(
                                  onTap: (){
                                    if (widget.data[widget.index].likes.contains(
                                        loginId)) {

                                      FirebaseFirestore.instance
                                          .collection(
                                          Constants.userCollections)
                                          .doc(postData?.id).collection(Constants.myposts).doc(widget.data[widget.index].postId)
                                          .update({'likes':FieldValue.arrayRemove([loginId])});

                                    }



                                    else {

                                      FirebaseFirestore.instance
                                          .collection(
                                          Constants.userCollections)
                                          .doc(postData?.id).collection(Constants.myposts).doc(widget.data[widget.index].postId)
                                          .update({'likes':FieldValue.arrayUnion([loginId])});
                                    }

                                  },
                                    child: Icon(widget.data[widget.index].likes.contains(loginId)?Icons.favorite:Icons.favorite_border,size: 30,color: Colors.white,)),
                                SizedBox(width: 15,),
                                InkWell(
                                  onTap: (){
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30)
                                        )
                                      ),
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Divider(indent: 180,endIndent: 180,thickness: 5,color: Colors.black,),
                                              Container(
                                                alignment: Alignment.center,
                                                height: height*0.05,
                                                width: width,
                                                child: Text('Comments',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                                              ),
                                              Container(
                                                height: height*0.4355,
                                                width: width,
                                                child: StreamBuilder(
                                                  stream: FirebaseFirestore.instance.collection(Constants.userCollections).doc(postData?.id).collection(Constants.myposts)
                                                      .doc(widget.data[widget.index].postId).collection(Constants.mycomments).snapshots().map((event) => event.docs.map((e) => CommentModels.fromJson(e.data())).toList()),
                                                  builder: (context, snapshot) {
                                                    List<CommentModels>? data=snapshot.data;
                                                    return ListView.builder(
                                                      physics: BouncingScrollPhysics(),
                                                      itemCount: data?.length,
                                                        itemBuilder: (context, index) {
                                                          return StreamBuilder<List<ProfileModels>>(
                                                            stream: FirebaseFirestore.instance.collection(Constants.userCollections).where('id',isEqualTo: data?[index].id).snapshots().map((event) => event.docs.map((e) => ProfileModels.fromJson(e.data())).toList()),
                                                            builder: (context, snapshot) {
                                                              if(!snapshot.hasData || snapshot.hasError){
                                                                return Center(child: CircularProgressIndicator(),);

                                                              }
                                                              List<ProfileModels>? userdata=snapshot.data;
                                                              return ListTile(
                                                                onLongPress: (){
                                                                  if(widget.data[widget.index].id==loginId){
                                                                    showDialog(context: context, builder: (context) => AlertDialog(
                                                                      title: Text("Delete Comment"),
                                                                      content: Text('Are you sure you want to delete this comment?'),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text('Cancel')),
                                                                        TextButton(
                                                                            onPressed: () async {
                                                                              await FirebaseFirestore.instance.collection(Constants.userCollections).doc(postData?.id).collection(Constants.myposts).
                                                                              doc(widget.data[widget.index].postId).collection(Constants.mycomments).doc(data?[index].commentId).delete();
                                                                              setState(() {

                                                                              });
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text('Delete'))
                                                                      ],
                                                                    ),);
                                                                  }
                                                                  if(data?[index].id==loginId){
                                                                    showDialog(context: context, builder: (context) => AlertDialog(
                                                                      title: Text("Delete Comment"),
                                                                      content: Text('Are you sure you want to delete this comment?'),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text('Cancel')),
                                                                        TextButton(
                                                                            onPressed: () async {
                                                                              await FirebaseFirestore.instance.collection(Constants.userCollections).doc(postData?.id).collection(Constants.myposts).
                                                                              doc(widget.data[widget.index].postId).collection(Constants.mycomments).doc(data?[index].commentId).delete();
                                                                              setState(() {

                                                                              });
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text('Delete'))
                                                                      ],
                                                                    ),);
                                                                  }
                                                                },
                                                                leading: CircleAvatar(
                                                                  backgroundImage: CachedNetworkImageProvider(userdata?[0].profile??''),
                                                                ),
                                                                title: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(userdata?[0].name??'',style: TextStyle(fontSize: 12),),
                                                                    Text(data?[index].comment??''),
                                                                  ],
                                                                ),
                                                                  subtitle: Row(
                                                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      SizedBox(width: 10,),
                                                                      Text('View replies',style: TextStyle(fontSize: 12),),
                                                                      SizedBox(width: 60,),
                                                                      Text("Reply",style: TextStyle(fontSize: 12),),
                                                                      SizedBox(width: 10,)
                                                                    ],
                                                                  ),
                                                                trailing: Icon(Icons.favorite_border),
                                                              );
                                                            }
                                                          );
                                                        },);
                                                  }
                                                ),
                                              ),
                                              Padding(
                                                padding: MediaQuery.of(context).viewInsets,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: CachedNetworkImageProvider(profile_models?.profile??''),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                      height: height*.058,
                                                      width: width*.75,
                                                      child: TextFormField(
                                                        controller: comments,
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                            hintText: 'Add a comment...',
                                                            labelStyle: TextStyle(color: Colors.red),
                                                          suffix: InkWell(
                                                            onTap: () async {
                                                              var cdata=CommentModels(comment: comments.text, commentDate: Timestamp.now(), id: loginId, commentId: '');
                                                              await FirebaseFirestore.instance.collection(Constants.userCollections).doc(postData?.id).collection(Constants.myposts).doc(widget.data[widget.index].postId).collection(Constants.mycomments).add(cdata.toJson()).then((value) async {
                                                                comment_models= await _auth.getComment(postData!.id,widget.data[widget.index].postId,value.id);
                                                                var updid=comment_models!.copyWith(commentId: value.id);
                                                                value.update(updid.toJson());
                                                                comments.clear();
                                                                setState(() {

                                                                });
                                                              });
                                                            },
                                                            child: Text('Post',style: TextStyle(color: CupertinoColors.systemBlue,fontWeight: FontWeight.bold),),
                                                          )
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                    child: Icon(FontAwesomeIcons.comment,color: Colors.white,)),
                                SizedBox(width: 15,),
                                Icon(FontAwesomeIcons.paperPlane,color: Colors.white,),
                                SizedBox(width: width*0.55,),
                                InkWell(
                                    onTap: () async {
                                      //
                                      // setState(() {
                                      //
                                      // });

                                      profile_models=await _auth.getUser(loginId);
                                      if((profile_models?.saved??[]).contains(widget.data[widget.index].postId)){

                                        // FirebaseFirestore.instance
                                        //     .collection(
                                        //     Constants.userCollections)
                                        //     .doc(loginId)
                                        //     .update({'saved':FieldValue.arrayRemove([widget.data[widget.index].postId])});

                                        profile_models=await _auth.getUser(loginId);
                                        profile_models!.saved.remove(widget.data[widget.index].postId);
                                        var upddata=profile_models?.copyWith(saved: profile_models?.saved);
                                        profile_models!.reference!.update(upddata!.toJson());

                                        setState(() {
                                          saved=false;
                                        });


                                      }
                                      else{

                                        // FirebaseFirestore.instance
                                        //     .collection(
                                        //     Constants.userCollections)
                                        //     .doc(loginId)
                                        //     .update({'saved':FieldValue.arrayUnion([widget.data[widget.index].postId])});

                                        profile_models=await _auth.getUser(loginId);
                                        profile_models!.saved.add(widget.data[widget.index].postId);
                                        var upddata=profile_models?.copyWith(saved: profile_models?.saved);
                                        profile_models!.reference!.update(upddata!.toJson());
                                        setState(() {
                                          saved=true;
                                        });


                                      }
                                    },
                                    child: Icon(saved?CupertinoIcons.bookmark_fill:CupertinoIcons.bookmark,color: Colors.white,)),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Likes(index: widget.index,data: widget.data,),));
                                  },
                                    child: Text('Liked by ${widget.data[widget.index].likes.length} people',style: TextStyle(color: Colors.white),))
                              ],
                            )
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },);
  }
}
