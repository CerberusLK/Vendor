import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeshopping/controllers/AuthController.dart';
import 'package:safeshopping/controllers/StoreController.dart';
import 'package:safeshopping/services/FirestoreServices.dart';

class AddNewProductPage extends StatefulWidget {
  @override
  _AddNewProductPageState createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  StoreController storeController = Get.put(StoreController());
  AuthController _auth = Get.put(AuthController());
  StoreController _store = Get.put(StoreController());
  final TextEditingController productName = TextEditingController();
  final TextEditingController productBrand = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  final TextEditingController productQuantity = TextEditingController();
  final TextEditingController unitOfMeasurement = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add New Product"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .70,
                      child: Column(
                        children: [
                          Text(
                            "Product Name",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(20),
                                color: Colors.grey[300]),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a product name";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: productName,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.inventory)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Product Brand",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(20),
                                color: Colors.grey[300]),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: productBrand,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon:
                                        Icon(Icons.shopping_bag_outlined)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Product Price",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(20),
                                color: Colors.grey[300]),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: productPrice,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.local_offer)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Product Quantity",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(20),
                                color: Colors.grey[300]),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: productQuantity,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.shopping_cart)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Unit of Measurements",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(20),
                                color: Colors.grey[300]),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: unitOfMeasurement,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon:
                                        Icon(Icons.countertops_outlined)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 20,
                            width: 280,
                          ),
                          Container(
                            height: 450,
                            child: Obx(
                              () =>
                                  storeController.selectedImagePath.value == ''
                                      ? Text("Select Image for the Store")
                                      : Image(
                                          image: FileImage(File(storeController
                                              .selectedImagePath.value))),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: 280,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 80,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  onPressed: () {
                                    storeController
                                        .getImage(ImageSource.camera);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt_rounded),
                                      Text("Get Image From Camera"),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                width: 240,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  onPressed: () {
                                    storeController
                                        .getImage(ImageSource.gallery);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.collections),
                                      Text("Get Image From Gallery"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 80,
                                width: MediaQuery.of(context).size.width * .70,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  onPressed: () {
                                    final bytes = File(storeController
                                            .selectedImagePath.value)
                                        .readAsBytesSync();
                                    FirestoreServices().addProduct(
                                        _auth.user.uid,
                                        storeController.selectedStore.value,
                                        productBrand.text,
                                        base64Encode(bytes),
                                        unitOfMeasurement.text,
                                        productPrice.text,
                                        productName.text,
                                        productQuantity.text);
                                    Get.back();
                                    storeController.selectedImagePath.value =
                                        "";
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.store),
                                      Text("Add the Product"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
