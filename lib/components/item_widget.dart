// Class Widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.photo,
    required this.name,
    required this.address,
  });

  final String photo;
  final String name;
  final String address;

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
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RoomListPage(roomList: room)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}