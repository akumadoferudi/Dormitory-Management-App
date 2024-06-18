// Class Widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/room_list_page.dart';
import '../pages/update_dorm_page.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.photo,
    required this.name,
    required this.address, required this.dormId, required this.onDelete, required this.isResident, required this.admin_id,
  });
  final String dormId;
  final String admin_id;
  final String photo;
  final String name;
  final String address;
  final bool isResident;
  final Future<void> Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: SizedBox(
          height: 350,
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: Image(
                    image: NetworkImage(photo),
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  title: Text(name),
                  subtitle: Text(address),
                ),
                // See rooms
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RoomListPage(dormId: dormId,)),
                        );
                      },
                    ),
                    // Update
                    isResident ? SizedBox(width: 1, height: 1,): IconButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateDormPage(dormId: dormId, isResident: isResident, admin_id: admin_id,)),
                      );
                    }, icon: const Icon(Icons.edit)),

                    // Delete
                    isResident ? SizedBox(width: 1, height: 1,): IconButton(onPressed: ()=>onDelete(dormId), icon: const Icon(Icons.delete)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}