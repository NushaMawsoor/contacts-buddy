import 'package:flutter/material.dart';
import 'home_page.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isButtonEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
             onChanged: (value) {
                updateButtonState();
              },
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
             onChanged: (value) {
                updateButtonState();
              },
              obscureText: true, // Hide the password
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 32.0),
           ElevatedButton(
              onPressed: isButtonEnabled ? () => handleLogin() : null,                

              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
}

  void updateButtonState() {
    setState(() {
      isButtonEnabled =
          usernameController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  void handleLogin() {
    // Implement your login logic here
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == 'user' && password == 'pass') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );

    } else {
      // Invalid credentials
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Semantics(
      label: "invalid details",
      child: Text("invalid details"),
    ),
  ),
);

    }
  }
}
