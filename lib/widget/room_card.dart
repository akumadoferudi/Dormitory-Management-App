import 'package:flutter/material.dart';

import '../model/room_data.dart';
import 'carousel_widget.dart';

class RoomCard extends StatelessWidget {
  final RoomData room;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RoomCard({
    super.key,
    required this.room,
    required this.onEdit,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CarouselWidget(imageLinks: room.roomImages.map((image) => image.imageLink).toList()),
          ListTile(
            title: Text(room.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${room.description}'),
                Text('Price: ${room.price}'),
                Text('Facilities: ${room.roomFacilities.map((f) => f.name).join(', ')}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}