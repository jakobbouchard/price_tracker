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
  bool fetchingData = false;
  String productName;
  double regularPrice;
  double salePrice;
  String message;

  void getData(int productSKU) async {
    fetchingData = true;
    try {
      var productData = await product.getProductData(productSKU);
      fetchingData = false;

      setState(() {
        productName = productData['name'];
        regularPrice = productData['regularPrice'];
        salePrice = productData['salePrice'];
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
    getData(widget.productSKU);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
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
      ),
    );
  }
}
