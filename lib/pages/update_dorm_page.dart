import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fp_golekost/services/collections/dorm.dart';
import 'package:fp_golekost/components/add_dorm_form.dart';

class UpdateDormPage extends StatefulWidget {
  const UpdateDormPage({super.key, required this.dormId});
  final String dormId;
  @override
  State<UpdateDormPage> createState() => _UpdateDormPageState();
}

class _UpdateDormPageState extends State<UpdateDormPage> {
  final DormCollections Dorm = DormCollections();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();

  Future<void> updateData() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await DormCollections().updateDorm(widget.dormId, fotoController.text, namaController.text, deskripsiController.text, alamatController.text);
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
    // Load the old dorm's data first
    Future<Map<String, dynamic>?>oldDataFuture = Dorm.getDormById(widget.dormId);
    return FutureBuilder<Map<String, dynamic>?>(
      future: oldDataFuture, builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
      if (!snapshot.hasData) {
        // while data is loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        // data loaded:
        final oldData = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tambah Kost'),
            backgroundColor: Colors.lightGreenAccent,
          ),
          body: SingleChildScrollView(child: addDormForm(_formKey, namaController, alamatController, deskripsiController, fotoController, updateData, oldData!)),
        );
      }
    },
    );
  }
}
