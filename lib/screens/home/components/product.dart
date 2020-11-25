import 'package:flutter/material.dart';
import 'package:price_tracker/services/product_fetch.dart';

class Product extends StatefulWidget {
  Product(int this.productSKU);
  final productSKU;

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  ProductModel product = ProductModel();
  dynamic productData;
  double regularPrice;
  double salePrice;
  String message;

  void updateUI(int productSKU) async {
    productData = await product.getProductData(productSKU);
    setState(() {
      regularPrice = productData['regularPrice'];
      salePrice = productData['salePrice'];
      message = regularPrice != salePrice
          ? 'This product is on sale!'
          : 'This product is not on sale.';
    });
  }

  @override
  void initState() {
    super.initState();
    updateUI(widget.productSKU);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Column(
            children: <Widget>[
              Text(
                'Price $regularPrice, SalePrice $salePrice, productName ${productData["name"]}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
