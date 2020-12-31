import 'package:chat_flutter/models/auth_data.dart';
import 'package:chat_flutter/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  Future<void> _handleSubmit(AuthData authData) async {
    AuthResult _authResult;

    setState(() {
      _isLoading = true;
    });

    try {
      if (authData.isLogin) {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: authData.email.trim(),
          password: authData.password,
        );
      } else {
        _authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: authData.email.trim(),
          password: authData.password,
        );

        final userData = {
          'name': authData.name,
          'email': authData.email,
        };

        await Firestore.instance
            .collection('users')
            .document(_authResult.user.uid)
            .setData(userData);
      }
    } on PlatformException catch (error) {
      final msg = error.message ?? 'Ocorreu um erro! Verifique as credenciais.';
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      //body: AuthForm(_handleSubmit),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AuthForm(_handleSubmit),
                if (_isLoading)
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
