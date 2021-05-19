import 'package:get/get.dart';
import 'package:safeshopping/controllers/AwaitingCustomersController.dart';
import 'package:safeshopping/models/CheckoutOrder.dart';
import 'package:safeshopping/services/FirestoreServices.dart';

class CheckoutController extends GetxController {
  Rx<List<CheckoutOrderModel>> _order = Rx<List<CheckoutOrderModel>>();
  List<CheckoutOrderModel> get order => _order.value;

  @override
  void onInit() {
    _order.bindStream(FirestoreServices().getCheckoutOrders(
        Get.find<AwaitingCustomerController>().customerId.value));
  }
}
