import 'package:cloud_firestore/cloud_firestore.dart';

class DormCollections {
  // get collection of dorms
  final CollectionReference dorms = FirebaseFirestore.instance.collection('dorms');

  // READ
  Stream<QuerySnapshot> getDormsStream(bool getAll, String admin_id) {
    final dormsStream = getAll ? dorms.orderBy('updatedAt', descending: true).snapshots() : dorms.where("admin_id", isEqualTo: admin_id).orderBy('updatedAt', descending: true).snapshots();
    return dormsStream;
  }

  // GET DORM BY ID
  Future<Map<String, dynamic>?> getDormById(String documentId) async {
    try {
      DocumentSnapshot docSnapshot = await dorms.doc(documentId).get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      } else {
        print('Document does not exist.');
        return null;
      }
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }

  // CREATE
  Future<void> storeDorm(String photo, String name, String description, String address, String admin_id) async {
    try {
      await dorms.add({
        'photo': photo, // photo thumbnail
        'name': name,
        'description': description,
        'address': address,
        'admin_id': admin_id,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now()
      });
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  // UPDATE
  Future<void> updateDorm(String documentId,  String photo, String name, String description, String address, String admin_id) async {
    try {
      await dorms.doc(documentId).update({
        'photo': photo, // photo thumbnail
        'name': name,
        'description': description,
        'address': address,
        'admin_id': admin_id,
        'updatedAt': Timestamp.now()
      });
      print('Document successfully updated!');
    } catch (e) {
      print('Error updating document: $e');
    }


    // return dorms.doc(docId).update({
    //   'photo': photo, // photo thumbnail
    //   'name': name,
    //   'address': address,
    //   'updatedAt': Timestamp.now()
    // });
  }

  // DELETE
  Future<void> deleteDorm(String docId) async {
    try {
      await dorms.doc(docId).delete();
      print('Document successfully deleted!');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}