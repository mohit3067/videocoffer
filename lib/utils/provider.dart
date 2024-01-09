import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

class HomeState extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}

class UserProfile {
  final String username;
  final String profileImage;

  UserProfile({
    required this.username,
    required this.profileImage,
  });
}

class UserProvider extends ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  void setUserProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }
}

class VideoProvider extends ChangeNotifier {
  bool _isRecording = false;
  String _videoUrl = '';

  bool get isRecording => _isRecording;
  String get videoUrl => _videoUrl;

  void startRecording() {
    _isRecording = true;
    notifyListeners();
  }

  void stopRecording() {
    _isRecording = false;
    notifyListeners();
  }

  void setVideoUrl(String url) {
    _videoUrl = url;
    notifyListeners();
  }
}