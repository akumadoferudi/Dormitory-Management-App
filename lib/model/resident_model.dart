import 'dart:ffi';

class ResidentModel {
  final String email;
  final String photo;
  final String name;
  final String phone;
  final String tgl_masuk; // Update saat join kost, default = '' (Belum join kost)
  final int status_pembayaran; //0 = Bukan anggota kost, 1 = belum bayar, 2 = sudah bayar, 3 = telat bayar
  final String room_id;

  const ResidentModel(this.email, this.name, this.phone, this.tgl_masuk, this.status_pembayaran, this.photo, this.room_id);

  Map<String, dynamic> mapModel(){
    return {
      'email': this.email,
      'name': this.name,
      'phone': this.phone,
      'tgl_masuk': this.tgl_masuk,
      'status_pembayaran': this.status_pembayaran,
      'photo': this.photo,
      'room_id': this.room_id,
    };
  }
}