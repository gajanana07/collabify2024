import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(
      String uid, String name, String email, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
