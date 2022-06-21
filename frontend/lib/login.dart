import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nlpproje/ChatPage.dart';
import 'package:nlpproje/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Configuration.dart';
import 'HomeScreen.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool beniHatirla = false;
  bool isObscure = true;
  bool isLoading = false;

  //key
  final _formkey = GlobalKey<FormState>();

  //editingcontroller
  final TextEditingController _emailcontroller = new TextEditingController();
  final TextEditingController _passwordcontroller = new TextEditingController();
  late SharedPreferences logindata;

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  Widget buildEposta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'E-Posta',
          style: TextStyle(
            color: primaryColorr,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: primaryColorr,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Boş Mail girdiniz";
              }
              if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                  .hasMatch(value)) {
                return "Hatalı Mail girdiniz";
              }
              return null;
            },
            onSaved: (value) {
              _emailcontroller.text = value!;
            },
            autofocus: false,
            textInputAction: TextInputAction.next,
            controller: _emailcontroller,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Theme.of(context).disabledColor,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 15),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: "E-Posta",
                hintStyle:
                    TextStyle(color: Theme.of(context).secondaryHeaderColor)),
          ),
        )
      ],
    );
  }

  Widget buildSifre() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Şifre',
          style: TextStyle(
            color: primaryColorr,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: primaryColorr,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            validator: (value) {
              RegExp regexp = new RegExp(r'^.{6,}$');
              if (value!.isEmpty) {
                return "Şifre Boş girilemez";
              }
              if (!regexp.hasMatch(value)) {
                return "Hatalı şifre girdiniz";
              }
              return null;
            },
            onSaved: (value) {
              _passwordcontroller.text = value!;
            },
            autofocus: false,
            controller: _passwordcontroller,
            obscureText: isObscure,
            textInputAction: TextInputAction.done,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
                hintText: "Şifre",
                hintStyle:
                    TextStyle(color: Theme.of(context).secondaryHeaderColor)),
          ),
        )
      ],
    );
  }

  Widget buildSifrenimiunuttun() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {},
        padding: EdgeInsets.only(right: 0),
        child: Text(
          'Şifremi Unuttum',
          style: TextStyle(
            color: primaryColorr,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildBenihatirla() {
    return Container(
      height: 30,
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              unselectedWidgetColor: primaryColorr,
            ),
            child: Checkbox(
              value: beniHatirla,
              checkColor: Colors.white,
              activeColor: primaryColorr,
              onChanged: (value) {
                setState(() {
                  beniHatirla = value!;
                });
              },
            ),
          ),
          Text(
            'Beni Hatırla',
            style: TextStyle(
              color: primaryColorr,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildLoginbuton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          login(_emailcontroller.text, _passwordcontroller.text);
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: primaryColorr,
        child: Text('Giriş',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget buildSignupbuton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUp()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Hesabınız yok mu ? ",
              style: TextStyle(
                  color: primaryColorr,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            TextSpan(
                text: "KAYIT OL",
                style: TextStyle(
                  color: primaryColorr,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.07,
                  vertical: size.height * 0.14,
                ),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.6,
                        child: FittedBox(
                          child: Text(
                            'Giriş Yap',
                            style: TextStyle(
                                color: primaryColorr,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.10),
                      buildEposta(),
                      SizedBox(height: size.height * 0.02),
                      buildSifre(),
                      buildSifrenimiunuttun(),
                      buildBenihatirla(),
                      SizedBox(height: size.height * 0.02),
                      buildLoginbuton(),
                      buildSignupbuton(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void login(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Giriş Başarılı"),
                saveSharedPreferences(),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                ),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: "Giriş Başarısız");
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  Future saveSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (beniHatirla) {
      await prefs.setBool('BeniHatirla', true);
    } else {
      await prefs.setBool('BeniHatirla', false);
    }
  }
}
