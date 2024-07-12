import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';
import 'package:videosdk_flutter_example/constants/colors.dart';
import 'package:videosdk_flutter_example/screens/conference-call/conference_meeting_screen.dart';
import 'package:videosdk_flutter_example/utils/api.dart';
import 'package:videosdk_flutter_example/utils/toast.dart';

class MeetingSetupScreen extends StatefulWidget {
  final String token;
  final bool isCreateMeeting;

  const MeetingSetupScreen({Key? key, required this.token, required this.isCreateMeeting}) : super(key: key);

  @override
  _MeetingSetupScreenState createState() => _MeetingSetupScreenState();
}

class _MeetingSetupScreenState extends State<MeetingSetupScreen> {
  bool isMicOn = true;
  bool isCameraOn = true;
  CustomTrack? cameraTrack;
  RTCVideoRenderer? cameraRenderer;
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCameraPreview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Camera Preview
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
                child: SizedBox(
                  height: 300,
                  width: 200,
                  child: cameraPreviewWidget(),
                ),
              ),
              // Mic and Camera controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  micButton(),
                  const SizedBox(width: 20),
                  cameraButton(),
                ],
              ),
              const SizedBox(height: 20),
              // Display Name Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: TextField(
                  controller: displayNameController,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Meeting ID Input (only for joining)
              if (!widget.isCreateMeeting)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: TextField(
                    controller: meetingIdController,
                    decoration: InputDecoration(
                      hintText: "Enter meeting ID",
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Join/Create Button
              MaterialButton(
                minWidth: 200,
                height: 50,
                color: purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Text(widget.isCreateMeeting ? "Create Meeting" : "Join Meeting"),
                onPressed: () => _handleMeetingAction(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cameraPreviewWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        cameraRenderer != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: RTCVideoView(
                  cameraRenderer as RTCVideoRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              )
            : Container(
                decoration: BoxDecoration(color: black800, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text("Camera is turned off")),
              ),
      ],
    );
  }

  Widget micButton() {
    return ElevatedButton(
      onPressed: () => setState(() => isMicOn = !isMicOn),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: isMicOn ? Colors.white : red,
      ),
      child: Icon(isMicOn ? Icons.mic : Icons.mic_off, color: isMicOn ? grey : Colors.white),
    );
  }

  Widget cameraButton() {
    return ElevatedButton(
      onPressed: () {
        if (isCameraOn) {
          disposeCameraPreview();
        } else {
          initCameraPreview();
        }
        setState(() => isCameraOn = !isCameraOn);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: isCameraOn ? Colors.white : red,
      ),
      child: Icon(isCameraOn ? Icons.videocam : Icons.videocam_off, color: isCameraOn ? grey : Colors.white),
    );
  }

  void initCameraPreview() async {
    CustomTrack track = await VideoSDK.createCameraVideoTrack();
    RTCVideoRenderer render = RTCVideoRenderer();
    await render.initialize();
    render.setSrcObject(stream: track.mediaStream, trackId: track.mediaStream.getVideoTracks().first.id);
    setState(() {
      cameraTrack = track;
      cameraRenderer = render;
    });
  }

  void disposeCameraPreview() {
    cameraTrack?.dispose();
    setState(() {
      cameraRenderer = null;
      cameraTrack = null;
    });
  }

  void _handleMeetingAction() async {
    final displayName = displayNameController.text.isNotEmpty ? displayNameController.text : "Guest";
    if (widget.isCreateMeeting) {
      await createAndJoinMeeting(displayName);
    } else {
      final meetingId = meetingIdController.text;
      if (meetingId.isEmpty) {
        showSnackBarMessage(message: "Please enter a valid Meeting ID", context: context);
        return;
      }
      await joinMeeting(displayName, meetingId);
    }
  }

  Future<void> createAndJoinMeeting(String displayName) async {
    try {
      var meetingId = await createMeeting(widget.token);
      _navigateToMeetingScreen(meetingId, displayName);
    } catch (error) {
      showSnackBarMessage(message: error.toString(), context: context);
    }
  }

  Future<void> joinMeeting(String displayName, String meetingId) async {
    var validMeeting = await validateMeeting(widget.token, meetingId);
    if (validMeeting) {
      _navigateToMeetingScreen(meetingId, displayName);
    } else {
      showSnackBarMessage(message: "Invalid Meeting ID", context: context);
    }
  }

  void _navigateToMeetingScreen(String meetingId, String displayName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfereneceMeetingScreen(
          token: widget.token,
          meetingId: meetingId,
          displayName: displayName,
          micEnabled: isMicOn,
          camEnabled: isCameraOn,
        ),
      ),
    );
  }

  @override
  void dispose() {
    cameraTrack?.dispose();
    meetingIdController.dispose();
    displayNameController.dispose();
    super.dispose();
  }
}