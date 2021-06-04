import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //giriş yap fonksiyonu
  Future<User> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  //çıkış yap fonksiyonu
  signOut() async {
    return await _auth.signOut();
  }

  // userid fonksiyonu
  String getUserid() {
    return _auth.currentUser.uid;
  }

  //kayıt ol fonksiyonu
  Future<User> createPerson(String name, String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore.collection("Person").doc(user.user.uid).set(
        {'userName': name, 'email': email, 'clubs': FieldValue.arrayUnion([])});

    return user.user;
  }

  Future<User> updatePerson(String name) async {
    await _firestore
        .collection("Person")
        .doc(getUserid())
        .update({'userName': name});
  }
}
