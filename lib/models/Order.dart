import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String orderId;
  String customerId;
  String storeId;
  int unitPrice;
  String productId;
  int qty;
  Timestamp dateCreated;
  bool isCompleted;
  String status; //order accepted,in review,completed

  OrderModel(
    this.customerId,
    this.dateCreated,
    this.isCompleted,
    this.orderId,
    this.productId,
    this.qty,
    this.status,
    this.storeId,
    this.unitPrice,
  );

  OrderModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    orderId = documentSnapshot.documentID;
    customerId = documentSnapshot.data["customerId"];
    storeId = documentSnapshot.data["storeId"];
    dateCreated = documentSnapshot.data["dateCreated"];
    qty = int.parse(documentSnapshot.data["qty"]);
    isCompleted = bool.fromEnvironment(
        documentSnapshot.data["isCompleted"].toLowerCase());
    status = documentSnapshot.data["status"];
    productId = documentSnapshot.data["productId"];
    unitPrice = int.parse(documentSnapshot.data["unitPrice"]);
  }
}
