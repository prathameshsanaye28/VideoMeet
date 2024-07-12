// ignore_for_file: non_constant_identifier_names, dead_code
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:videosdk/videosdk.dart';
import 'package:videosdk_flutter_example/models/user.dart';
import 'package:videosdk_flutter_example/resources/user_provider.dart';
import 'package:videosdk_flutter_example/screens/common/meeting_setup_screen.dart';
import 'package:videosdk_flutter_example/screens/common/user_profile_screen.dart';
import 'package:videosdk_flutter_example/widgets/common/stylish_clock.dart';
import '../conference-call/conference_meeting_screen.dart';
import '../../utils/api.dart';
import '../../widgets/common/joining_details/joining_details.dart';

import '../../constants/colors.dart';
import '../../utils/spacer.dart';
import '../../utils/toast.dart';
import '../one-to-one/one_to_one_meeting_screen.dart';

// Join Screen
class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  String _token = "";

  @override
  void initState() {
    super.initState();
    addData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await fetchToken(context);
      setState(() => _token = token);
    });
  }

  addData() async{
    UserProvider _userProvider = Provider.of(context, listen:false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
     final User user = Provider.of<UserProvider>(context).getUser;
    final maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VideoMeet",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile()));
            },
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
          ),
        ],
      ),
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(
                  color: Colors.white,
                  thickness: 3,
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi "+user.firstname+"!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "What do you want to do today?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                StylishTimeDisplay(),
                SizedBox(height: 40,),
                MaterialButton(
                  minWidth: maxWidth / 1.3,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.blue,
                  child: const Text("Create Meeting",
                      style: TextStyle(fontSize: 16)),
                  onPressed: () => _navigateToMeetingSetup(true),
                ),
                const VerticalSpacer(16),
                MaterialButton(
                  minWidth: maxWidth / 1.3,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.orange[700],
                  child: const Text("Join Meeting",
                      style: TextStyle(fontSize: 16)),
                  onPressed: () => _navigateToMeetingSetup(false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToMeetingSetup(bool isCreateMeeting) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeetingSetupScreen(
          token: _token,
          isCreateMeeting: isCreateMeeting,
        ),
      ),
    );
  }
}
