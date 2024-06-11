import 'package:cloud_firestore/cloud_firestore.dart';

class roomCollections {
  // get collection of rooms
  final CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // GET DORM BY ID
  Future<Map<String, dynamic>?> getRoomById(String documentId) async {
    try {
      DocumentSnapshot docSnapshot = await rooms.doc(documentId).get();

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

  // GET RESIDENT DORM
  Future<Map<String, dynamic>?> getResidentRoomStream(String residentId) async {
    try {
      DocumentSnapshot residentSnapshot = await users.doc(residentId).get();

      if (residentSnapshot.exists) {
        final resident = residentSnapshot.data() as Map<String, dynamic>?;
        print(resident);
        DocumentSnapshot residentRoomSnapshot;
        if (resident!["room_id"] != null) {
          // GET RESIDENT ROOM FROM ROOM ID
          residentRoomSnapshot = await rooms.doc(resident["room_id"]).get();
          return residentRoomSnapshot as Map<String, dynamic>?;
        }
        print ('Penghuni kost belum memiliki kamar');
        return null;
      } else {
        print('Penghuni kost tidak ditemukan!');
        return null;
      }
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }

  // CREATE
  Future<void> storeRoom(String photo, String name, String description, String address) async {
    try {
      await rooms.add({
        'photo': photo, // photo thumbnail
        'name': name,
        'description': description,
        'address': address,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now()
      });
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  // UPDATE
  Future<void> updateRoom(String documentId,  Map<String, dynamic> updatedData) async {
    try {
      await rooms.doc(documentId).update(updatedData);
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
  Future<void> deleteRoom(String docId) async {
    try {
      await rooms.doc(docId).delete();
      print('Document successfully deleted!');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}