import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../signup/signup_screen.dart';
import '../home/home.dart';
import 'dart:async';
import 'dart:convert';
import '../util/UserDTO.dart';

final String VALIDATE_USER_URI =
    "https://10.1.6.133:3002/api/validateUser/validate";

class UserLogin extends StatefulWidget {
  UserLogin({Key key}) : super(key: key);
  @override
  _UserLoginWidgetState createState() => _UserLoginWidgetState();
}

class _UserLoginWidgetState extends State<UserLogin> {
  final _login_key = GlobalKey<FormState>();
  String password = "";
  String userEmail = "";
  String sessionKey = "";
  String userName = "";
  String userId = "";


  Future<bool> validateUser(userEmail, password) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };
    Map body = {"userEmail": userEmail, "password": password};
    // make POST request
    var response = await http.post(VALIDATE_USER_URI,
        headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      var responseJSON;
      if (response.body == "0") {
        responseJSON = "";
      } else {
        responseJSON = json.decode(response.body);
        userName = responseJSON["user"]["displayName"];
        userId = responseJSON["user"]["uid"].toString();
      } //jsonList = json.decode(response.body);

      if (responseJSON != "") {
        //user validated
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void validate() {
    validateUser(userEmail, password).then((isValid) {
      print(isValid);
      if (isValid) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    activeUser: new UserDTO(
                        userId, userName, userEmail, password, sessionKey),
                  )),
        );
      } else {
        showAlert(context, "Invalid User details, please try again.");
      }
    });
  }

  void showAlert(BuildContext context, message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Error!"),
              content: Text("$message"),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.3, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.

              Colors.lightGreen[700],
              Colors.lime[600],
              Colors.lime[400],
              Colors.yellow[300],
              Colors.yellow[400],
            ],
          ),
        ),
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
                  child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "sia",
                  style: TextStyle(
                    fontSize: 100.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Rock_Salt",
                  ),
                ),Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Rock_Salt",
                        ),
                      ),
                      SizedBox(height: 30),
                Form(
                  key: _login_key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        style: new TextStyle(color: Colors.white),
                        onChanged: (text) {
                          setState(() {
                            userEmail = text;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your Password';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Email",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            errorStyle: TextStyle(
                              color: Colors.redAccent[100],
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        style: new TextStyle(color: Colors.white),
                        onChanged: (text) {
                          setState(() {
                            password = text;
                          });
                        },
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Password",
                            errorStyle: TextStyle(
                              color: Colors.redAccent[100],
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            )),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ButtonTheme(
                        minWidth: double.infinity,
                        child: MaterialButton(
                          elevation: 4,
                          highlightElevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            print("Login");
                            if (_login_key.currentState.validate()) {
                              validate();
                            }
                          },
                          textColor: Colors.white,
                          color: Colors.green[300],
                          height: 50,
                          child: Text("LOGIN"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ButtonTheme(
                      minWidth: 100,
                      child: MaterialButton(
                        elevation: 4,
                        highlightElevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));

                          // Navigator.of(context).push(MaterialPageRoute<Null>(
                          //     builder: (BuildContext context) {
                          //   return new HomePage(
                          //       activeUser: new UserDTO(
                          //           "NJDAuXoh9ygNLXZGizyClU4922d2",
                          //           "fra",
                          //           "fra@test.com",
                          //           "password",
                          //           sessionKey));
                          // }));
                        },
                        textColor: Colors.white,
                        color: Colors.blue[300],
                        height: 50,
                        child: Text("or Signup"),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
