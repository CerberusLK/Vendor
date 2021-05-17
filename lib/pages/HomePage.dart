import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:safeshopping/controllers/AuthController.dart';
import 'package:safeshopping/controllers/ProductController.dart';
import 'package:safeshopping/controllers/StoreController.dart';
import 'package:safeshopping/controllers/OnGoingOrderController.dart';
import 'package:safeshopping/models/Product.dart';
import 'package:safeshopping/pages/CreateStore.dart';
import 'package:safeshopping/pages/ProductsPage.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
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
                        Get.to(() => CreateStorePage());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Create Store"),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Customers Waiting for Collecting Orders",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [Text("Chathura Prabasha")],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text("Item Count :"),
                                            ],
                                          ),
                                          Column(
                                            children: [Text("2")],
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text("Checkout Total :"),
                                            ],
                                          ),
                                          Column(
                                            children: [Text("Rs.500.00")],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [Text("Lakshan Wijesooriya")],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text("Item Count :"),
                                            ],
                                          ),
                                          Column(
                                            children: [Text("4")],
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text("Checkout Total :"),
                                            ],
                                          ),
                                          Column(
                                            children: [Text("Rs.1100.00")],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        color: Colors.yellow,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Selected Customer Orders",
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 120,
                                                width: 120,
                                                child: Image.memory(
                                                  Base64Codec().decode(
                                                      "/9j/4QBqRXhpZgAATU0AKgAAAAgABIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAEAAAQAAAABAAACWAEBAAQAAAABAAACWAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAQESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQABAAD/2wBDACAWGBwYFCAcGhwkIiAmMFA0MCwsMGJGSjpQdGZ6eHJmcG6AkLicgIiuim5woNqirr7EztDOfJri8uDI8LjKzsb/2wBDASIkJDAqMF40NF7GhHCExsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsb/wAARCAJYAlgDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDoKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACikJA6mmeanrQBJRUYkQnANSUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFNzQA6kJFMZ1HU/lTDN/dFICXJ9KaVY9Wx9KhMrHvTdxPc0ATmNT/EfzqFhtbFADHpmpFh9aAIgCTxVsdBmkVQvQU6gAooopgFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABUbSKo9aJDgAZxmoOtIBzSsfaoySepJpdppRGxoAZSgE9BUywgdaUsqj5VLH0FAEaxE9aeVVFyxA9zUEhvZMhBHCPUncarnSnkbdPeSs3qOKdgLi3UQOM5/2hTxcxN0J/KoorKKMYJZ/985qURon3VAoAlDA9DTqhLAd6dG+4HnkUASUUlLQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUU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unuZc/KW2j8KleZRMIhncRmpc1FakyV3oOY49zUZpTTHOBXFUm5PUuKsIaZTm6U2urBR0cjmxL1SCgdaSp5PLWMBQN1dzdjBRvqNWpVqJakFSy4lkdKWkpayNwooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACqV2doB3BeTk9cVdqjdgBwScd8+lNbky2KigR7nTmM9V9KcieSwAOUc/0oaMo3y4GeGXsw74qSKRZFyuR2I9K1RgyPYIPmjwAxAI/GpcfPn2paD94UyRqnLuMAYI/Grz9RVFWzI6nHGKvP0FRI1h1EoNFFSWMdckH0prU9ulMk9fWmtyXsRNTKlMTlcgVA4dsKny56t6Vd9DPlbdiaK5RWEQyz4PTt9aityhiW6uG3SOcLnt9BUUDJD5kiqSD8iDuaSzGUURfPNjGW6RiuZvU74wSjoCbzPMBE8ib8kL3Pv7VZNq8knnSymNiMFU9PrT1CWYkZ5M+Y2cY5qtPI89q0u4BeoTvjPU1m5dEVrJ6EhmiZY7e3fALbcr2FV03xXKj5n2OVHqeKVFMsjFFCTh9209MVdij8tSWOWY5Y+9ZN2K0joKu7aN+N3fFMPJpd24n0pGrlk7uxKGsaSg0lexh4clNI8+rLmm2KBkgUd81PbFVV2PaoCcsT6mtE7slxskSJz0qQAg4PFNgcITnv3qzwwz1qJPU1hG6uPoooqDUKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAqlegH72dvQ4q7VK+GRjAbkcetNbilsUlLxHy5AXTllfPP/66mThiSfv9D6//AF6jG6LOMPER36jFJGSqg/ehbp7VojBlijuKYDtAJztPQnqPrTiPmU+maogbuImYEcbQavN0FZ43AuD0AyPzNXR0/Kokaw2HClpBRSKGuwXGe5qUouzHpUW0OwBqVVIXBqWUtisJXQkdfY1BdExwNIxwTwPxq8y85A5qtcPbB0Wfkgg4xwPrSlNJaBCDctdRllBwJpFwAMIp7D1pfOhhQR221ctt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"),
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Slim n Trim Milk",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Amul"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Rs.250.00",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [Text(" X 2")],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
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
              child: Text(
                "Orders waiting to be Accepted",
                style: TextStyle(fontSize: 20),
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
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              color: Colors.red,
                                              icon: Icon(Icons.close),
                                              onPressed: () {})
                                        ],
                                      ),
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
                                              Checkbox(
                                                  value: isAccepted,
                                                  onChanged: (bool value) {
                                                    isAccepted = value;
                                                  })
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
