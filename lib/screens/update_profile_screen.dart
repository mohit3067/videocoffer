import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  bool isloading = false;
  String? imageUrl;
  XFile? image;
  
  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  void updateprofile() async {
    setState(() {
      isloading = true;
    });
    String username = usernameController.text;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('userProfiles').doc(uid).set({
      'username': username.toLowerCase(),
      'profileImage': imageUrl,
    });
    setState(() {
      isloading=false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('data updated')));
    });
  }

  void selectImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = file;
    });

    if (file == null) return;
    String uniqueName = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceroot =
        FirebaseStorage.instance.ref().child("images/");

    Reference referenceImageToUpload = referenceroot.child(uniqueName);
    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('update profile')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(File(image!.path)),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage('assets/user.png'),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {
                      selectImage();
                    },
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Color.fromARGB(255, 186, 182, 174),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: usernameController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.supervised_user_circle,
                    color: Colors.deepPurpleAccent,
                  ),
                  label: const Text("UserName"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.deepPurpleAccent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: updateprofile,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: isloading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : Text(
                          'Update',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  height: 65,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
