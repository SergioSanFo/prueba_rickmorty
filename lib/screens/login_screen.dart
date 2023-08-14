import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prueba_rickmorty/screens/home_screen.dart';
import 'package:prueba_rickmorty/screens/singup_screen.dart';
import 'package:prueba_rickmorty/utils/colors_utils.dart';
import '../reusable_widgets/reusable_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              hexStringToColor("161026"),
              hexStringToColor("181229"),
              hexStringToColor("322b43")
            ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                transform: const GradientRotation(8))),
        child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget('assets/images/logo.png'),
                  reusableTextField("Ingrese Correo", Icons.mail_outline, false,
                      _emailTextController),
                  const SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Ingrese Contraseña", Icons.lock_outline,
                      true, _passwordTextController),
                  const SizedBox(
                    height: 10,
                  ),
                  signInsignUpButton(context, true, () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }).onError((error, stackTrace) {
                      // print("Error ${error.toString()}");
                    });
                  }),
                  SignUpOption()
                ],
              ),
            )),
      ),
    );
  }

  Row SignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("No tienes cuenta?  ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SingUpScreen()));
          },
          child: const Text(
            "Registrate",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
