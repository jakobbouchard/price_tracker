import 'package:flutter/material.dart';
import 'package:price_tracker/services/product_fetch.dart';

class Product extends StatefulWidget {
  Product(int this.sku);
  final sku;

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  ProductModel product = ProductModel();
  bool fetchingData = false;
  String productName;
  double regularPrice;
  double salePrice;
  String message;

  void getData(int sku) async {
    fetchingData = true;
    try {
      var data = await product.getProductData(sku);
      fetchingData = false;

      setState(() {
        productName = data['name'];
        regularPrice = data['regularPrice'];
        salePrice = data['salePrice'];
        message = regularPrice != salePrice
            ? 'This product is on sale!'
            : 'This product is not on sale.';
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData(widget.sku);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              fetchingData
                  ? '???'
                  : 'Price $regularPrice, SalePrice $salePrice, productName $productName',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            Text(
              fetchingData ? '???' : '$message',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
