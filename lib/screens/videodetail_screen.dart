import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:videocoffer/utils/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class VideoDetailScreen extends StatefulWidget {
  final String videoTitle;
  final String videoDescription;
  final String profileImage;
  final String username;
  final String videoCategory;
  final String videoLocation;
  final Uri videoUrl;
  final Timestamp videoDate;

  VideoDetailScreen({
    required this.videoTitle,
    required this.videoDescription,
    required this.profileImage,
    required this.username,
    required this.videoCategory,
    required this.videoDate,
    required this.videoLocation,
    required this.videoUrl,
  });

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Timestamp timestamp = widget.videoDate;
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    final userProvider = Provider.of<UserProvider>(context);
    final userdata = userProvider.userProfile;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            border:  Border.all(color: const Color.fromARGB(255, 250, 211, 211),width: 5.0,),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Row(
                  children: [
              IconButton(onPressed: (){
              _controller.play();
                      }, icon: Icon(Icons.play_arrow)),
                      IconButton(onPressed: (){
              _controller.pause();
                      }, icon: Icon(Icons.pause))
                  ],
                ),
                Divider(height: 5,color: Colors.black,),
                ListTile(
                  leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userdata!.profileImage),
                ),
                 title: Text(widget.videoTitle),
                subtitle: Text(widget.videoDescription),
              trailing: Text(widget.videoCategory),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16,0,0,0),
                      child: Text(userdata.username,style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 45, 45, 45)),),
                    ),
                    Column(children: [
                      Text(widget.videoLocation),
                Text(formattedDate),
                    ],)
                  ],
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
