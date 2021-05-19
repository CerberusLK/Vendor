import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:safeshopping/controllers/AuthController.dart';
import 'package:safeshopping/controllers/AwaitingCustomersController.dart';
import 'package:safeshopping/controllers/AwaitingOrderController.dart';
import 'package:safeshopping/controllers/CheckoutController.dart';
import 'package:safeshopping/controllers/ProductController.dart';
import 'package:safeshopping/controllers/StoreController.dart';
import 'package:safeshopping/controllers/OnGoingOrderController.dart';
import 'package:safeshopping/models/Order.dart';
import 'package:safeshopping/models/Product.dart';
import 'package:safeshopping/models/User.dart';
import 'package:safeshopping/pages/IncompletedOrders.dart';
import 'package:safeshopping/pages/OrderDetails.dart';
import 'package:safeshopping/pages/ProductsPage.dart';
import 'package:safeshopping/pages/StoreSelector.dart';
import 'package:safeshopping/services/FirestoreServices.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _auth = Get.find<AuthController>();
  final StoreController _store = Get.put(StoreController());
  final ProductController productController = Get.put(ProductController());
  final OnGoingOrderController onGoingOrderController =
      Get.put(OnGoingOrderController());
  final AwaitingOrderController awaitingOrderController =
      Get.put(AwaitingOrderController());
  final AwaitingCustomerController awaitingCustomerController =
      Get.put(AwaitingCustomerController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 400,
                    ),
                    SizedBox(
                      height: 600,
                      child: Obx(() => StaggeredGridView.countBuilder(
                          crossAxisCount: 1,
                          itemCount: _store.storeList.length,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _store.selectedStore.value =
                                    _store.storeList[index].storeId;
                                Get.snackbar(
                                    "Store selection",
                                    "You have selected the store " +
                                        _store.storeList[index].name);
                                print(_store.storeList[index].name);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  elevation: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 150,
                                          child: Image.memory(Base64Codec()
                                              .decode(_store
                                                  .storeList[index].image)),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.store_rounded),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(_store.storeList[index].name),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(_store.storeList[index].phone),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.location_city),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(_store.storeList[index].city),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (index) =>
                              StaggeredTile.fit(1))),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_store.selectedStore.value != "") {
                          Get.to(() => ProductsPage());
                        } else {
                          Get.defaultDialog(
                              title: "Error",
                              middleText: "You need to select a store First",
                              textConfirm: "Ok",
                              onConfirm: () {
                                Get.back();
                              });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Add Products to Store"),
                          Icon(Icons.store_mall_directory_outlined),
                        ],
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Get.to(() => StoreSelectorPage());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Select A different Store"),
                          Icon(Icons.store_mall_directory_outlined),
                        ],
                      ),
                    ),
                    BottomAppBar(
                      child: Row(
                        children: [
                          RaisedButton(
                            onPressed: () {
                              Get.find<AuthController>().signOut();
                            },
                            child: Row(
                              children: [
                                Text("Signout"),
                                Icon(Icons.login_rounded)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Customers Waiting for Collecting Orders",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Obx(() => StaggeredGridView.countBuilder(
                                    crossAxisCount: 1,
                                    itemCount: awaitingCustomerController
                                        .customer.length,
                                    itemBuilder: (context, index) {
                                      return FutureBuilder<UserModel>(
                                          future: FirestoreServices()
                                              .getCustomerName(
                                                  awaitingCustomerController
                                                      .customer[index]
                                                      .customerId),
                                          builder: (context, userModel) {
                                            if (userModel.hasData) {
                                              return InkWell(
                                                onTap: () {
                                                  awaitingCustomerController
                                                          .customerId.value =
                                                      awaitingCustomerController
                                                          .customer[index]
                                                          .customerId;
                                                  print("customer selected " +
                                                      userModel.data.name);
                                                  Get.to(
                                                      () => OrderDetailsPage(),
                                                      arguments: [
                                                        awaitingCustomerController
                                                            .customer[index]
                                                            .itemCount,
                                                        awaitingCustomerController
                                                            .customer[index]
                                                            .checkoutTotal
                                                      ]);
                                                },
                                                child: Card(
                                                  elevation: 10,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(userModel
                                                                .data.name)
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(
                                                                    "Item Count :"),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(awaitingCustomerController
                                                                    .customer[
                                                                        index]
                                                                    .itemCount)
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(
                                                                    "Checkout Total :"),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(awaitingCustomerController
                                                                    .customer[
                                                                        index]
                                                                    .checkoutTotal)
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
                                    staggeredTileBuilder: (index) =>
                                        StaggeredTile.fit(1)))),
                          ],
                        ),
                        color: Colors.yellow,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Selected Customer Orders",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        color: Colors.teal[100],
                      ),
                    ),
                  ],
                ),
                color: Colors.green,
              ),
            ),
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Orders waiting to be Accepted",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      RaisedButton(
                          color: Colors.greenAccent,
                          elevation: 20,
                          child: Row(
                            children: [
                              Text("To Accepted Orders"),
                              SizedBox(width: 40),
                              Icon(Icons.shopping_basket)
                            ],
                          ),
                          onPressed: () {
                            Get.to(IncompletedOrderPage());
                          })
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                child: Obx(() => StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: onGoingOrderController.orderList.length,
                    itemBuilder: (context, index) {
                      bool isAccepted = false;
                      return FutureBuilder<ProductModel>(
                          future: FirestoreServices().getProduct(
                              onGoingOrderController
                                  .orderList[index].productId),
                          builder: (context, productModel) {
                            if (productModel.hasData) {
                              return Card(
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
                                              Text("Accept Order :"),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                      color: Colors.red,
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        Get.defaultDialog(
                                                            title: "Warning",
                                                            middleText:
                                                                "This order will be rejected",
                                                            textConfirm:
                                                                "Confirm",
                                                            textCancel:
                                                                "Cancel",
                                                            onCancel: () {
                                                              Get.back();
                                                            },
                                                            onConfirm: () {
                                                              FirestoreServices().rejectOngoingOrderStatus(
                                                                  _store
                                                                      .selectedStore
                                                                      .value,
                                                                  onGoingOrderController
                                                                      .orderList[
                                                                          index]
                                                                      .orderId);
                                                            });
                                                      }),
                                                  SizedBox(
                                                    width: 50,
                                                  ),
                                                  IconButton(
                                                      color: Colors.green,
                                                      icon: Icon(Icons.done),
                                                      onPressed: () {
                                                        FirestoreServices()
                                                            .acceptOngoingOrderStatus(
                                                                _store
                                                                    .selectedStore
                                                                    .value,
                                                                onGoingOrderController
                                                                    .orderList[
                                                                        index]
                                                                    .orderId);
                                                      }),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            child: Image.memory(
                                              Base64Codec().decode(
                                                  productModel.data.imgString),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            productModel.data.productName,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(productModel.data.brandName),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Rs." +
                                                    productModel.data.price
                                                        .toString() +
                                                    ".00",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(" X " +
                                                  onGoingOrderController
                                                      .orderList[index].qty
                                                      .toString())
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text("Order date: "),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(onGoingOrderController
                                                  .orderList[index].dateCreated
                                                  .toDate()
                                                  .toString())
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text("Loading...");
                            }
                          });
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.fit(1)))),
          ],
        ),
      ),
    );
  }
}
