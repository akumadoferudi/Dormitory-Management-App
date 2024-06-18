import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_golekost/services/admin_service.dart';

import 'package:fp_golekost/services/collections/dorm.dart';
import 'package:fp_golekost/components/add_dorm_form.dart';

class AddDormPage extends StatefulWidget {
  const AddDormPage({super.key, required this.isResident, required this.admin_id});
  final bool isResident;
  final String admin_id;
  @override
  State<AddDormPage> createState() => _AddDormPageState();
}

class _AddDormPageState extends State<AddDormPage> {
  final DormCollections Dorm = DormCollections();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();

  Future<void> createData() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await DormCollections().storeDorm(fotoController.text, namaController.text, deskripsiController.text, alamatController.text, widget.admin_id);
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      genericErrorMessage("Unknown error occured!");
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kost'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: SingleChildScrollView(child: addDormForm(_formKey, namaController, alamatController, deskripsiController, fotoController, createData, {})),
    );
  }
}
