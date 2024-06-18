
import 'package:fp_golekost/services/UserServiceInterface.dart';

import '../model/admin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService implements UserServiceInterface {
  // Note collection
  final CollectionReference admins = FirebaseFirestore.instance.collection('admin');

  // CREATE
  @override
  Future<void> addUser(covariant AdminModel user) {
    return admins.add(user.mapModel());
  }
  // READ

  // Stream<QuerySnapshot> getNotesStream() {
  //   final notesStream = notes.orderBy('timestamp', descending: true).snapshots();
  //
  //   return notesStream;
  // }

  @override
  Stream<QuerySnapshot> getUser(String email) {
    //TODO : Check if requested email exists
    final residentData = admins.where("email", isEqualTo: email).limit(1).snapshots();
    return residentData;
  }

  // UPDATE
  @override
  Future<void> updateUser(String docID, covariant AdminModel user){
    return admins.doc(docID).update(user.mapModel());
  }

  // DELETE
  @override
  Future<void> deleteUser(String docID){
    return admins.doc(docID).delete();
  }

  @override
  Future<bool> exists (String email) async {
    bool exist = false;
    final adminsData = await admins.where("email", isEqualTo: email).limit(1).get().then(
            (doc) {
          exist = doc.docs.isEmpty;
        }
    );
    return !exist;

  }
}