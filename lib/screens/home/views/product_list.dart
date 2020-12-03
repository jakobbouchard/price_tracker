import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:price_tracker/services/firestore.dart';
import 'package:price_tracker/screens/home/components/product.dart';

class ProductList extends StatelessWidget {
  final FirestoreService _db = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('Pressed add'),
        child: Icon(
          Icons.add,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.getTrackedProducts(context),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
      ),
    );
  }
}
