import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:price_tracker/services/auth.dart';
import 'package:price_tracker/services/firestore.dart';
import 'package:price_tracker/screens/home/components/product.dart';
import 'package:price_tracker/screens/home/components/add_product_sheet.dart';

class ProductList extends StatelessWidget {
  final AuthService _auth = AuthService();
  final FirestoreService _db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => AddProductSheet());
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: _auth.loggedIn
          ? StreamBuilder<QuerySnapshot>(
              stream: _db.getTrackedProducts(context),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(15.0),
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return ProductListItem(document.id);
                  }).toList(),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
