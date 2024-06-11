import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/room_data.dart';
import '../services/firestore_service.dart';
import '../widget/room_card.dart';
import 'detail_page.dart';
import 'add_edit_room_page.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEditRoomPage()));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getRoomsStream(),
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

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => RoomDetails(roomData: room)
                      )
                  );
                },
                child: RoomCard(
                  room: room,
                  onEdit: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddEditRoomPage(room: room),
                    ));
                  },
                  onDelete: () {
                    _firestoreService.deleteRoom(room.id, context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}