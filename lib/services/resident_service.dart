import 'package:fp_golekost/services/UserServiceInterface.dart';

import '../model/resident_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResidentService implements UserServiceInterface {
  // Note collection
  final CollectionReference residents = FirebaseFirestore.instance.collection('resident');

  // CREATE
  @override
  Future<void> addUser(covariant ResidentModel user) {
    return residents.add(user.mapModel());
  }
  // READ

  // Stream<QuerySnapshot> getNotesStream() {
  //   final notesStream = notes.orderBy('timestamp', descending: true).snapshots();
  //
  //   return notesStream;
  // }

  @override
  Stream<QuerySnapshot> getUser(String email) {

    final residentData = residents.where("email", isEqualTo: email).limit(1).snapshots();
    return residentData;
  }

  Future<Map<String, dynamic>> getUserByRoom(String id) async {
    Map<String, dynamic> residentData = {};
    await residents.where("room_id", isEqualTo: id).limit(1).get().then(
            (QuerySnapshot doc) {
          doc.docs.forEach((element){
            residentData = element.data() as Map<String, dynamic>;
            residentData["id"] = element.id;
          });
          // ...
        });
    return residentData;
  }

  // UPDATE
  @override
  Future<void> updateUser(String docID, covariant ResidentModel user){
    return residents.doc(docID).update(user.mapModel());
  }

  // DELETE
  @override
  Future<void> deleteUser(String docID){
    return residents.doc(docID).delete();
  }

  @override
  Future<bool> exists (String email) async {
    bool exist = false;
    final residentData = await residents.where("email", isEqualTo: email).limit(1).get().then(
        (doc) {
          exist = doc.docs.isEmpty;
        }
    );
    return !exist;

  }
}