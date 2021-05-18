import 'package:get/get.dart';
import 'package:safeshopping/controllers/StoreController.dart';
import 'package:safeshopping/models/Order.dart';
import 'package:safeshopping/services/FirestoreServices.dart';

class AwaitingOrderController extends GetxController {
  Rx<List<OrderModel>> _awaitingOrder = Rx<List<OrderModel>>();
  List<OrderModel> get awaitingOrder => _awaitingOrder.value;

  @override
  void onInit() {
    _awaitingOrder.bindStream(FirestoreServices()
        .getAwaitingOrders(Get.find<StoreController>().selectedStore.value));
  }
}
