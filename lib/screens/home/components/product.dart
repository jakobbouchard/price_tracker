import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:price_tracker/services/product_fetch.dart';
import 'package:price_tracker/services/firestore.dart';

class _ProductDescription extends StatelessWidget {
  _ProductDescription({
    Key key,
    this.name,
    this.sku,
    this.isOnSale,
    this.salePrice,
    this.regularPrice,
  }) : super(key: key);

  final String name;
  final String sku;
  final bool isOnSale;
  final String salePrice;
  final String regularPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$name',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 2.0)),
            Text(
              '$sku',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                isOnSale ? 'On sale' : 'Not on sale',
                style: TextStyle(
                  fontSize: 12.0,
                  color: isOnSale ? Colors.red : Colors.white,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '\$$regularPrice',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: isOnSale ? Colors.red : Colors.white,
                        decoration: isOnSale
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    TextSpan(
                      text: isOnSale ? ' \$$salePrice' : null,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: isOnSale ? Colors.red : Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  _ProductCard(this.data);
  final dynamic data;

  final FirestoreService _firestoreService = FirestoreService();

  String _getProductThumbnail(String sku) {
    String baseUrl =
        'https://multimedia.bbycastatic.ca/multimedia/products/100x100';
    String firstThree = sku.substring(0, 3);
    String firstFive = sku.substring(0, 5);

    return '$baseUrl/$firstThree/$firstFive/$sku.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      key: Key(data['sku']),
      onDismissed: (direction) {
        _firestoreService.removeTrackedProduct(data['sku']);

        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("Product ${data['sku']} deleted")));
      },
      child: Card(
        child: InkWell(
          splashColor: Colors.tealAccent.withAlpha(50),
          onTap: () async {
            String url = data['productUrl'];
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 90,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(
                      _getProductThumbnail(data['sku']),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 0.0),
                      child: _ProductDescription(
                        name: data['name'],
                        sku: data['sku'],
                        isOnSale: data['isProductOnSale'],
                        salePrice: data['salePrice'].toString(),
                        regularPrice: data['regularPrice'].toString(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  ProductListItem(
    this.sku,
  );
  final String sku;

  final ProductModel product = ProductModel();

  @override
  Widget build(BuildContext context) {
    final Future<dynamic> productData = product.getProductData(sku);

    return FutureBuilder(
      future: productData,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 90,
                child: Center(
                  child: Text('Something went wrong'),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return _ProductCard(snapshot.data);
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 90,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}
