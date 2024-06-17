import 'package:flutter/material.dart';

import 'package:fp_golekost/data/dummy.dart';
import 'package:fp_golekost/services/collections/room_data.dart';
import 'package:fp_golekost/services/firestore_service.dart';
import 'package:fp_golekost/components/carousel_widget.dart';
import 'add_edit_room_page.dart';

class RoomDetails extends StatefulWidget {
  final RoomData roomData;
  final FirestoreService firestoreService = FirestoreService();

  RoomDetails({Key? key, required this.roomData}) : super(key: key);

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
      builder: (context) => AddEditRoomPage(room: widget.roomData),
    ));
  }

  @override
  void initState() {
    super.initState();
    _isOccupied =!widget.roomData.availability;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
        actions: [
          IconButton(
            // TODO: Temporary admin switch
            icon: Icon(_isOwnerView? Icons.person : Icons.person_outline),
            onPressed: () {
              setState(() {
                _isOwnerView =!_isOwnerView;
              });
            },
          ),
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
      body: Padding(
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
                IconButton(
                  icon: Icon(_isOccupied? Icons.check_circle : Icons.cancel),
                  onPressed: () {
                    // TODO: Temporary occupied switch
                    setState(() {
                      _isOccupied =!_isOccupied;
                    });
                  },
                ),
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
                              Text('Phone Number: ${_occupantData['phoneNumber']}'),
                              Text('Entry Date: ${_occupantData['entryDate']}'),
                              Text('Payment Status: ${_occupantData['paymentStatus']?'Lunas':'Belum Lunas'}'),
                            ],
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
    );
  }
}