import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fp_golekost/services/collections/dorm.dart';
import 'package:fp_golekost/components/add_dorm_form.dart';

class AddDormPage extends StatefulWidget {
  const AddDormPage({super.key});

  @override
  State<AddDormPage> createState() => _AddDormPageState();
}

class _AddDormPageState extends State<AddDormPage> {
  final DormCollections Dorm = DormCollections();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kost'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: addDormForm(_formKey),
    );
  }
}
