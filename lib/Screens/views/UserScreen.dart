import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_club_project/Screens/views/WelcomePage.dart';
import 'package:flutter_club_project/services/authService.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  AuthService _authService = AuthService();
  CollectionReference users = FirebaseFirestore.instance.collection('Person');

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    var _text;
    bool _sucsees;
    String _bilgi;

    return Scaffold(
      appBar: AppBar(
        title: Text("Hesap Detayları"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                _authService.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              }),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: users.doc(_authService.getUserid()).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = snapshot.data.data();

                        _text =
                            "Merhaba ' ${data['userName']} ' . Bu sayafadan şimdilik ismini güncelleyebilir ve hesabından çıkış yapabilirsin.";
                        return Text(
                          _text,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }

                      return Text("loading");
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                      labelText: "İsim Soyisim",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black38)),
                    onPressed: () {
                      _authService.updatePerson(_nameController.text);
                    },
                    color: Colors.white,
                    child: Text(
                      "Güncelle",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(_sucsees == null ? '' : _bilgi ?? ''),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
