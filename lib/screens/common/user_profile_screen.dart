import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:videosdk_flutter_example/models/user.dart' as model;
import 'package:videosdk_flutter_example/resources/user_provider.dart';
import 'package:videosdk_flutter_example/screens/common/join_screen.dart';
import 'package:videosdk_flutter_example/screens/login_screen.dart';
import 'package:videosdk_flutter_example/utils/utils.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                _auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(
                Icons.logout,
                size: 30,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 120,
              ),
              SizedBox(
                height: 20,
              ),
              userprofile(user.firstname, "First Name", context),
              SizedBox(
                height: 5,
              ),
              userprofile(user.lastname, "Last Name", context),
              SizedBox(
                height: 5,
              ),
              userprofile(user.email, "Email", context),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => JoinScreen()));
                },
                child: Row(
                  children: [
                    Icon(Icons.keyboard_arrow_left,size: 30,color: Colors.black,),
                    SizedBox(width: 10,),
                    Text("Back to Home",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                  ],
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(232, 0, 191, 255)),
                        fixedSize: MaterialStatePropertyAll(Size(300,60)),
                        
                        ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
