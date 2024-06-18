import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fp_golekost/data/dummy.dart';
import 'package:fp_golekost/services/collections/room_data.dart';
import 'package:fp_golekost/services/firestore_service.dart';
import 'package:fp_golekost/components/carousel_widget.dart';
import 'package:fp_golekost/services/resident_service.dart';
import 'add_edit_room_page.dart';

class RoomDetails extends StatefulWidget {
  final String dormId;
  final String residentId;
  final Map<String, dynamic> curResidentData;
  final bool isResident;
  final RoomData roomData;
  final FirestoreService firestoreService = FirestoreService();
  Map<int, String> status = {
    -1: "Tidak ada (Pemilik)",
    0: "Bukan anggota kost",
    1: "Belum membayar",
    2: "Sudah membayar",
    3: "Telat membayar"
  };

  RoomDetails({Key? key, required this.roomData, required this.dormId, required this.isResident, required this.residentId, required this.curResidentData}) : super(key: key);

  @override
  _RoomDetailsState createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  bool _isOwnerView = true;
  bool _isOccupied = false;

  // TODO: Temporary Occupant Data
  Map<String, dynamic> _occupantData = dummyOccupantData;

  Future<void> deleteRoom(BuildContext context) async {
    try {
      await widget.firestoreService.deleteRoom(widget.roomData.id, context);
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting room: $e');
    }
  }

  Future<void> editRoom(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddEditRoomPage(room: widget.roomData, dormId: widget.dormId,),
    ));
  }

  Future<void> bookRoom() async {
    final CollectionReference residents = FirebaseFirestore.instance.collection('resident');
    final CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');
    bool hasRoom = false;
    await residents.doc(widget.residentId).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        hasRoom = (data["room_id"] != "");
        // ...
      },
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              hasRoom ? "Do you want to leave?" : "Do you want to book this room?",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No, i changed my mind.",
                  style: TextStyle(color: Colors.white),)),
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await residents.doc(widget.residentId).update({"status_pembayaran": 2, "tgl_masuk": DateTime.now().toString(),"room_id": hasRoom ? "" : widget.roomData.id});
                  await rooms.doc(widget.roomData.id).update({"availability": hasRoom});
                  genericErrorMessage("Occupancy updated.");
                },
                child: Text("Yes.",
                  style: TextStyle(color: Colors.white),))
          ],
        );
      },
    );
  }

  void genericErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              msg,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void getCurrentResident() async {
    _occupantData = await ResidentService().getUserByRoom(widget.roomData.id);
  }

  @override
  void initState() {
    super.initState();
    _isOwnerView = !widget.isResident;
    _isOccupied =!widget.roomData.availability;
    _occupantData = widget.curResidentData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
        actions: [
          !_isOwnerView && (!_isOccupied || (_occupantData["email"] == FirebaseAuth.instance.currentUser!.email)) ? IconButton(
            icon: const Icon(Icons.handshake),
            onPressed: () => bookRoom(),
          ) : Container(),
          _isOwnerView
              ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => editRoom(context),
          )
              : Container(),
          _isOwnerView
              ? IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => deleteRoom(context),
          )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CarouselWidget(
                  imageLinks: widget.roomData.roomImages
                      .map((image) => image.imageLink)
                      .toList(),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.roomData.name,
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.roomData.description,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Harga: Rp ${widget.roomData.price}/bulan',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Availability:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(_isOccupied ? "Occupied" : "Free")
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Fasilitas:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.roomData.roomFacilities.isNotEmpty
                    ? widget.roomData.roomFacilities
                    .map((facility) => Text('- ${facility.name}'))
                    .toList()
                    : [
                  const Text('-'),
                ],
              ),
              _isOccupied
                  ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Occupant:',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(_occupantData['photo']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            _isOwnerView
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: ${_occupantData['name']}'),
                                Text('Email: ${_occupantData['email']}'),
                                Text('Phone Number: ${_occupantData['phone']}'),
                                Text('Entry Date: ${_occupantData['tgl_masuk']}'),
                                Text('Payment Status: ${widget.status[_occupantData['status_pembayaran']]}'),
                              ]
                            )
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_occupantData['name']}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ]
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}