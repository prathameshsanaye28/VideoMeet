
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:videosdk_flutter_example/models/user.dart'as model;
import 'package:videosdk_flutter_example/resources/storage_methods.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid!).get();

    return model.User.fromSnap(snap);
  }


  //signup user
  Future<String> signUpUser({
    required String email,
    required String firstname,
    required String password,
    required String lastname,
    required Uint8List file,    
  })async{
    String res = "Some error occurred";
    try{

      if(email.isNotEmpty||password.isNotEmpty||lastname.isNotEmpty||firstname.isNotEmpty||file!=null){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        //add user to database
        model.User user = model.User(
          uid: cred.user!.uid,
          email: email,
          photoUrl: photoUrl,
          firstname: firstname,
          lastname: lastname,
          );


       await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'Success';
      } 

    } on FirebaseAuthException catch(err){
      if(err.code == 'invalid-email'){
        res = 'The email is invalid';
      }
      if(err.code == 'weak-password'){
        res = 'Password is weak';
      }
    }
    
    catch(err){
      res = err.toString();
    }
    return res;
  }


  //logging in
  Future<String> loginUser({
    required String email,
    required String password
  })async{
    String res = 'Some error occured';
    try{
      if(email.isNotEmpty || password.isNotEmpty)
      {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }
      else{
        res = 'Please enter all details';
      }
    }
    catch(err){
      res = err.toString();
    }
    return res;
  }


}