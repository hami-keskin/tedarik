import 'package:flutter/material.dart';

import '../../models/loginuser.dart';
import '../../services/Auth.dart';


class Register extends StatefulWidget{

  final Function? toggleView;
  Register({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register>{
  final AuthService _auth = AuthService();

  bool _obscureText = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    final logo = Container( // buraya logo gelecek
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Image(image: AssetImage("lib/images/temp.PNG")),
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
              return 'Lütfen Geçerli Bir E-Posta Adresi Girin';
            }
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "E-Posta",
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)))),
    );

    final passwordField = Container(
      width: 300,
      child: TextFormField(
          obscureText: _obscureText,
          controller: _password,
          autofocus: false,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Bu alanın doldurulması zorunludur.';
            }
            if (value.trim().length < 8) {
              return 'Parolanız en az 8 karakter olmalı';
            }
            // Return null if the entered password is valid
            return null;
          } ,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Parola",
              suffixIcon: IconButton(icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: (){
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)))),
    );

    final txtbutton = TextButton(
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('Giriş Ekranına Dön'));

    final registerButton = Center(
      child: Container(
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
                dynamic result = await _auth.registerEmailPassword(LoginUser(email: _email.text,password: _password.text));
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
              "Kayıt Ol",
              style: TextStyle(color: Theme.of(context).primaryColorDark),
              textAlign: TextAlign.center,
            ),
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
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    logo,
                    const SizedBox(height: 45.0),
                    emailField,
                    const SizedBox(height: 25.0),
                    passwordField,
                    const SizedBox(height: 25.0),
                    txtbutton,
                    const SizedBox( height: 35.0),
                    registerButton,
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