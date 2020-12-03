import 'package:price_tracker/utils/networking.dart';

const String bestBuyCanadaURL = 'https://www.bestbuy.ca/api/v2/json/product';

class ProductModel {
  Future<dynamic> getProductData(String sku) async {
    NetworkHelper networkHelper = NetworkHelper('$bestBuyCanadaURL/$sku');
    try {
      return await networkHelper.getData();
    } catch (e) {
      print(e);
    }
  }
}
