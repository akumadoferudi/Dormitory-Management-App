import 'package:flutter/material.dart';

class AdminIndexPage extends StatefulWidget {
  const AdminIndexPage({super.key});

  @override
  State<AdminIndexPage> createState() => _AdminIndexPageState();
}

class _AdminIndexPageState extends State<AdminIndexPage> {
  @override
  Widget build(BuildContext context) {
    const items = 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kost'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: ListView.builder(
        // jumlah lokasi kost
        itemCount: 4,
        itemBuilder: (context, index) {
          return ItemWidget(text: 'Hallo');
        },
      ),
    );
  }
}

// Class Widget
class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(child: Text(text)),
      ),
    );
  }
}
