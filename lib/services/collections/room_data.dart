
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomData {
  final String id;
  final String dormId;
  final String name;
  final String description;
  final String price;
  final List<RoomImage> roomImages;
  final List<Facility> roomFacilities;
  final bool availability;

  RoomData({
    required this.id,
    required this.dormId,
    required this.name,
    required this.description,
    required this.price,
    required this.roomImages,
    required this.roomFacilities,
    required this.availability,
  });

  factory RoomData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RoomData(
      id: doc.id,
      dormId: data['dorm_id'],
      name: data['name'],
      description: data['description'],
      price: data['price'],
      roomImages: (data['roomImages'] as List)
          .map((item) => RoomImage(imageLink: item))
          .toList(),
      roomFacilities: (data['roomFacilities'] as List)
          .map((item) => Facility(name: item))
          .toList(),
      availability: data['availability'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'dorm_id': dormId,
      'name': name,
      'description': description,
      'price': price,
      'roomImages': roomImages.map((item) => item.imageLink).toList(),
      'roomFacilities': roomFacilities.map((item) => item.name).toList(),
      'availability': availability,
    };
  }
}

class RoomImage {
  final String imageLink;

  RoomImage({required this.imageLink});
}

class Facility {
  final String name;

  Facility({required this.name});
}