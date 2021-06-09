import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_club_project/services/authService.dart';
import 'package:flutter_club_project/services/chatService.dart';

class ChatPage extends StatefulWidget {
  DocumentReference ref;
  ChatPage({@required this.ref});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');
  ChatService _chatService = ChatService();
  final TextEditingController _message = TextEditingController();
  AuthService _authService = AuthService();

  Widget chatMessageTile(
    String mesaj,
    bool sendbyme,
  ) {
    return Row(
      mainAxisAlignment:
          sendbyme ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.blue),
              child: Text(
                mesaj,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String docrefid = widget.ref.id;
    final docref = widget.ref;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            //BackButton(),
            CircleAvatar(
              child: FutureBuilder(
                future: clubs.doc(docrefid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data.data();
                    return Image.network(
                      "${data['clubAvatar']}",
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    );
                  }
                  return Text("loading");
                },
              ),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            )
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Container(
                //padding: const EdgeInsets.symmetric(),
                child: StreamBuilder(
                  stream: clubs
                      .doc(docrefid)
                      .collection('chat')
                      .orderBy("time", descending: true)
                      .snapshots(),
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
                      padding: EdgeInsets.only(bottom: 20, top: 10),
                      reverse: true,
                      itemCount: querySnapshot.size,
                      itemBuilder: (context, index) {
                        final map = querySnapshot.docs[index].data();

                        return chatMessageTile(
                          (map as Map)['messages'],
                          _authService.getUserid() == (map as Map)['sender'],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _message,
                      decoration: InputDecoration(
                        labelText: "Mesaj",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width / 5,
                    height: 60,
                    onPressed: () {
                      if (_message.text == "") {
                      } else {
                        _chatService.sendMessage(docref, _message.text);
                      }
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.black54)),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
