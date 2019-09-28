import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../signup/signup_screen.dart';
import '../home/home.dart';
import 'dart:async';
import 'dart:convert';
import '../util/UserDTO.dart';

final String VALIDATE_USER_URI =
    "https://0.0.0.0:3002/api/validateUser/validate";

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
  TextEditingController emailEditingContrller = TextEditingController();
  TextEditingController pwdEditingContrller = TextEditingController();

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
    var response =
        await http.post(VALIDATE_USER_URI, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      var responseJSON = response == "" ? "" : jsonDecode(response.body);
      userName = responseJSON["user"]["displayName"] == null ? "Anonymous" : responseJSON["user"]["displayName"];
      print(userName);
      if(responseJSON != "")
      {
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
              activeUser: new UserDTO(userName, userEmail, password, sessionKey),
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
        color: Colors.white,
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: Container(
                  child: Image.asset('assets/logo.jpg'),
                  width: 250,
                ),
              ),
              SizedBox(height: 50),
              Form(
                key: _login_key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
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
                      controller: emailEditingContrller,
                      decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Email",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.green,
                                  style: BorderStyle.solid))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
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
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.green,
                                  style: BorderStyle.solid))),
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
                        color: Colors.green,
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
                        borderRadius: BorderRadius.circular(10)
                      ),
                      onPressed: () {
                        //Use`Navigator` widget to push the second screen to out stack of screens

                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new SignupScreen();
                        }));
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
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
    );
  }
}
