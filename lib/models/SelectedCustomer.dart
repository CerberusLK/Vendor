import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedCustomerModel {
  String customerId;
  String itemCount;
  String checkoutTotal;

  SelectedCustomerModel({
    this.checkoutTotal,
    this.customerId,
    this.itemCount,
  });

  SelectedCustomerModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    customerId = documentSnapshot.data["customerId"];
    itemCount = documentSnapshot.data["itemCount"].toString();
    checkoutTotal = documentSnapshot.data["checkoutTotal"];
  }
}
