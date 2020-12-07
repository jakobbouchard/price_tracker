import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:price_tracker/services/auth.dart';

class FirestoreService {
  final AuthService _auth = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTrackedProducts(context) {
    User currentUser = _auth.currentUser;
    String uid = currentUser.uid;
    Stream<QuerySnapshot> productsCollection = _db
        .collection('users')
        .doc(uid)
        .collection('products')
        .orderBy('createdAt')
        .snapshots();

    return productsCollection;
  }
}
