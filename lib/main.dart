import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  FirebaseAuth fsAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextButton(
                    onPressed: sigIn,
                    child: Text('Ingresar'),
                  ),
                  TextButton(
                    onPressed: createAccount,
                    child: Text('Crear cuenta'),
                  ),
                  TextButton(
                    onPressed: forgetMyPassword,
                    child: Text('Olvide mi contraseña'),
                  ),
                  TextButton(
                    onPressed: logOut,
                    child: Text('Cerrar sesion'),
                  ),
                  TextButton(
                    onPressed: sendMailValidation,
                    child: Text('Enviar mail de validacion'),
                  ),
                  TextButton(
                    onPressed: getActualUser,
                    child: Text('Usuario actual...'),
                  ),
                  TextButton(
                    onPressed: changeNameField,
                    child: Text('Agregar nombre de usuario'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendMailValidation() async {
    if (fsAuth.currentUser != null &&
        fsAuth.currentUser.emailVerified == false) {
      await fsAuth.currentUser.sendEmailVerification().then(
            (value) => {print('Mail enviado')},
          );
    } else {
      print('El usuario ya esta habilitado');
    }
  }

  void getActualUser() {
    if (fsAuth.currentUser == null) {
      print('No a iniciado sesion ningun usuario');
    } else {
      print('A iniciado sesion el usuario: ${fsAuth.currentUser.email}');
    }
  }

  void forgetMyPassword() async {}

  void sigIn() async {
    try {
      fsAuth
          .signInWithEmailAndPassword(
              email: 'dewetbaumann@outlook.com', password: '123456')
          .then(
            (value) => print('Usuario actual: ${fsAuth.currentUser.email}'),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No se encontro un usuario con este email');
      } else if (e.code == 'wrong-password') {
        print('La contraseña ingresada es incorrecta');
      }
    } catch (e) {
      print('Error E: $e');
    }
  }

  void createAccount() async {
    try {
      fsAuth.createUserWithEmailAndPassword(
          email: "dewetbaumann@outlook.com", password: '123456');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña es muy debil.');
      } else if (e.code == 'email-already-in-use') {
        print('La cuenta ya existe para este mail.');
      }
    } catch (e) {
      print(e);
    }
  }

  void logOut() {
    fsAuth.signOut().then((value) => print('Cesion cerrada'));
    print('Usuario actual: ${fsAuth.currentUser}');
  }

  void changeNameField() {
    fsAuth.currentUser.updateDisplayName('De Wet Baumann').then((value) =>
        print('El nuevo nombre es ${fsAuth.currentUser.displayName}'));
    fsAuth.currentUser.updatePassword('987654').then((value) => null);
  }
}
