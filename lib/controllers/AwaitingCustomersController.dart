import 'package:get/get.dart';
import 'package:safeshopping/controllers/StoreController.dart';
import 'package:safeshopping/models/SelectedCustomer.dart';
import 'package:safeshopping/services/FirestoreServices.dart';

class AwaitingCustomerController extends GetxController {
  Rx<List<SelectedCustomerModel>> _customer = Rx<List<SelectedCustomerModel>>();
  List<SelectedCustomerModel> get customer => _customer.value;

  @override
  void onInit() {
    _customer.bindStream(FirestoreServices()
        .getAwaitingCuatomers(Get.find<StoreController>().selectedStore.value));
  }
}
