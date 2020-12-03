import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:price_tracker/services/product_fetch.dart';

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
                isOnSale ? 'En vente' : 'Prix régulier',
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

class ProductListItem extends StatefulWidget {
  ProductListItem(this.sku);
  final String sku;

  @override
  _ProductListItemState createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  ProductModel product = ProductModel();
  bool fetchingData = false;
  var data;

  void getData(String sku) async {
    fetchingData = true;
    try {
      data = await product.getProductData(sku);
      fetchingData = false;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  String _getProductThumbnail(String sku) {
    String baseUrl =
        'https://multimedia.bbycastatic.ca/multimedia/products/100x100';
    String firstThree = sku.substring(0, 3);
    String firstFive = sku.substring(0, 5);

    return '$baseUrl/$firstThree/$firstFive/$sku.jpg';
  }

  @override
  void initState() {
    super.initState();
    getData(widget.sku);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  child: fetchingData
                      ? null
                      : Image.network(
                          _getProductThumbnail(widget.sku),
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 0.0),
                    child: _ProductDescription(
                      name: fetchingData ? '???' : data['name'],
                      sku: fetchingData ? '???' : data['sku'],
                      isOnSale: fetchingData ? false : data['isProductOnSale'],
                      salePrice:
                          fetchingData ? '???' : data['salePrice'].toString(),
                      regularPrice: fetchingData
                          ? '???'
                          : data['regularPrice'].toString(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
