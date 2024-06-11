import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/room_data.dart';
import '../utils/ui_utils.dart';

class FirestoreService {
  final CollectionReference rooms =
  FirebaseFirestore.instance.collection('rooms');

  // CREATE
  Future<void> addRoom(RoomData room) {
    return rooms.add(room.toFirestore());
  }

  // READ
  Stream<QuerySnapshot> getRoomsStream() {
    final roomsStream = rooms.snapshots();
    return roomsStream;
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


  Future<bool> roomsExist() async {
    final snapshot = await rooms.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }
}
