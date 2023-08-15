


import 'package:cloud_firestore/cloud_firestore.dart';


 ProfileModels? profile_models;

class ProfileModels{
  String name;
  String profile;
  String email;
  String id;
  String phone;
  Timestamp createTime;
  Timestamp loginTime;
  List following;
  List followers;
  List saved;
  DocumentReference? reference;

  ProfileModels( {
     required this.name,
    required this.profile,
    required this.email,
    required this.id,
    required this.phone,
    required this.createTime,
    required this.loginTime,
    required this.following,
    required this.followers,
    required this.saved,
    this.reference

  });
  ProfileModels copyWith({
    String? name,
    String? profile,
    String? email,
    String? id,
    String? phone,
    Timestamp? createTime,
    Timestamp? loginTime,
    List? following,
    List? followers,
    List? saved
  })=>

      ProfileModels(
        loginTime: loginTime ?? this.loginTime,
        createTime: createTime ?? this.createTime,
        name: name ?? this.name,
        email: email ?? this.email,
        profile: profile ?? this.profile,
        id: id ?? this.id,
        phone: phone ?? this.phone,
        followers: followers ?? this.followers,
        following: following ?? this.following,
          saved: saved ?? this.saved,
        reference: reference?? this.reference
      );

  factory ProfileModels.fromJson(Map<String,dynamic> json)=>ProfileModels(
      name:json['name'],
      email:json['email'],
      profile:json['profile'],
      id:json['id'],
      phone:json['phone'],
      createTime:json['createTime'],
      loginTime:json['loginTime'],
     following: json['following'],
     followers: json['followers'],
          saved: json['saved'],
    reference: json['reference']

  );
  Map<String,dynamic> toJson() => {
    'name':name,
    'email':email,
    'profile':profile,
    'id':id,
    'phone':phone,
    'createTime':createTime,
    'loginTime':loginTime,
    'followers':followers,
    'following':following,
    'saved':saved,
    'reference':reference
  };


}

PostModels? post_models;

class PostModels{
  String post;
  Timestamp uploadTime;
  String id;
  List likes;
  String postId;
  String description;

  PostModels( {
    required this.post,
    required this.uploadTime,
    required this.id,
    required this.likes,
    required this.postId,
    required this.description

  });
  PostModels copyWith({
    String? post,
    Timestamp? uploadTime,
    String? id,
    List? likes,
    String? postId,
    String? description
  })=>

      PostModels(
          post: post ?? this.post,
          uploadTime: uploadTime ?? this.uploadTime,
          id: id ?? this.id,
          likes: likes ?? this.likes,
          postId: postId ?? this.postId,
          description: description ?? this.description
      );

  factory PostModels.fromJson(Map<String,dynamic> json)=>PostModels(
      post:json['post'],
      uploadTime:json['uploadTime'],
      id:json['id'],
      likes:json['likes'],
      postId: json['postId'],
    description: json['description']


  );
  Map<String,dynamic> toJson() => {
    'post':post,
    'uploadTime':uploadTime,
    'likes':likes,
    'id':id,
    'postId':postId,
    'description':description
  };


}


CommentModels? comment_models;

class CommentModels{
  String comment;
  Timestamp commentDate;
  String id;
  String commentId;

  CommentModels( {
    required this.comment,
    required this.commentDate,
    required this.id,
    required this.commentId

  });
  CommentModels copyWith({
    String? comment,
    Timestamp? commentDate,
    String? id,
    String? commentId
  })=>

      CommentModels(
          comment: comment ?? this.comment,
          commentDate: commentDate ?? this.commentDate,
          id: id ?? this.id,
          commentId: commentId ?? this.commentId,

      );

  factory CommentModels.fromJson(Map<String,dynamic> json)=>CommentModels(
      comment:json['comment'],
      commentDate:json['commentDate'],
      id:json['id'],
      commentId:json['commentId'],


  );
  Map<String,dynamic> toJson() => {
    'comment':comment,
    'commentDate':commentDate,
    'id':id,
    'commentId':commentId,
  };


}