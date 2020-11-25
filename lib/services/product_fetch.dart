import 'package:price_tracker/utils/networking.dart';

const String bestBuyCanadaURL = 'https://www.bestbuy.ca/api/v2/json/product';

class ProductModel {
  Future<dynamic> getProductData(int productSKU) async {
    NetworkHelper networkHelper =
        NetworkHelper('$bestBuyCanadaURL/$productSKU');
    var productData = await networkHelper.getData();
    // TODO: Remove these temporary prints
    print('Regular price: ${productData['regularPrice']}');
    print('Sale price: ${productData['salePrice']}');
    return productData;
  }
}
