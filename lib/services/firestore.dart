import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:price_tracker/services/auth.dart';

class FirestoreService {
  final AuthService _auth = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns the current user's tracked products from Firestore
  Stream<QuerySnapshot> getTrackedProducts() {
    User currentUser = _auth.currentUser;
    String uid = currentUser.uid;
    Stream<QuerySnapshot> productsCollectionStream = _db
        .collection('users')
        .doc(uid)
        .collection('products')
        .orderBy('createdAt')
        .snapshots();

    return productsCollectionStream;
  }

  /// Takes a Best Buy Canada SKU/Web Code as an input and adds the product to
  /// the current user's tracked products in Firestore
  void addTrackedProduct(String productSku) {
    User currentUser = _auth.currentUser;
    String uid = currentUser.uid;
    CollectionReference trackedProducts =
        _db.collection('users').doc(uid).collection('products');

    trackedProducts
        .doc(productSku)
        .set({
          'createdAt': FieldValue.serverTimestamp(),
        })
        .then((value) => print("Product tracked"))
        .catchError((error) => print("Failed to add product: $error"));
  }
}
