import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safeshopping/controllers/AuthController.dart';
import 'package:safeshopping/models/store.dart';
import 'package:safeshopping/services/FirestoreServices.dart';

class StoreController extends GetxController {
  Rx<List<StoreModel>> _storeList = Rx<List<StoreModel>>();
  List<StoreModel> get storeList => _storeList.value;

  var selectedImagePath = ''.obs;
  var selectedStore = "".obs;

  void getImage(ImageSource imageSource) async {
    final pickedFile =
        await ImagePicker().getImage(source: imageSource, imageQuality: 25);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    } else {
      Get.snackbar('Error', 'No Image Selected',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent[100],
          colorText: Colors.white);
    }
  }

  @override
  void onInit() {
    super.onInit();
    String vendorId = Get.find<AuthController>().user.uid;
    _storeList.bindStream(FirestoreServices().getUserStores(vendorId));
  }
}
