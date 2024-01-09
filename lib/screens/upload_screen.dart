import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
class RecordVideoScreen extends StatefulWidget {
  @override
  _RecordVideoScreenState createState() => _RecordVideoScreenState();
}

class _RecordVideoScreenState extends State<RecordVideoScreen> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final auth = FirebaseAuth.instance;
  late String _videoUrl;
  late Position _currentPosition;
  late VideoPlayerController _videoController;
  String? locationString = '';
  bool _isPlaying = false;
  bool _isloading = false;

 

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if( permission== LocationPermission.denied){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('location denied')));
    }
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('location granted')));
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    _videoController = VideoPlayerController.asset('') 
      ..initialize().then((_) {
        setState(() {});
  });}

  Future<void> _recordVideo() async {
   final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _videoController = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
             _videoController.addListener(() {
            setState(() {
              
            });
          });
            _videoController.play().then((_) {
              setState(() {
                _isPlaying = true;
              });
            });
        _videoUrl = pickedFile.path;
          });
      });
    }
  }



  Future<void> _uploadVideo() async {
    setState(() {
      _isloading = true;
    });
    final title = _titleController.text;
    final category = _categoryController.text;
    final description = _descriptionController.text;
  User user = auth.currentUser!;
  final userId = user.uid;
    final placemarks = await placemarkFromCoordinates(
    _currentPosition.latitude,
    _currentPosition.longitude,
  );

  if (placemarks.isNotEmpty) {
    final firstPlacemark = placemarks.first;
    final locationName = "${firstPlacemark.locality}, ${firstPlacemark.country}";
    setState(() {
      locationString = locationName;
    });
  } else {
    setState(() {
      locationString = "Location not found";
    });
  }

    final storageRef = FirebaseStorage.instance.ref().child("videos/$title.mp4");
    final uploadTask = storageRef.putFile(File(_videoUrl));
    final uploadTaskSnapshot = await uploadTask;

    final videoReference = FirebaseFirestore.instance.collection('videos');
    await videoReference.add({
      'title': title,
      'category': category,
      'location': locationString,
      'description': description,
      'videoUrl': await uploadTaskSnapshot.ref.getDownloadURL(),
      'userId' : userId,
      'publicationDate': FieldValue.serverTimestamp(),
    });
  setState(() {
    _isloading = false;
  });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Video uploaded successfully'))).closed.then((_) => _resetScreen());
  }

  void _resetScreen() {
  setState(() {
    _titleController.clear();
    _categoryController.clear();
    _descriptionController.clear();
    _videoController.dispose();
    _videoController = VideoPlayerController.asset('')
      ..initialize().then((_) {
        setState(() {});
      });
    locationString = '';
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Upload Video'))),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
              TextField(controller: _categoryController, decoration: InputDecoration(labelText: 'Category')),
              TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
              SizedBox(height: 20,),
              Text("Locaton : ${locationString.toString()}"),
 SizedBox(height: 20,),
               _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: Column(
                      children: [
                        Expanded(child: VideoPlayer(_videoController)),
                       Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    IconButton(
      icon: Icon(
        _isPlaying ? Icons.pause : Icons.play_arrow,
        size: 32,
        color: Color.fromARGB(255, 5, 15, 158),
      ),
      onPressed: () {
        setState(() {
          if (_isPlaying) {
            _videoController.pause();
          } else {
            _videoController.play();
          }
          _isPlaying = !_isPlaying;
        });
      },
    ),
    
    IconButton(
      icon: Icon(
        Icons.cancel,
        size: 32,
        color: Color.fromARGB(255, 31, 8, 199),
      ),
      onPressed: () {
        setState(() {
          _videoController.dispose();
          _videoController = VideoPlayerController.asset('')
            ..initialize().then((_) {
              setState(() {});
            });
          _isPlaying = false;
          _titleController.clear();
          _categoryController.clear();
          _descriptionController.clear();
          locationString = '';
        });
      },
    ),
  ],
)

                      ],
                    ),
                  )
                : Container(),
              ElevatedButton(onPressed: _recordVideo, child: Text('Record Video')),
              ElevatedButton(onPressed: _uploadVideo, child: _isloading== false ? Text('Upload Video'): Expanded(child: CircularProgressIndicator(color: Colors.white,))),
            ],
          ),
        ),
      ),
    );
  }
}
