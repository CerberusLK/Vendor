import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  String storeId;
  String city;
  String name;
  String ownerId;
  String phone;
  String image;

  StoreModel(
    this.city,
    this.name,
    this.ownerId,
    this.phone,
    this.storeId,
    this.image,
  );

  StoreModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    storeId = documentSnapshot.documentID;
    city = documentSnapshot.data["Store City"];
    name = documentSnapshot.data["Store Name"];
    ownerId = documentSnapshot.data["Store Owner Id"];
    phone = documentSnapshot.data["Store Phone"];
    image = documentSnapshot.data["Store Photo"];
  }
}
