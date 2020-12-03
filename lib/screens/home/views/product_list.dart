import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:price_tracker/services/firestore.dart';
import 'package:price_tracker/screens/home/components/product.dart';

class ProductList extends StatelessWidget {
  final FirestoreService _db = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.getTrackedProducts(context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        }

        return ListView(
          padding: const EdgeInsets.all(15.0),
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return Card(
              child: ListTile(
                leading: Image(
                  image: NetworkImage(document.data()['productImage']),
                ),
                title:
                    Text('Prix de vente : ${document.data()['lastSalePrice']}'),
                subtitle: Text(
                    'Prix régulier : ${document.data()['lastRegularPrice']}'),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
