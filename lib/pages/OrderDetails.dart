import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:safeshopping/controllers/CheckoutController.dart';
import 'package:safeshopping/models/Product.dart';
import 'package:safeshopping/services/FirestoreServices.dart';

class OrderDetailsPage extends StatefulWidget {
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final CheckoutController checkoutController = Get.put(CheckoutController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Customer Order Details"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => StaggeredGridView.countBuilder(
                crossAxisCount: 1,
                itemCount: checkoutController.order.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<ProductModel>(
                      future: FirestoreServices().getProduct(
                          checkoutController.order[index].productId),
                      builder: (context, product) {
                        int total = checkoutController.order[index].qty *
                            int.parse(product.data.price);
                        if (product.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Customer Id: ",
                                              style: TextStyle(
                                                  color: Colors.blueGrey[600],
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              checkoutController
                                                  .order[index].customerId,
                                              style: TextStyle(
                                                  color: Colors.blueGrey[600],
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  height: 250,
                                                  width: 300,
                                                  child: Image.memory(
                                                      Base64Codec().decode(
                                                          product
                                                              .data.imgString)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      product.data.productName,
                                                      style: TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      product.data.brandName,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .blueGrey[600],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Rs." +
                                                          product.data.price +
                                                          ".00",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueAccent,
                                                          fontSize: 18),
                                                    ),
                                                    Text("  X  " +
                                                        checkoutController
                                                            .order[index].qty
                                                            .toString())
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Total Price: " +
                                                          "Rs." +
                                                          total.toString() +
                                                          ".00",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Text("Loading...");
                        }
                      });
                },
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
