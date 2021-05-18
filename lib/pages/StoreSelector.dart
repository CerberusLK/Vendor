import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:safeshopping/controllers/AuthController.dart';
import 'package:safeshopping/controllers/StoreController.dart';
import 'package:safeshopping/pages/HomePage.dart';

import 'CreateStore.dart';
import 'ProductsPage.dart';

class StoreSelectorPage extends StatefulWidget {
  @override
  _StoreSelectorPageState createState() => _StoreSelectorPageState();
}

class _StoreSelectorPageState extends State<StoreSelectorPage> {
  final StoreController _store = Get.put(StoreController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Your Store"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select A store If you have already Created a one",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Or you can Create a New Store",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 600,
                  child: Obx(() => StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
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
                            Get.to(() => HomePage());
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
                                      child: Image.memory(Base64Codec().decode(
                                          _store.storeList[index].image)),
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
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1))),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  onPressed: () {
                    Get.to(() => CreateStorePage());
                  },
                  child: Container(
                    height: 100,
                    width: 450,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Create Store"),
                        Icon(Icons.store_mall_directory_outlined),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        onPressed: () {
                          Get.find<AuthController>().signOut();
                        },
                        child: Container(
                          height: 100,
                          width: 450,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Signout"),
                              Icon(Icons.login_rounded)
                            ],
                          ),
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
    );
  }
}
