import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserServiceInterface {
  Future<void> addUser(user);
  Stream<QuerySnapshot> getUser(String email);
  Future<void> updateUser(String docId, user);
  Future<void> deleteUser(String docID);
  Future<bool> exists (String email);
}