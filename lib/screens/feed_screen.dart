import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:videocoffer/screens/videodetail_screen.dart';
import 'package:provider/provider.dart';
import '../utils/provider.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('VideoCoffer')),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('videos').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final videoDocs = snapshot.data!.docs;
            return Expanded(
              child: ListView.builder(
                itemCount: videoDocs.length,
                itemBuilder: (context, index) {
                  final videoData = videoDocs[index].data() as Map<String, dynamic>;
                  final videoTitle = videoData['title'];
                  final videoDescription = videoData['description'];
                  final userId = videoData['userId'];
                  final videoCategory = videoData['category'];
                  final videoLocation = videoData['location'];
                  final videoUrl = videoData['videoUrl'].toString();
                  final videoDate = videoData['publicationDate'];
            
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('userProfiles')
                        .doc(userId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      final userProfile =
                          userSnapshot.data!.data() as Map<String, dynamic>?;
            
                      if (userSnapshot.hasError || userSnapshot.data == null || userProfile == null) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(videoTitle),
                              subtitle: Text(videoDescription),
                              leading: Icon(Icons.error),
                              trailing: Text("User Data Not Available"),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoDetailScreen(
                                videoTitle: videoTitle,
                                videoDescription: videoDescription,
                                profileImage: 'assets/user.png',
                                videoCategory: videoCategory,
                                username: 'USER NOT FOUND',
                                videoDate: videoDate,
                                videoLocation: videoLocation,
                                videoUrl: Uri.parse(videoUrl),
                              ),));
                              },
                            ),
                            Divider(),
                          ],
                        );
                      }
            
                      final userProfileData = userSnapshot.data!.data() as Map<String, dynamic>;
                      final userdata = UserProfile(
                        username: userProfileData['username'],
                        profileImage: userProfileData['profileImage'],
                      );
            
            final userProvider = Provider.of<UserProvider>(context, listen: false);
                      userProvider.setUserProfile(userdata);
                      return Column(
                        children: [
                          Column(
                            children: [
                              
                              ListTile(
                                title: Text(videoTitle),
                                subtitle: Text(videoDescription),
                                leading: Image.network(userdata.profileImage),
                                trailing: Text(userdata.username),
                                  onTap: () {
                                  Future.delayed(Duration.zero,(){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoDetailScreen(
                                videoTitle: videoTitle,
                                videoDescription: videoDescription,
                                profileImage: userdata.profileImage,
                                videoCategory: videoCategory,
                                username: userdata.username,
                                videoDate: videoDate,
                                videoLocation: videoLocation,
                                videoUrl: Uri.parse(videoUrl),
                              ),));
                              });}
                              ),
                            ],
                          ),
                          Divider(height: 5.0,color: Color.fromARGB(255, 124, 122, 119),)
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
    ),
        ],
      ),
    );
  }
}


