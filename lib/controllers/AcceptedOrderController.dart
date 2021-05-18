import 'package:get/get.dart';
import 'package:safeshopping/controllers/StoreController.dart';
import 'package:safeshopping/models/Order.dart';
import 'package:safeshopping/services/FirestoreServices.dart';

class AcceptedOrderController extends GetxController {
  StoreController storeController = Get.find<StoreController>();
  Rx<List<OrderModel>> _orderList = Rx<List<OrderModel>>();
  List<OrderModel> get orderList => _orderList.value;

  @override
  void onInit() {
    _orderList.bindStream(FirestoreServices()
        .getAcceptedOrders(storeController.selectedStore.value));
  }
}
