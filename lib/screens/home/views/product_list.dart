import 'package:flutter/material.dart';
import 'package:price_tracker/screens/home/components/product.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<int> skuList = <int>[14672700, 14584744];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(15.0),
        itemCount: skuList.length,
        itemBuilder: (BuildContext context, int index) {
          return Product(skuList[index]);
        });
  }
}
