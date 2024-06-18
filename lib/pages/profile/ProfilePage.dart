import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_golekost/model/resident_model.dart';
import 'package:fp_golekost/pages/dorm_list_page.dart';
import 'package:fp_golekost/pages/profile/UpdateProfilePage.dart';
import 'package:fp_golekost/pages/room_detail_page.dart';
import 'package:fp_golekost/services/admin_service.dart';
import 'package:fp_golekost/services/collections/room_data.dart';
import 'package:fp_golekost/services/firestore_service.dart';
import 'package:fp_golekost/services/resident_service.dart';
import 'ProfileMenu.dart';
import 'ViewProfilePage.dart';

class ProfilePage extends StatelessWidget {
  final bool isResident;

  ProfilePage({Key? key, required this.isResident}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    String tProfile = "Profile";
    String tProfileHeading = "ProfileH";
    String tProfileSubHeading = "ProfileSH";
    const String tViewProfile = "View Profile";
    String userRoomId = "";
    String userId = "";
    final service = isResident ? ResidentService() : AdminService();
    final userDataStream = service.getUser(user.email!);
    Map<String, dynamic>? userData;

    final tPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    const tDefaultSize = 10.0;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left)),
        title: Text(tProfile, style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              /// -- IMAGE
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
                      child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.black, size: 20),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateProfilePage(
                                        isResident: isResident,
                                      )))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                  stream: userDataStream,
                  builder: (context, snapshot) {
                    // if has data, get all documents from collection
                    if (snapshot.hasData) {
                      Map<String, dynamic> data =
                      snapshot.data!.docs[0].data() as Map<String, dynamic>;
                      userData = data;
                      userId = snapshot.data!.docs[0].id;
                      userRoomId = data["room_id"];
                      print(userRoomId);
                      print(data["room_id"]);
                      return Column(children: [
                        Text(data['name'] ?? tProfileHeading,
                            style: Theme.of(context).textTheme.headlineLarge),
                        Text(data['email'] ?? tProfileSubHeading,
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 20),

                        /// -- BUTTON
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isResident && !await FirestoreService().roomExist(data["room_id"])){
                                data["room_id"] = "";
                                await ResidentService().updateUser(userId, ResidentModel(data['email'], data['name'], data['phone'], data['tgl_masuk'], data['status_pembayaran'], data['photo'], data['room_id']));
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => ViewProfilePage(
                                    isResident: isResident,
                                  )));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: tPrimaryColor,
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text(tViewProfile,
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),

                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 10),

                        /// -- MENU
                        ProfileMenuWidget(
                          title: "Dorms",
                          icon: Icons.house,
                          onPress: () =>
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => DormListPage(
                                    isResident: isResident,
                                  ))),
                        ),
                        const Divider(),
                        const SizedBox(height: 10),
                        if (userRoomId != "")
                          ProfileMenuWidget(
                            title: "My room",
                            icon: Icons.door_back_door_outlined,
                            onPress: () async {
                              // Get the specific room info
                              if (await FirestoreService().roomExist(userRoomId)) {
                                  final roomSnapshot = await FirestoreService()
                                      .getOccupantRoom(userRoomId);
                                  if (roomSnapshot.exists) {
                                    final roomData =
                                        RoomData.fromFirestore(roomSnapshot);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            RoomDetails(
                                          roomData: roomData,
                                          dormId: roomData.dormId,
                                          // Assuming RoomData has dormId property
                                          isResident: isResident,
                                          residentId: userId,
                                          curResidentData: userData!,
                                        ),
                                      ),
                                    );
                                  }
                                }
                            },
                          ),
                        const Divider(),
                        const SizedBox(height: 10),
                        ProfileMenuWidget(
                            title: "Logout",
                            icon: Icons.logout,
                            textColor: Colors.red,
                            endIcon: false,
                            onPress: signUserOut),
                      ]);
                    } else {
                      return const Text("Error retrieving data!");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
