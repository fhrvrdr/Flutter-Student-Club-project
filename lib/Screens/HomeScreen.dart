import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_club_project/Screens/ChatRooms.dart';
import 'package:flutter_club_project/Screens/ClubList.dart';
import 'package:flutter_club_project/Screens/UserScreen.dart';
import 'package:flutter_club_project/services/authService.dart';
import 'package:flutter_club_project/services/listService.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService _authService = AuthService();
  ListService _listService = ListService();

  sayac(int sayi) {
    while (sayi < sayi + 2) {
      return sayi += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          "BU KULÜP",
          style: TextStyle(color: Colors.blue),
        )),
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            Spacer(
              flex: 3,
            ),
            IconButton(
                icon: Icon(
                  Icons.question_answer,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatRooms()));
                }),
            Spacer(),
            IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserScreen()));
                }),
            Spacer(),
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh),
              color: Colors.white,
            ),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ClubList()));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Person')
            .doc(_authService.getUserid())
            .get(),
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

          return ListView.builder(
            itemCount: snapshot.data['clubs'].length,
            itemBuilder: (context, index) {
              final deneme = List.castFrom(snapshot.data["clubs"]).toList();
              var _future = FirebaseFirestore.instance
                  .collection('clubs')
                  .doc(deneme[index])
                  .get();

              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                title: FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data.data();
                      if (snapshot.data.data() == null) {
                        return Text("");
                      } else {
                        return Text(
                          "${data['clubName']}",
                          style:
                              TextStyle(fontFamily: 'OpenSans', fontSize: 18),
                        );
                      }
                    }
                    return Text("Loading");
                  },
                ),
                leading: Container(
                  child: FutureBuilder(
                    future: _future,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = snapshot.data.data();
                        if (snapshot.data.data() == null) {
                          return SizedBox.shrink();
                        } else {
                          return Image.network("${data['clubAvatar']}");
                        }
                      }
                      return Text("loading");
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
