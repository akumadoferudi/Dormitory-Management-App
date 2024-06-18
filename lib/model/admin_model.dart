import 'dart:ffi';

class AdminModel {
  final String email;
  final String photo;
  final String name;
  final String phone;

  const AdminModel(this.email, this.name, this.phone, this.photo);

  Map<String, dynamic> mapModel() {
    return {
      'email': this.email,
      'name': this.name,
      'phone': this.phone,
      'photo': this.photo
    };
  }
}
