import 'package:flutter/material.dart';

import '../../models/loginuser.dart';
import '../../services/Auth.dart';

class Login extends StatefulWidget {
  final Function? toggleView;
  Login({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {

  bool _obscureText = true;

  final _email = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final logo = Container( // buraya logo gelecek
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Image(image: AssetImage("lib/images/logo.PNG")),
    );

    final emailField = Container(
      width: 300,
      child: TextFormField(
          controller: _email,
          autofocus: false,
          validator: (value) {
            if (value != null) {
              if (value.contains('@') && value.endsWith('.com')) {
                return null;
              }
              return 'Enter a Valid Email Address';
            }
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'E-posta',
              border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
      ),
          )),
    );

    final passwordField = Container(
      width: 300,
      child: TextFormField(
          
          obscureText: _obscureText,
          controller: _password,
          autofocus: false,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            if (value.trim().length < 8) {
              return 'Password must be at least 8 characters in length';
            }
            // Return null if the entered password is valid
            return null;
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              suffixIcon: IconButton(
                icon:
                Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
              ))),
    );

    final txtbutton = TextButton(
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('Üye değil misin?'));

    final loginAnonymousButon = Container(
      child: Material(

        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: const Color(0xff72c8ff),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            dynamic result = await _auth.signInAnonymous();

            if (result.uid == null) { //null means unsuccessfull authentication
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(result.code),
                    );
                  });
            }
          },
          child: Text(
            "Anonim Olarak Giriş Yap",
            style: TextStyle(color: Theme.of(context).primaryColorDark),
            textAlign: TextAlign.center,
          ),
        ),
      ),

    );

    final loginEmailPasswordButon = Container(
      width: 300,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: const Color(0xff72c8ff),

        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              dynamic result = await _auth.signInEmailPassword(LoginUser(email: _email.text,password: _password.text));
              if (result.uid == null) { //null means unsuccessfull authentication
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(result.code),
                      );
                    });
              }
            }
          },
          child: Text(
            "Giriş Yap",
            style: TextStyle(color: Theme.of(context).primaryColorDark),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffb0e7fe),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
        
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    logo,
                    loginAnonymousButon,
                    const SizedBox(height: 45.0),
                    emailField,
                    const SizedBox(height: 25.0),
                    passwordField,
                    txtbutton,
                    const SizedBox(height: 35.0),
                    loginEmailPasswordButon,
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}