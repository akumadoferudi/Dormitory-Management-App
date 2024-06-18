import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_golekost/model/resident_model.dart';
import 'package:fp_golekost/services/admin_service.dart';
import 'package:fp_golekost/services/resident_service.dart';
import 'package:intl/intl.dart';


class ViewProfilePage extends StatelessWidget {
  final bool isResident;
  final user = FirebaseAuth.instance.currentUser!;

  Map<int, String> role = {
    0: "Penghuni",
    1: "Pemilik",
    2: "Debug"
  };
  Map<int, String> status = {
    -1: "Tidak ada (Pemilik)",
    0: "Bukan anggota kost",
    1: "Belum membayar",
    2: "Sudah membayar",
    3: "Telat membayar"
  };

  ViewProfilePage({Key? key, required this.isResident}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = isResident ? ResidentService() : AdminService();
    final userData = service.getUser(user.email!);
    const placeholderText = "Placeholder";
    final tPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    const tFormHeight = 30.0;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.chevron_left)),
        title: Text("Profile", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                    //TODO : Allow user to upload profile picture/link for profile picture
                    SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: NetworkImage('https://placehold.co/600x400/png'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100), color: tPrimaryColor),
                      child: const Icon(Icons.camera, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields

                Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(stream: userData,
                    builder: (context, snapshot) {
                      // if has data, get all documents from collection
                      if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!.docs[0].data() as Map<String, dynamic>;

                        // display as list
                        return Column(
                          children: [
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(data['name']), prefixIcon: Icon(Icons.account_circle), prefixText: "Nama Lengkap"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(data['email']), prefixIcon: Icon(Icons.email), prefixText: "Email"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(data['phone']), prefixIcon: Icon(Icons.phone), prefixText: "Nomor HP"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(role[isResident ? 0 : 1]!), prefixIcon: Icon(Icons.account_box), prefixText: "Jenis Akun"),
                            ),

                            const SizedBox(height: tFormHeight - 20),
                            isResident ? TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(status[data['status_pembayaran']]!), prefixIcon: Icon(Icons.payments), prefixText: "Status pembayaran kost (bulan ini)"),
                            ) : const SizedBox(height: 5),
                            const SizedBox(height: tFormHeight - 20),
                            isResident ? TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(data['tgl_masuk'] == '' ? "Belum masuk kost" : DateFormat.yMd().format(DateTime.parse(data['tgl_masuk']).toLocal())), prefixIcon: Icon(Icons.calendar_month), prefixText: "Tanggal Mulai Sewa Kost (Saat Ini)"),
                            ) : const SizedBox(height: 5),
                            // TextField(
                            //   obscureText: true,
                            //   decoration: InputDecoration(
                            //     label: const Text(placeholderText),
                            //     prefixIcon: const Icon(Icons.fingerprint),
                            //     suffixIcon:
                            //     IconButton(icon: const Icon(Icons.place), onPressed: () {}),
                            //   ),
                            // ),
                          ],
                        );
                      }
                      else {
                        return const Text("");
                      }
                    }),

                    const SizedBox(height: tFormHeight),


                    // -- Created Date and Delete Button


                  ],
                ),

            ],
          ),
        ),
      ),
    );
  }
}