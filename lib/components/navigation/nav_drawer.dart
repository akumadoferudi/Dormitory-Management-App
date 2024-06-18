import 'package:flutter/material.dart';
import 'package:fp_golekost/pages/profile/ProfilePage.dart';
import 'package:fp_golekost/pages/profile/ViewProfilePage.dart';

import '../../pages/login_register/LoginPage/auth_page.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key, required this.isResident});
  final bool isResident;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            // UserAccountsDrawerHeader( // <-- SEE HERE
            //   decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary),
            //   accountName: Text(
            //     "Pinkesh Darji",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   accountEmail: Text(
            //     "pinkesh.earth@gmail.com",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   currentAccountPicture: FlutterLogo(),
            // ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AuthPage(
                    )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
