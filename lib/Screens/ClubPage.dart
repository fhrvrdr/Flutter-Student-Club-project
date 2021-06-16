import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_club_project/services/listService.dart';

class ClubPage extends StatefulWidget {
  DocumentReference ref;
  ClubPage({@required this.ref});

  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  ListService _listService = ListService();
  CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');

  bool _sucsees;
  String _messsage;
  String _message2;

  @override
  Widget build(BuildContext context) {
    final String docrefid = widget.ref.id;
    final docref = widget.ref;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    child: FutureBuilder(
                      future: clubs.doc(docrefid).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data.data();
                          return Image.network(
                            "${data['clubAvatar']}",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        }
                        return Text("loading");
                      },
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: clubs.doc(docrefid).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = snapshot.data.data();
                        return Text(
                          "${data['clubName']}",
                          style: TextStyle(
                            fontSize: 20,
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
                  FutureBuilder(
                    future: clubs.doc(docrefid).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = snapshot.data.data();
                        return Text(
                          "İletişim : ${data['clubAdmin']}",
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
                  FutureBuilder(
                    future: clubs.doc(docrefid).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = snapshot.data.data();
                        return Text(
                          "${data['clubDescription']}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                      return Text("loading");
                    },
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        _sucsees == null ? '' : _messsage ?? '',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        _sucsees == null ? '' : _message2 ?? '',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        onPressed: () {
                          _listService.addClub(docref);
                          setState(() {
                            _messsage = "İşlem Başarıyla Gerçekleşti! ";
                            _message2 =
                                "Lütfen Anasayfaya dönüp sayfayı yenileyin !";
                            _sucsees = true;
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.black26)),
                        color: Colors.blue,
                        child: Text(
                          "Katıl / Ayrıl",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
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
