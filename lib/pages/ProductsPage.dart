import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/state_manager.dart';
import 'package:safeshopping/controllers/AuthController.dart';
import 'package:safeshopping/controllers/ProductController.dart';
import 'package:safeshopping/controllers/UserController.dart';
import 'package:safeshopping/pages/AddNewProduct.dart';
import 'package:safeshopping/pages/UpdateProductPage.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final UserController userController = Get.put(UserController());
  final AuthController authController = AuthController();
  final ProductController productController = Get.put(ProductController());

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        actions: [
          OutlineButton(
            onPressed: () {
              Get.to(AddNewProductPage());
            },
            child: Row(
              children: [
                Text("Add New Product"),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.inventory)
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(), //Todo: return values are here
          Expanded(
            child: Obx(
              () => StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: productController.products.length,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      print("Card Clicked" +
                          productController.products[index].productName);
                      Get.to(UpdateProductPage(), arguments: [
                        productController.products[index].imgString,
                        productController.products[index].productName,
                        productController.products[index].brandName,
                        productController.products[index].price,
                        productController.products[index].measurement,
                        productController.products[index].productQuantity,
                        productController.products[index].storeId,
                        productController.products[index].productId
                      ]);
                    }, //Todo: Navigate to product page
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        elevation: 5,
                        child: Container(
                          decoration: new BoxDecoration(
                              // color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0)),
                          // height: 200,
                          // width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image.memory(Base64Codec().decode(
                                      productController
                                          .products[index].imgString)),
                                ),
                              ),
                              Text(productController
                                  .products[index].productName),
                              Text(productController.products[index].brandName),
                              SizedBox(
                                height: 10,
                              ),
                              Text(productController
                                      .products[index].productQuantity +
                                  " " +
                                  productController
                                      .products[index].measurement),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Rs. " +
                                          productController
                                              .products[index].price +
                                          ".00",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                iconSize: 30,
                icon: const Icon(Icons.shopping_basket_rounded),
                onPressed: () {}), //ToDo: To orders page
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/safe_shopping_logo.png'),
                ),
              ),
            ),
            IconButton(
                iconSize: 30,
                icon: const Icon(Icons.person),
                onPressed: () {}), //ToDo: To User profile page
          ],
        ),
      ),
    );
  }
}
