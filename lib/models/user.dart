import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String email;
  final String photoUrl;
  final String firstname;
  final String lastname;
  final String uid;

  const User({
    required this.firstname,
    required this.email,
    required this.photoUrl,
    required this.lastname,
    required this.uid,
  });

  Map<String, dynamic> toJson()=>{
      'firstname': firstname,
      'uid': uid,
      'email': email,
      'lastname':lastname,
      'photoUrl': photoUrl,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;

    return User(
      firstname: snapshot['firstname'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],
      lastname: snapshot['lastname'],
    );
  }
}