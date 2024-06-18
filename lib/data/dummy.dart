import 'package:fp_golekost/services/collections/room_data.dart';

final RoomData dummyRoomData = RoomData(
  id: '',
  name: 'Kamar A',
  description:
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  price: '1.500.000',
  roomImages: [
    RoomImage(imageLink: 'https://picsum.photos/id/234/400/200'),
    RoomImage(imageLink: 'https://picsum.photos/id/378/400/200'),
  ],
  roomFacilities: [
    Facility(name: 'Free Wi-Fi'),
    Facility(name: 'Air Conditioning'),
  ],
  availability: true, dormId: 't3NLsmC4uCZw8C9HlRzg',
);

Map<String, dynamic> dummyOccupantData = {
  'name': 'Budi Sumadi',
  'photo': 'https://picsum.photos/id/433/128/128',
  'email': 'Budiii@example.com',
  'phone': '0813420777',
  'tgl_masuk': '2022-01-01',
  'status_pembayaran': 2,
};