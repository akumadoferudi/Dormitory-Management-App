import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_golekost/model/admin_model.dart';
import 'package:fp_golekost/model/resident_model.dart';
import 'package:fp_golekost/pages/profile/ViewProfilePage.dart';
import 'package:fp_golekost/services/admin_service.dart';
import 'package:fp_golekost/services/resident_service.dart';
import 'package:fp_golekost/services/validationService.dart';
import 'package:intl/intl.dart';

class UpdateProfilePage extends StatefulWidget {
  final bool isResident;
  final user = FirebaseAuth.instance.currentUser!;
  Map<int, String> status = {
    -1: "Tidak ada (Pemilik)",
    0: "Bukan anggota kost",
    1: "Belum membayar",
    2: "Sudah membayar",
    3: "Telat membayar"
  };

  UpdateProfilePage({Key? key, required this.isResident}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final String _placeholderPhoto = "placeholder_folder/placeholder.jpg";

  //TODO : SETUP INPUT VALIDATION
  late DateTime selectedDate = DateTime(1900);
  int? selectedRole = 0;
  String? id;
  dynamic oldUser;

  // text editing controllers
  final hpController = TextEditingController();
  final namaController = TextEditingController();

  //TODO : Validate and send update request
  Future<void> updateData(dynamic oldUser) async {
    // Loading Indicator
    final service = widget.isResident ? ResidentService() : AdminService();
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //TODO : Implementasi sanitazion dan validation pakai package khusus (sanitizationChain & validationChain)
    print(oldUser.phone.length);
    // If password confirmation failed
    if (!ValidationService().isPhoneNumber(hpController.text)) {
      Navigator.pop(context);
      genericErrorMessage("Invalid phone number!");
    }
    //TODO : Validation untuk tanggal dan gender, walau user tidak bisa pilih selain pilihan, mungkin bisa jadi vulnerability
    else {
      // Sign in validation
      try {
        dynamic newUser = widget.isResident
            ? ResidentModel(
                oldUser.email,
                namaController.text == '' ? oldUser.name : namaController.text,
                hpController.text == '' ? oldUser.phone : hpController.text,
                oldUser.tgl_masuk,
                oldUser.status_pembayaran,
                _placeholderPhoto, oldUser.room_id)
            : AdminModel(
                oldUser.email,
                namaController.text == '' ? oldUser.name : namaController.text,
                hpController.text == '' ? oldUser.phone : hpController.text,
                _placeholderPhoto);

        //TODO : Figure out how to handle both auth and database exception so firebaseauth account is deleted if user data encounters exception
        final credential = await service.updateUser(id!, newUser);
        // Pop loading indicator if success
        Navigator.pop(context);
        Navigator.pop(context);
        //Refresh after update
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ViewProfilePage(
                  isResident: widget.isResident,
                )));
      } on FirebaseException catch (e) {
        // Pop loading indicator before displaying error
        Navigator.pop(context);
        print(e.code);
        genericErrorMessage("Unknown error occurred!");
      }

      // If another type of error
      catch (e) {
        print(e);
      }
    }
  }

  Future<void> deleteUser() async {
    final service = widget.isResident ? ResidentService() : AdminService();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              "Are you sure",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No, i changed my mind.")),
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await widget.user.delete();
                  FirebaseAuth.instance.signOut();
                  service.deleteUser(id!);
                  genericErrorMessage("User deleted");
                },
                child: Text("Yes."))
          ],
        );
      },
    );
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
    final service = widget.isResident ? ResidentService() : AdminService();
    final Stream<QuerySnapshot> userData = service.getUser(widget.user.email!);
    const placeholderText = "Placeholder";
    final tPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    const tFormHeight = 30.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left)),
        title: Text("Edit Profile",
            style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: NetworkImage(
                                'https://placehold.co/600x400/png'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: tPrimaryColor),
                      child: const Icon(Icons.camera,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                  child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: userData,
                      builder: (context, snapshot) {
                        // if has data, get all documents from collection
                        if (snapshot.hasData) {
                          Map<String, dynamic> data = snapshot.data!.docs[0]
                              .data() as Map<String, dynamic>;
                          id = snapshot.data!.docs[0].id;
                          oldUser = widget.isResident
                              ? ResidentModel(
                                  data['email'],
                                  data['name'],
                                  data['phone'],
                                  data['tgl_masuk'],
                                  data['status_pembayaran'],
                                  _placeholderPhoto,
                                  data['room_id']
                          )
                              : AdminModel(data['email'], data['name'],
                                  data['phone'], _placeholderPhoto);
                          // display as list
                          return Column(
                            children: [
                              //TODO : Add field controllers
                              TextField(
                                controller: namaController,
                                decoration: InputDecoration(
                                    label: Text(data['name']),
                                    prefixIcon: Icon(Icons.account_circle),
                                    hintText: "Nama Lengkap"),
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(color: tPrimaryColor),
                                    label: Text(data['email']),
                                    prefixIcon: Icon(Icons.email),
                                    hintText: "Email"),
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              TextField(
                                controller: hpController,
                                decoration: InputDecoration(
                                    label: Text(data['phone']),
                                    prefixIcon: Icon(Icons.phone),
                                    hintText: "Nomor HP"),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          );
                        } else {
                          return const Text("");
                        }
                      }),
                  const SizedBox(height: tFormHeight - 20),
                  const SizedBox(height: tFormHeight - 20),
                  // TextFormField(
                  //   obscureText: true,
                  //   decoration: InputDecoration(
                  //     label: const Text(placeholderText),
                  //     prefixIcon: const Icon(Icons.fingerprint),
                  //     suffixIcon:
                  //     IconButton(icon: const Icon(Icons.place), onPressed: () {}),
                  //   ),

                  const SizedBox(height: tFormHeight),

                  // -- Form Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //Validate and update data
                        updateData(oldUser!);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: tPrimaryColor,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: const Text("Edit Profile",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: tFormHeight),
                  ElevatedButton(
                    onPressed: () {
                      deleteUser();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withOpacity(0.1),
                        elevation: 0,
                        foregroundColor: Colors.red,
                        shape: const StadiumBorder(),
                        side: BorderSide.none),
                    child: const Text("Delete User Account"),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
