import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTrackedProducts(context) {
    User currentUser = Provider.of<User>(context);
    String uid = currentUser.uid;
    Stream<QuerySnapshot> productsCollection =
        _db.collection('users').doc(uid).collection('products').snapshots();

    return productsCollection;
  }
}
