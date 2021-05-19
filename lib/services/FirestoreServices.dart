import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:safeshopping/models/CheckOutTotal.dart';
import 'package:safeshopping/models/CheckoutOrder.dart';
import 'package:safeshopping/models/Order.dart';
import 'package:safeshopping/models/Product.dart';
import 'package:safeshopping/models/SelectedCustomer.dart';
import 'package:safeshopping/models/ShoppingCart.dart';
import 'package:safeshopping/models/ShoppingCartTotal.dart';
import 'package:safeshopping/models/User.dart';
import 'package:safeshopping/models/store.dart';
import 'package:uuid/uuid.dart';

class FirestoreServices extends GetxController {
  Firestore _db = Firestore.instance;
  var uuid = Uuid();

  Future getData(String collection) async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection(collection).getDocuments();
    return snapshot.documents;
  }

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _db.collection("Vendor").document(user.id).setData({
        "name": user.name,
        "email": user.email,
        "totalCartPrice": "0",
        "totalCheckout": "0",
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection("Vendor").document(uid).get();
      UserModel _userModel = UserModel.fromDocumentSnapshot(doc);
      print(_userModel.id);
      print(_userModel.name);
      print(_userModel.email);
      return _userModel;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<ProductModel> getProduct(String productId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection("Products").document(productId).get();
      ProductModel _productModel = ProductModel.fromDocumentSnapshot(doc);
      return _productModel;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<UserModel> getCustomerName(String customerId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection("Customer").document(customerId).get();
      UserModel userModel = UserModel.fromDocumentSnapshot(doc);
      return userModel;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<ProductModel>> productStream() {
    return _db
        .collection("Products")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<ProductModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(ProductModel.fromDocumentSnapshot(element));
      });
      print(retVal.length);
      print(retVal[0].productName);
      return retVal;
    });
  }

  Stream<int> cartTotalStream(String customerId) {
    return _db
        .collection("Customer")
        .document(customerId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      int retVal = int.parse(documentSnapshot.data["totalCartPrice"]);
      print("cart total = " + retVal.toString());
      return retVal;
    });
  }

  Stream<int> checkOutTotalStream(String customerId) {
    return _db
        .collection("Customer")
        .document(customerId)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) {
      int retVal = int.parse(documentSnapshot.data["totalCheckout"]);
      print("checkout total = " + retVal.toString());
      return retVal;
    });
  }

  Stream<List<ShoppingCartModel>> shoppingCartStream(String userId) {
    return _db
        .collection("Customer")
        .document(userId)
        .collection("ShoppingCart")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<ShoppingCartModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(ShoppingCartModel.fromDocumentSnapshot(element));
      });
      print("shopping cart = " + retVal.length.toString());
      return retVal;
    });
  }

  Stream<List<OrderModel>> getOngoingOrders(String storeId) {
    return _db
        .collection("Stores")
        .document("g47iC3QAFnm4okLCTS6I")
        .collection("OngoingOrders")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<OrderModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(OrderModel.fromDocumentSnapshot(element));
      });
      print("Ongoing order num = " + retVal.length.toString());
      return retVal;
    });
  }

  Stream<List<CheckoutOrderModel>> getCheckoutOrders(String customerId) {
    return _db
        .collection("Customer")
        .document(customerId)
        .collection("CheckoutOrders")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<CheckoutOrderModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(CheckoutOrderModel.fromDocumentSnapshot(element));
      });
      print("checkout count is :" + retVal.length.toString());
      return retVal;
    });
  }

  Stream<List<OrderModel>> getAwaitingOrders(String storeId) {
    return _db
        .collection("Stores")
        .document(storeId)
        .collection("AwaitingOrders")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<OrderModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(OrderModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Stream<List<OrderModel>> getCompletedOrders(String userId) {
    return _db
        .collection("Customer")
        .document(userId)
        .collection("CompletedOrders")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<OrderModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(OrderModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Stream<List<SelectedCustomerModel>> getAwaitingCustomers(String storeId) {
    return _db
        .collection("Stores")
        .document(storeId)
        .collection("AwaitingCustomers")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<SelectedCustomerModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(SelectedCustomerModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Stream<List<OrderModel>> getAcceptedOrders(String storeId) {
    return _db
        .collection("Stores")
        .document(storeId)
        .collection("AcceptedOrders")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<OrderModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(OrderModel.fromDocumentSnapshot(element));
      });
      print("accepted order length = " + retVal.length.toString());
      return retVal;
    });
  }

  Stream<List<SelectedCustomerModel>> getAwaitingCuatomers(String storeId) {
    return _db
        .collection("Stores")
        .document(storeId)
        .collection("AwaitingCustomers")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<SelectedCustomerModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(SelectedCustomerModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Stream<List<StoreModel>> getUserStores(String vendorId) {
    return _db
        .collection("Stores")
        .where("Store Owner Id", isEqualTo: vendorId)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<StoreModel> retVal = List();
      querySnapshot.documents.forEach((element) {
        retVal.add(StoreModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Future<ShoppingCartModel> getShoppingCartItem(
      String productId, String userId) async {
    try {
      DocumentSnapshot doc = await _db
          .collection("Customer")
          .document(userId)
          .collection("ShoppingCart")
          .document(productId)
          .get();
      if (doc.exists) {
        ShoppingCartModel _shoppingCartModel =
            ShoppingCartModel.fromDocumentSnapshot(doc);
        return _shoppingCartModel;
      } else
        return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List> getSpecificOngoingOrder(String storeId, String orderId) async {
    List returnVal = [];
    try {
      DocumentSnapshot doc = await _db
          .collection("Stores")
          .document(storeId)
          .collection("OngoingOrders")
          .document(orderId)
          .get();
      if (doc.exists) {
        returnVal.add(doc.documentID.toString());
        OrderModel orderModel = OrderModel.fromDocumentSnapshot(doc);
        returnVal.add(orderModel);
        return returnVal;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List> getSpecificAcceptedOrder(String storeId, String orderId) async {
    List returnVal = [];
    try {
      DocumentSnapshot doc = await _db
          .collection("Stores")
          .document(storeId)
          .collection("AcceptedOrders")
          .document(orderId)
          .get();
      if (doc.exists) {
        returnVal.add(doc.documentID.toString());
        OrderModel orderModel = OrderModel.fromDocumentSnapshot(doc);
        returnVal.add(orderModel);
        return returnVal;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<ShoppingCartTotalModel> getShoppingCartTotal(String customerId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection("Customer").document(customerId).get();
      if (doc.exists) {
        ShoppingCartTotalModel _total =
            ShoppingCartTotalModel.fromDocumentSnapshot(doc);
        return _total;
      } else
        return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<CheckOutTotalModel> getCheckOutTotal(String customerId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection("Customer").document(customerId).get();
      if (doc.exists) {
        CheckOutTotalModel _total =
            CheckOutTotalModel.fromDocumentSnapshot(doc);
        return _total;
      } else
        return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> createNewStore(
    String vendorId,
    String city,
    String name,
    String ownerId,
    String phone,
    String photo,
  ) async {
    try {
      await _db
          .collection("Vendor")
          .document(vendorId)
          .collection("Stores")
          .add({
        "Store City": city,
        "Store Name": name,
        "Store Owner Id": ownerId,
        "Store Phone": phone,
        "Store Photo": photo,
      });
      await _db.collection("Stores").add({
        "Store City": city,
        "Store Name": name,
        "Store Owner Id": ownerId,
        "Store Phone": phone,
        "Store Photo": photo,
      });
      Get.snackbar("Success", "Store Created Successfully");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addProduct(
      String vendorId,
      String storeId,
      String brandName,
      String imgString,
      String measurement,
      String price,
      String productName,
      String quantity) async {
    await _db
        .collection("Vendor")
        .document(vendorId)
        .collection("Stores")
        .document(storeId)
        .collection("Products")
        .add({
      "brandName": brandName,
      "imgString": imgString,
      "measurement": measurement,
      "price": price,
      "productName": productName,
      "quantity": quantity,
      "storeId": storeId,
    });
    await _db.collection("Products").add({
      "brandName": brandName,
      "imgString": imgString,
      "measurement": measurement,
      "price": price,
      "productName": productName,
      "quantity": quantity,
      "storeId": storeId,
    });
    Get.snackbar("Success", "Product added successfuly");
  }

  Future<void> addToShoppingCart(String customerId, String storeId,
      String productId, String quantity, String price) async {
    ShoppingCartModel item = await getShoppingCartItem(productId, customerId);
    try {
      if (item == null) {
        await _db
            .collection("Customer")
            .document(customerId)
            .collection("ShoppingCart")
            .document(productId)
            .setData({
          'storeId': storeId,
          'productId': productId,
          'quantity': quantity,
          'dateAdded': Timestamp.now(),
          'price': price,
        });
        ShoppingCartTotalModel total = await getShoppingCartTotal(customerId);
        await _db.collection("Customer").document(customerId).updateData({
          'totalCartPrice': (int.parse(total.totalPrice) +
                  (int.parse(quantity) * int.parse(price)))
              .toString()
        });
      } else {
        int qty = int.parse(quantity) + int.parse(item.quantity);
        await _db
            .collection("Customer")
            .document(customerId)
            .collection("ShoppingCart")
            .document(productId)
            .updateData({
          'quantity': qty.toString(),
          'dateAdded': Timestamp.now(),
        });
        ShoppingCartTotalModel total = await getShoppingCartTotal(customerId);
        await _db.collection("Customer").document(customerId).updateData({
          'totalCartPrice': (int.parse(total.totalPrice) +
                  (int.parse(quantity) * int.parse(price)))
              .toString()
        });
      }
      Get.snackbar("Success", "Item added to the cart");
    } catch (e) {
      Get.snackbar("Failed", "Item failed to add to the cart");
      rethrow;
    }
  }

  Future<void> incrementQuantity(
      String customerId, String productId, int price) async {
    ShoppingCartModel item = await getShoppingCartItem(productId, customerId);
    try {
      int qty = int.parse(item.quantity) + 1;
      if (qty == 21) {
        Get.snackbar("Error", "You might need to contact the Seller");
      } else {
        await _db
            .collection("Customer")
            .document(customerId)
            .collection("ShoppingCart")
            .document(productId)
            .updateData({
          'quantity': qty.toString(),
        });
        ShoppingCartTotalModel total = await getShoppingCartTotal(customerId);
        await _db.collection("Customer").document(customerId).updateData({
          'totalCartPrice': (int.parse(total.totalPrice) + price).toString()
        });
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> decrementQuantity(
      String customerId, String productId, int price) async {
    ShoppingCartModel item = await getShoppingCartItem(productId, customerId);
    try {
      int qty = int.parse(item.quantity) - 1;
      if (qty == 0) {
        Get.snackbar("Error", "Quantity cannot be 0");
      } else {
        await _db
            .collection("Customer")
            .document(customerId)
            .collection("ShoppingCart")
            .document(productId)
            .updateData({
          'quantity': qty.toString(),
        });
        ShoppingCartTotalModel total = await getShoppingCartTotal(customerId);
        await _db.collection("Customer").document(customerId).updateData({
          'totalCartPrice': (int.parse(total.totalPrice) - price).toString()
        });
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> markAsReadyToCollect(String storeId, String orderId) async {
    try {
      List values = await getSpecificAcceptedOrder(storeId, orderId);
      OrderModel selectedOrder = values[1];
      await _db
          .collection("Stores")
          .document(storeId)
          .collection("ReadyToCollect")
          .document(orderId)
          .setData({
        "customerId": selectedOrder.customerId,
        "dateCreated": selectedOrder.dateCreated,
        "isCompleted": "true",
        "productId": selectedOrder.productId,
        "qty": selectedOrder.qty.toString(),
        "status": "Ready To Collect",
        "storeId": selectedOrder.storeId,
        "unitPrice": selectedOrder.unitPrice.toString(),
      });
      await _db
          .collection("Customer")
          .document(selectedOrder.customerId)
          .collection("ReadyToCollect")
          .document(orderId)
          .setData({
        "customerId": selectedOrder.customerId,
        "dateCreated": selectedOrder.dateCreated,
        "isCompleted": "true",
        "productId": selectedOrder.productId,
        "qty": selectedOrder.qty.toString(),
        "status": "Ready To Collect",
        "storeId": selectedOrder.storeId,
        "unitPrice": selectedOrder.unitPrice.toString(),
      });
      await _db
          .collection("Customer")
          .document(selectedOrder.customerId)
          .collection("AcceptedOrders")
          .document(values[0])
          .delete();
      await _db
          .collection("Stores")
          .document(storeId)
          .collection("AcceptedOrders")
          .document(values[0])
          .delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> acceptOngoingOrderStatus(String storeId, String orderId) async {
    try {
      List values = await getSpecificOngoingOrder(storeId, orderId);
      OrderModel selectedOrder = values[1];
      await _db
          .collection("Stores")
          .document(storeId)
          .collection("AcceptedOrders")
          .document(orderId)
          .setData({
        "customerId": selectedOrder.customerId,
        "dateCreated": selectedOrder.dateCreated,
        "isCompleted": selectedOrder.isCompleted.toString(),
        "productId": selectedOrder.productId,
        "qty": selectedOrder.qty.toString(),
        "status": "Accepted",
        "storeId": selectedOrder.storeId,
        "unitPrice": selectedOrder.unitPrice.toString(),
      });
      await _db
          .collection("Customer")
          .document(selectedOrder.customerId)
          .collection("AcceptedOrders")
          .document(orderId)
          .setData({
        "customerId": selectedOrder.customerId,
        "dateCreated": selectedOrder.dateCreated,
        "isCompleted": selectedOrder.isCompleted.toString(),
        "productId": selectedOrder.productId,
        "qty": selectedOrder.qty.toString(),
        "status": "Accepted",
        "storeId": selectedOrder.storeId,
        "unitPrice": selectedOrder.unitPrice.toString(),
      });
      await _db
          .collection("Customer")
          .document(selectedOrder.customerId)
          .collection("OngoingOrders")
          .document(values[0])
          .delete();
      await _db
          .collection("Stores")
          .document(storeId)
          .collection("OngoingOrders")
          .document(values[0])
          .delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> rejectOngoingOrderStatus(String storeId, String orderId) async {
    try {
      List values = await getSpecificOngoingOrder(storeId, orderId);
      OrderModel selectedOrder = values[1];
      await _db
          .collection("Customer")
          .document(selectedOrder.customerId)
          .collection("RejectedOrders")
          .document(orderId)
          .setData({
        "customerId": selectedOrder.customerId,
        "dateCreated": selectedOrder.dateCreated,
        "isCompleted": selectedOrder.isCompleted,
        "productId": selectedOrder.productId,
        "qty": selectedOrder.qty,
        "status": "Rejected",
        "storeId": selectedOrder.storeId,
        "unitPrice": selectedOrder.unitPrice,
      });
      await _db
          .collection("Customer")
          .document(selectedOrder.customerId)
          .collection("OngoingOrders")
          .document(values[0])
          .delete();
      await _db
          .collection("Stores")
          .document(storeId)
          .collection("OngoingOrders")
          .document(values[0])
          .delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteItemFromShoppingCart(
      String customerId, String productId, int qty, int price) async {
    await _db
        .collection("Customer")
        .document(customerId)
        .collection("ShoppingCart")
        .document(productId)
        .delete();
    Get.snackbar("Success", "Item removed from shopping cart");
    ShoppingCartTotalModel total = await getShoppingCartTotal(customerId);
    await _db.collection("Customer").document(customerId).updateData({
      'totalCartPrice': (int.parse(total.totalPrice) - (price * qty)).toString()
    });
  }

  Future<void> completeTheCheckout(String customerId) async {
    List<String> list = List();
    QuerySnapshot query = await _db
        .collection("Customer")
        .document(customerId)
        .collection("CheckoutOrders")
        .getDocuments();
    query.documents.forEach((element) {
      list.add(element.documentID);
    });
    list.forEach((element) {
      _db
          .collection("Customer")
          .document(customerId)
          .collection("CheckoutOrders")
          .document(element)
          .delete();
    });
    await _db.collection("Customer").document(customerId).updateData({
      "totalCheckout": "0",
    });
  }

  Future<void> deleteCompletedOrder(String userId, String orderId) async {
    await _db
        .collection("Customer")
        .document(userId)
        .collection("CompletedOrders")
        .document(orderId)
        .delete();
    Get.snackbar("Success", "Order removed successfully");
  }

// Future<List<ProductModel>> getProducts() async {
//   QuerySnapshot querySnapshot =
//       await _db.collection("Products").getDocuments();

// List<DocumentSnapshot> templist;
// List<Map<dynamic, dynamic>> list = new List();
// list = templist.map((DocumentSnapshot documentSnapshot) {
//   return documentSnapshot.data;
// }).toList();

// return list;
// return querySnapshot.documents.map((e) => ProductModel(
//       e.documentID,
//       e.data['brand name'],
//       e.data['price'],
//       e.data['product name'],
//       e.data['quantity'],
//       e.data['storeId'],
//     ));
}
