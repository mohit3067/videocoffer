import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'videodetail_screen.dart';
import 'package:videocoffer/utils/provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchedUsername = '';
  List<Map<String, dynamic>> searchedUserVideos = [];
    

  void handleSearch() async {
    try {
      final userProfilesRef = FirebaseFirestore.instance.collection('userProfiles');
      final FsearchedUsername = searchedUsername.toLowerCase();
      final querySnapshot = await userProfilesRef.where('username'.toLowerCase(), isEqualTo: FsearchedUsername).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userId = querySnapshot.docs[0].id;
        final videosRef = FirebaseFirestore.instance.collection('videos');
        final userVideosSnapshot = await videosRef.where('userId', isEqualTo: userId).get();
        final videos = userVideosSnapshot.docs.map((doc) => doc.data()).toList();
        setState(() {
          searchedUserVideos = videos;
        });
      } else {
        setState(() {
          searchedUserVideos = [];
        });
      }
    } catch (error) {
      print('Error searching for user and videos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
      final userProvider = Provider.of<UserProvider>(context);
  final userdata = userProvider.userProfile;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Search')),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onEditingComplete: () => handleSearch(),
                onChanged: (value) => setState(() => searchedUsername = value),
                decoration: InputDecoration(labelText: 'Enter username'),
              ),
            
              Expanded(
                child: ListView.builder(
                  itemCount: searchedUserVideos.length,
                  itemBuilder: (context, index) {
                    final video = searchedUserVideos[index];
                    return ListTile(
                                title: Text(video['title']),
                                subtitle: Text(video['description']),
                                leading: Image.network(userdata!.profileImage),
                                trailing: Text(userdata.username),
                                  onTap: () {
                                  Future.delayed(Duration.zero,(){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoDetailScreen(
                                videoTitle: video['title'],
                                videoDescription: video['description'],
                                profileImage: userdata.profileImage,
                                videoCategory: video['category'],
                                username: userdata.username,
                                videoDate: video['publicationDate'],
                                videoLocation: video['location'],
                                videoUrl: Uri.parse(video['videoUrl']),
                              ),));
                              });}
                              );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}