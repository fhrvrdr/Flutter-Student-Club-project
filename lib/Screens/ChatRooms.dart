import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_club_project/Screens/chatPage.dart';
import 'package:flutter_club_project/services/authService.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: () {})],
        title: Text("Sohbet"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('clubs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Icon(Icons.error),
            );
          }
          final QuerySnapshot querySnapshot = snapshot.data;

          return ListView.builder(
            itemCount: querySnapshot.size,
            itemBuilder: (context, index) {
              final map = querySnapshot.docs[index].data();

              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                              ref: querySnapshot.docs[index].reference)));
                },
                leading: Container(
                  child: (map as Map)['clubAvatar'] != null
                      ? Image.network((map as Map)['clubAvatar'])
                      : SizedBox.shrink(),
                ),
                title: Text(
                  (map as Map)['clubName'],
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 18),
                ),
                subtitle: Text((map as Map)['clubComment'],
                    style: TextStyle(fontFamily: 'OpenSans', fontSize: 14)),
              );
            },
          );
        },
      ),
    );
  }
}
