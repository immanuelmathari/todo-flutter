import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget{
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>{
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool _isLogin = true;

  startauthentication() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // to close the keyboard

    if(isValid){
      _formKey.currentState!.save(); // saves inside submit form
      submitform(_email,_password,_username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance; // we check for the user credentials and store them
    UserCredential authResult;

    try{
      if(_isLogin){ // if login is true
        authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username' : username,
          'email' : email
        });
      }
    } catch(error) {
      print(error);
    }
  }
  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty || !value.contains('@')){
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                    onSaved: (value){
                    _email = value!;
                    },
                  keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    labelStyle: GoogleFonts.roboto(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  )
                ),
                // condition to make the code below only work when you are not logged in
                if(!_isLogin)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    onSaved: (value){
                      _username = value!;
                    },
                    key: const ValueKey('username'),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      labelStyle: GoogleFonts.roboto(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                    )
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  obscureText: true,
                  validator: (value){
                    if(value!.isEmpty || value.length < 7){
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _password = value!;
                  },
                  key: const ValueKey('password'),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    labelStyle: GoogleFonts.roboto(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      startauthentication();
                    },
                    child: Text(
                      _isLogin ? 'Login' : 'Sign up',
                      style: GoogleFonts.roboto(
                        color: Colors.blue, // there is an issue with my code
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin ? 'Create new account' : 'I already have an account',
                      style: GoogleFonts.roboto(
                        color: Colors.blue,
                        fontSize: 18.0,
                      )
                    )
                  )
                )
              ],
    ))
          ),
        ]
      ),
    );
  }
}
