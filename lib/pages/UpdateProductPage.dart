import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeshopping/controllers/AuthController.dart';
import 'package:safeshopping/controllers/StoreController.dart';
import 'package:safeshopping/services/FirestoreServices.dart';

class UpdateProductPage extends StatefulWidget {
  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  StoreController storeController = Get.put(StoreController());
  AuthController _auth = Get.put(AuthController());
  final TextEditingController storeName = TextEditingController();
  final TextEditingController storePhone = TextEditingController();
  final TextEditingController storeTown = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Update Product"),
          centerTitle: true,
        ),
        body: Row(
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
                          "Store Name",
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          height: 75,
                          decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(20),
                              color: Colors.grey[300]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter store name";
                                } else {
                                  return null;
                                }
                              },
                              controller: storeName,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon:
                                      Icon(Icons.account_circle_rounded)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Store Phone",
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          height: 75,
                          decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(20),
                              color: Colors.grey[300]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: storePhone,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.phone)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Store located Town",
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          height: 75,
                          decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(20),
                              color: Colors.grey[300]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: storeTown,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon:
                                      Icon(Icons.location_city_rounded)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 280,
                        ),
                        Container(
                          height: 450,
                          child: Obx(
                            () => storeController.selectedImagePath.value == ''
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
                                  storeController.getImage(ImageSource.camera);
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
                                  storeController.getImage(ImageSource.gallery);
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
                                  FirestoreServices().createNewStore(
                                      _auth.user.uid,
                                      storeTown.text,
                                      storeName.text,
                                      _auth.user.uid,
                                      storePhone.text,
                                      base64Encode(bytes));
                                  Get.back();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.store),
                                    Text("Create Store"),
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
    );
  }
}
