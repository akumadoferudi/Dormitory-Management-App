import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentHistoryCollections {
  // get collection of notes
  final CollectionReference paymentHistories = FirebaseFirestore.instance.collection('payment_histories');

  // READ
  Stream<QuerySnapshot> getpaymentHistoriesStream() {
    final dormsStream = paymentHistories.orderBy('updatedAt', descending: true).snapshots();
    return dormsStream;
  }

  // CREATE
  Future<void> storePayment(String photo, String name, String address) {
    return paymentHistories.add({
      'photo': photo, // photo thumbnail
      'name': name,
      'address': address,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now()
    });
  }

  // UPDATE
  Future<void> updatePayment(String docId, String photo, String name, String address) {
    return paymentHistories.doc(docId).update({
      'photo': photo, // photo thumbnail
      'name': name,
      'address': address,
      'updatedAt': Timestamp.now()
    });
  }

  // DELETE
  Future<void> deletePayment(String docId) {
    return paymentHistories.doc(docId).delete();
  }
}