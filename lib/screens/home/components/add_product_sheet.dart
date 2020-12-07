import 'package:flutter/material.dart';
import 'package:price_tracker/constants.dart';
import 'package:price_tracker/services/product_fetch.dart';
import 'package:price_tracker/services/firestore.dart';

class AddProductSheet extends StatefulWidget {
  @override
  _AddProductSheetState createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final FirestoreService _firestoreService = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductModel productModel = ProductModel();
  String productSku;
  bool productIsValid;

  void _track() {
    if (_formKey.currentState.validate()) {
      _firestoreService.addTrackedProduct(productSku);
      Navigator.pop(context);
    }
  }

  String _validateSku(String enteredSku) {
    if (enteredSku.isEmpty) return 'Please enter a web code';
    if (!productIsValid) return 'This webcode is not valid';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Track a product',
              style: TextStyle(fontSize: 30.0, color: Colors.tealAccent),
            ),
            SizedBox(height: 15.0),
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: (value) => _validateSku(value),
              onChanged: (value) async {
                productSku = value;
                productIsValid =
                    await productModel.getProductData(value) != null
                        ? true
                        : false;
              },
              onFieldSubmitted: (_) => _track(),
              decoration: authFieldDecoration.copyWith(
                labelText: 'Web Code',
                hintText: '12345678',
              ),
            ),
            SizedBox(height: 15.0),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Track this product'),
              onPressed: () => _track(),
            ),
          ],
        ),
      ),
    );
  }
}
