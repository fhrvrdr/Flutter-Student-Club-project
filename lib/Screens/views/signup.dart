import 'package:flutter/material.dart';
import 'package:flutter_club_project/Screens/views/login.dart';
import 'package:flutter_club_project/services/authService.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  AuthService _authService = AuthService();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

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
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/register.png"))),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      validator: (String name) {
                        if (name.isEmpty) {
                          return "Lütfen İsminizi Yazınız.";
                        }
                      },
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
                    TextFormField(
                      controller: _emailController,
                      validator: (String mail) {
                        if (mail.isEmpty) {
                          return "Lütfen Okul Numaranızı Yazınız.";
                        }
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                          ),
                          labelText: "Okul Numarası",
                          border: OutlineInputBorder(),
                          hintText: "Okul numarası"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (String password) {
                        if (password.isEmpty) {
                          return "Lütfen Bir Şifre Yazınız.";
                        }
                      },
                      controller: _passController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        labelText: "Şifre",
                        border: OutlineInputBorder(),
                      ),
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
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          _authService
                              .createPerson(
                                  _nameController.text,
                                  _emailController.text +
                                      "@student.beykent.edu.tr",
                                  _passController.text)
                              .then((value) {
                            if (value != null) {
                              return Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
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
                        "Kayıt Ol",
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Zaten Üye Misin?",
                          style:
                              TextStyle(fontFamily: 'OpenSans', fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Text(
                            " GİRİŞ YAP",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
