import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_club_project/services/authService.dart';

class ChatService {
  AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage(DocumentReference ref, String mesaj) async {
    await FirebaseFirestore.instance
        .collection('clubs')
        .doc(ref.id)
        .collection('chat')
        .add({
      'sender': _authService.getUserid(),
      'messages': mesaj,
      'time': DateTime.now(),
    });
  }
}
