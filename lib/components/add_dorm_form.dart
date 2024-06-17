
import 'package:flutter/material.dart';
// TODO : Display old data for update

Widget addDormForm(_formKey, TextEditingController nama, TextEditingController alamat, TextEditingController deskripsi, TextEditingController foto, Function onValidate, Map<String, dynamic> oldData) {
  nama.text = oldData.isEmpty ? "" : oldData["name"];
  alamat.text = oldData.isEmpty ? "" : oldData["address"];
  deskripsi.text = oldData.isEmpty ? "" : oldData["description"];
  foto.text = oldData.isEmpty ? "" : oldData["photo"];
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(

          controller: nama,
          decoration: const InputDecoration(
            hintText: 'Nama kost',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        TextFormField(
          controller: alamat,
          decoration: const InputDecoration(
            hintText: 'Alamat kost',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        TextFormField(
          controller: deskripsi,
          decoration: const InputDecoration(
            hintText: 'Deskripsi',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        TextFormField(
          controller: foto,
          decoration: const InputDecoration(
            hintText: 'Foto kost',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.
              if (_formKey.currentState!.validate()) {
                // Process data.
                onValidate();
              }
            },
            child: const Text('Submit'),
          ),
        ),
      ],
    ),
  );
}

