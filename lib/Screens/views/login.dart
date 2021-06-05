import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_club_project/Screens/views/HomeScreen.dart';
import 'package:flutter_club_project/Screens/views/signup.dart';
import 'package:flutter_club_project/services/authService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService _authService = AuthService();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _sucsees;
  String _messsage;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/login.png"))),
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          labelText: "Okul Numarası",
                          border: OutlineInputBorder(),
                          hintText: "Okul Numarası"),
                      validator: (String mail) {
                        if (mail.isEmpty) {
                          return "Lütfen İsminizi Yazınız.";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Şifre",
                        border: OutlineInputBorder(),
                      ),
                      validator: (String password) {
                        if (password.isEmpty) {
                          return "Lütfen Bir Şifre Yazınız.";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      _sucsees == null ? '' : _messsage ?? '',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.black26)),
                      onPressed: () {
                        if (_formkey.currentState.validate()) {
                          _authService
                              .signIn(
                                  _emailController.text +
                                      "@student.beykent.edu.tr",
                                  _passController.text)
                              .then((value) {
                            if (value != null) {
                              return Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            } else {
                              setState(() {
                                _messsage = "Bir Hata Oluştu!";
                                _sucsees = false;
                              });
                            }
                          });
                        }
                      },
                      color: Colors.blue,
                      child: Text(
                        "Giriş Yap",
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Henüz üye olmadın mı?",
                          style:
                              TextStyle(fontFamily: 'OpenSans', fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()));
                          },
                          child: Text(
                            " ÜYE OL",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    )
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
