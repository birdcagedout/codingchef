import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/shopping_controller.dart';
import '../controller/cart_controller.dart';


class ShoppingPage extends StatelessWidget {
  ShoppingPage({super.key});

  final shoppingController = Get.put(ShoppingController());
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: [
          // Column 안에 ListView 넣을 때는 Expanded로 감싸야 기대한대로 정상출력됨
          Expanded(
            flex: 40,
            child: GetX<ShoppingController>(
              builder: (controller) {
                return ListView.builder(
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(12),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${controller.products[index].productName}', style: TextStyle(fontSize: 24),),
                                    Text('${controller.products[index].productDescription}'),
                                  ],
                                ),
                                Text('\$${controller.products[index].price}', style: TextStyle(fontSize: 24),),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                cartController.addToItem(controller.products[index]);
                              },
                              child: Text('Add to cart', style: TextStyle(fontSize: 12),),
                              style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(90, 25),),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ),
          Expanded(
            flex: 10,
            child: Column(
              children: [
                GetX<CartController>(
                  builder: (controller) {
                    return Text('Total amount: \$${controller.totalPrice}', style: TextStyle(fontSize: 25, color: Colors.white,),);
                  }
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.shopping_cart),
        label: GetX<CartController>(
          builder: (controller) {
            return Text('${controller.count}', style: TextStyle(fontSize: 20,),);
          }
        ),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        onPressed: () {},

      ),
    );
  }
}
