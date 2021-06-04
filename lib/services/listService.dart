import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_club_project/services/authService.dart';

class ListService {
  AuthService _authService = AuthService();
  final clubCollection =
      FirebaseFirestore.instance.collection('clubs').snapshots();

  addClub(DocumentReference ref) async {
    DocumentReference docref = FirebaseFirestore.instance
        .collection('Person')
        .doc(_authService.getUserid());
    DocumentSnapshot doc = await docref.get();
    List clubs = (doc.data() as Map)['clubs'];
    if (clubs == null) {
      docref.update({
        'clubs': FieldValue.arrayUnion([ref.id])
      });
    } else if (clubs.contains(ref.id) == true) {
      docref.update({
        'clubs': FieldValue.arrayRemove([ref.id])
      });
    } else {
      docref.update({
        'clubs': FieldValue.arrayUnion([ref.id])
      });
    }
  }
}
