import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBServices {
  static final _auth = FirebaseAuth.instance;
  static CollectionReference<Map<String, dynamic>> getDbTodos() {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .collection('to_dos');
  }
}
