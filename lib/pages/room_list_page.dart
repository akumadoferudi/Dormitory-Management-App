import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fp_golekost/services/collections/dorm.dart';
import 'package:fp_golekost/pages/add_dorm_page.dart';
import 'package:fp_golekost/components/item_widget.dart';
import 'package:fp_golekost/services/collections/room_data.dart';
import 'package:fp_golekost/services/firestore_service.dart';
import 'package:fp_golekost/components/room_card.dart';
import 'package:fp_golekost/pages/room_detail_page.dart';
import 'package:fp_golekost/services/resident_service.dart';
import 'add_edit_room_page.dart';

class RoomListPage extends StatefulWidget {
  final String dormId;
  final bool isResident;

  const RoomListPage(
      {super.key, required this.dormId, required this.isResident});

  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rooms List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        AddEditRoomPage(dormId: widget.dormId)));
              },
            ),
          ],
        ),
        body: widget.isResident ? StreamBuilder<QuerySnapshot>(
            stream: ResidentService()
                .getUser(FirebaseAuth.instance.currentUser!.email!),
            builder: (context, snapshot) {
              // if has data, get all documents from collection
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[0].data() as Map<String, dynamic>;
                String id = snapshot.data!.docs[0].id;
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestoreService.getRoomsStream(widget.dormId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final List<RoomData> rooms = snapshot.data!.docs.map((doc) {
                      return RoomData.fromFirestore(doc);
                    }).toList();
                    if (rooms.isEmpty) {
                      return Center(
                        child: Text("No Rooms."),
                      );
                    }
                    return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return GestureDetector(
                          onTap: () async {
                            final userData = await ResidentService().getUserByRoom(room.id);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RoomDetails(
                                      roomData: room,
                                      dormId: widget.dormId,
                                      isResident: widget.isResident,
                                  residentId: id,
                                  curResidentData: userData,
                                    )));
                          },
                          child: RoomCard(
                            room: room,
                            onEdit: () {
                              widget.isResident
                                  ? null
                                  : Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (context) => AddEditRoomPage(
                                        room: room,
                                        dormId: widget.dormId,
                                      ),
                                    ));
                            },
                            onDelete: () {
                              widget.isResident
                                  ? null
                                  : _firestoreService.deleteRoom(
                                      room.id, context);
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return Text("Please wait...");
            }) :
        StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getRoomsStream(widget.dormId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<RoomData> rooms = snapshot.data!.docs.map((doc) {
              return RoomData.fromFirestore(doc);
            }).toList();
            if (rooms.isEmpty) {
              return Center(
                child: Text("No Rooms."),
              );
            }
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                return GestureDetector(
                  onTap: () async {
                    final userData = await ResidentService().getUserByRoom(room.id);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RoomDetails(
                          roomData: room,
                          dormId: widget.dormId,
                          isResident: widget.isResident,
                          residentId: "",
                          curResidentData: userData,
                        )));
                  },
                  child: RoomCard(
                    room: room,
                    onEdit: () {
                      widget.isResident
                          ? null
                          : Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => AddEditRoomPage(
                          room: room,
                          dormId: widget.dormId,
                        ),
                      ));
                    },
                    onDelete: () {
                      widget.isResident
                          ? null
                          : _firestoreService.deleteRoom(
                          room.id, context);
                    },
                  ),
                );
              },
            );
          },
        )

    );
  }
}
