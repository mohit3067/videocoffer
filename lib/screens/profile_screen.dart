import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:videocoffer/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      } else {
        print("No profile data found for the user.");
      }
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('profile')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userData != null
                ? CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(userData!['profileImage']),
                  )
                : CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UserName',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.fromLTRB(7, 13, 0, 0),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color.fromARGB(255, 165, 193, 207)),
                    child: Text(
                      userData != null
                          ? userData!['username']
                          : 'user not found',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'mobile no.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.fromLTRB(7, 13, 0, 0),
                    height: 50,
                    width: double.infinity,
                    child: Text(
                      auth.currentUser != null
                          ? auth.currentUser!.phoneNumber.toString()
                          : '+911234567890',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color.fromARGB(255, 165, 193, 207)),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: signOut,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Text(
                    'log-out',
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
