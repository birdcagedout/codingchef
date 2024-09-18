import 'package:get/get.dart';
import 'package:getx3/model/product.dart';

class ShoppingController extends GetxController {
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();

    fetchData();
  }


  void fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    var productData = [
      Product(id: 1, productName: 'Mouse', productDescription: 'Some descriptiuon on the product', price: 30),
      Product(id: 2, productName: 'Keyboard', productDescription: 'Some descriptiuon on the product', price: 40),
      Product(id: 3, productName: 'Monitor', productDescription: 'Some descriptiuon on the product', price: 620),
      Product(id: 4, productName: 'RAM', productDescription: 'Some descriptiuon on the product', price: 80),
      Product(id: 5, productName: 'Speaker', productDescription: 'Some descriptiuon on the product', price: 120.5),
    ];

    products.assignAll(productData);
  }
}