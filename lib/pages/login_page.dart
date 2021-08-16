import 'package:flutter/material.dart';
import 'package:movielist/pages/home_page.dart';
import 'package:movielist/utils/constants.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login Page")),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/bg.jpg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.7),
              colorBlendMode: BlendMode.darken,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Form(
                  key: formKey,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (s) {},
                              decoration: InputDecoration(
                                  hintText: "Enter Username",
                                  labelText: "Username"),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (s) {},
                              decoration: InputDecoration(
                                  hintText: "Enter Password",
                                  labelText: "Password"),
                            ),
                            // ignore: deprecated_member_use
                            RaisedButton(
                              onPressed: () {
                                Constants.prefs.setBool("loggedIn", true);
                                // formKey.currentState.validate();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => HomePage()));
                                Navigator.pushReplacementNamed(
                                    context, HomePage.routeName);
                              },
                              child: Text("Sign In"),
                              color: Colors.orange,
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
              ),
            )
          ],
        ));
  }
}
