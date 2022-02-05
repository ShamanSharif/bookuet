import 'package:bookuet/model/constants.dart';
import 'package:bookuet/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        foregroundColor: CustomColor.textColor,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 70.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Provider.of<User>(context).isLoggedIn
                  ? "You are currently logged in as ${Provider.of<User>(context).userName}"
                  : "You are not logged in",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColor.textColor,
              ),
            ),
            MaterialButton(
              onPressed: () {
                if (Provider.of<User>(context, listen: false).isLoggedIn) {
                  Provider.of<User>(context, listen: false).logOutUser();
                } else {
                  Provider.of<User>(context, listen: false).logInUser();
                }
              },
              child: Text(
                Provider.of<User>(context).isLoggedIn
                    ? "Log Out"
                    : "Sign In Using Google",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColor.light,
                ),
              ),
              color: CustomColor.textColor,
            ),
          ],
        ),
      ),
    );
  }
}
