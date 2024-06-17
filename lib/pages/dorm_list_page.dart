import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fp_golekost/services/collections/dorm.dart';
import 'package:fp_golekost/pages/add_dorm_page.dart';
import 'package:fp_golekost/components/item_widget.dart';

class DormListPage extends StatefulWidget {
  const DormListPage({super.key});

  @override
  State<DormListPage> createState() => _DormListPageState();
}

class _DormListPageState extends State<DormListPage> {
  final DormCollections Dorm = DormCollections();

  // void openDormForm({String? docID}) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: TextField(
  //         controller: textController,
  //       ),
  //       actions: [
  //         // save button
  //         ElevatedButton(
  //           onPressed: () {
  //             // add new note
  //             if (docID == null) {
  //               firestoreService.addNote(textController.text);
  //             }
  //             // update an existing note
  //             else {
  //               firestoreService.updateNote(docID, textController.text);
  //             }
  //             // clear text controller
  //             textController.clear();
  //             // close the box
  //             Navigator.pop(context);
  //           },
  //           child: Text('Add'),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    const items = 4;

    return Scaffold(
      // resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text('Pilih Kost'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add new dorm',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDormPage()),
              );
            },
          )
        ],
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Dorm.getDormsStream(),
        builder: (context, snapshot) {
          // If we have data, then get all docs
          if (snapshot.hasData) {
            List dormList = snapshot.data!.docs;

            // display all notes
            return ListView.builder(
              // shrinkWrap: true,
              itemCount: dormList.length,
              itemBuilder: (context, index) {
                // get each individual doc
                DocumentSnapshot document = dormList[index];
                String docId = document.id;

                // print('INI ERRORNYA!!!');
                print(document.data());
                // print('INI ERRORNYA!!!');

                // get note from each doc
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String dormPhoto = data['photo'];
                String dormName = data['name'];
                String dormAddress = data['address'];

                // display as a list tile
                return ItemWidget(photo: dormPhoto, name: dormName, address: dormAddress);
              },
            );
          }

          // if no data
          else {
            return const Text('No Dorm...');
          }
        },
      ),
    );
  }
}
