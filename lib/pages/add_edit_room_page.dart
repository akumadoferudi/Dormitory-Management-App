import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fp_golekost/services/collections/room_data.dart';
import 'package:fp_golekost/services/firestore_service.dart';

class AddEditRoomPage extends StatefulWidget {
  final RoomData? room;
  final String dormId;

  const AddEditRoomPage({super.key, this.room, required this.dormId});

  @override
  _AddEditRoomPageState createState() => _AddEditRoomPageState();
}

class _AddEditRoomPageState extends State<AddEditRoomPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageLinkController = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();

  bool _availability = true;
  List<String> _imageLinks = [];
  List<String> _facilities = [];

  bool isEditMode = false;

  FirestoreService _firestoreService = FirestoreService();
// TODO : Input Validation
  @override
  void initState() {
    super.initState();
    isEditMode = widget.room != null;
    if (isEditMode) {
      _nameController.text = widget.room!.name;
      _descriptionController.text = widget.room!.description;
      _priceController.text = widget.room!.price;
      _imageLinks = widget.room!.roomImages.map((image) => image.imageLink).toList();
      _facilities = widget.room!.roomFacilities.map((facility) => facility.name).toList();
      _availability = widget.room!.availability;
    }
  }

  void _saveRoom() async {
    var newRoom = RoomData(
      // ID will be generated on addition
      id: (isEditMode) ? (widget.room!.id) : (''),
      name: _nameController.text,
      description: _descriptionController.text,
      price: _priceController.text,
      roomImages: _imageLinks.map((link) => RoomImage(imageLink: link)).toList(),
      roomFacilities: _facilities.map((name) => Facility(name: name)).toList(),
      availability: _availability, dormId: widget.dormId,
    );

    if (isEditMode) {
      // Update room
      await _firestoreService.updateRoom(newRoom, context);
    } else {
      // Add room
      await _firestoreService.addRoom(newRoom);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEditMode? const Text('Edit Room') : const Text('Add Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 16),
              const Text('Images'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _imageLinkController,
                      decoration: const InputDecoration(labelText: 'Image Link'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _imageLinks.add(_imageLinkController.text);
                        _imageLinkController.clear();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                children: _imageLinks
                    .map((link) => Chip(
                  label: Text(link),
                  onDeleted: () {
                    setState(() {
                      _imageLinks.remove(link);
                    });
                  },
                ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Text('Facilities'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _facilityController,
                      decoration: const InputDecoration(labelText: 'Facility'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _facilities.add(_facilityController.text);
                        _facilityController.clear();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                children: _facilities
                    .map((facility) => Chip(
                  label: Text(facility),
                  onDeleted: () {
                    setState(() {
                      _facilities.remove(facility);
                    });
                  },
                ))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _saveRoom();
                },
                child: Text(isEditMode? 'Update Room' : 'Add Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}