import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:fp_golekost/services/collections/room_data.dart';
import 'package:fp_golekost/utils/ui_utils.dart';

class FirestoreService {
  final CollectionReference rooms =
  FirebaseFirestore.instance.collection('rooms');

  // CREATE
  Future<void> addRoom(RoomData room) {
    return rooms.add(room.toFirestore());
  }

  // READ
  Stream<QuerySnapshot> getRoomsStream(String dormId) {
    // Based on dormID
    final roomsStream = rooms.where("dorm_id", isEqualTo: dormId).snapshots();
    return roomsStream;
  }

  Future<DocumentSnapshot> getOccupantRoom(String roomId) async {
    // Based on dormID
    final roomDoc = await rooms.doc(roomId).get();
    return roomDoc;
  }

  // UPDATE
  Future<void> updateRoom(RoomData room, BuildContext context) async {
    var docID = room.id;
    final confirmed = await UiUtils.showPrompt(
      context,
      'Are you sure you want to update this room?',
    );
    if (confirmed?? false) {
      return rooms.doc(docID).update(room.toFirestore());
    }
  }

  // DELETE
  Future<void> deleteRoom(String docID, BuildContext context) async {

    final confirmed = await UiUtils.showPrompt(
      context,
      'Are you sure you want to delete this room?',
    );
    if (confirmed?? false) {
      return rooms.doc(docID).delete();
    }
  }

  Future<void> deleteRoomDangerous(String docID) async {
    rooms.doc(docID).delete();
  }


  Future<bool> roomsExist() async {
    final snapshot = await rooms.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> roomExist(String id) async {
    final doc = await rooms.doc(id).get();
    return doc.exists;
  }
}