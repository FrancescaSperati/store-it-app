import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:path/path.dart';
import 'package:store_it_app/util/UserDTO.dart';
import '../login/login_screen.dart';
import '../home/home.dart';

final String SIGNUP_USER_URI = "https://0.0.0.0:3002/api/validateUser/addUser";


class SignupScreen extends StatefulWidget {
  SignupScreen({Key key}) : super(key: key);
  @override
  _SignupScreenWidgetSate createState() => _SignupScreenWidgetSate();
}

class _SignupScreenWidgetSate extends State<SignupScreen> {
  final _signup_key = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();

  String userPassword = "";
  String userEmail = "";
  String sessionKey = "";
  String userName = "";
  String userId = "";

  Future<bool> signupNewUser(userEmail, userPassword) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };
    Map body = {"userEmail": userEmail, "password": userPassword};
    // make POST request
    var response = await http.post(SIGNUP_USER_URI, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      var responseJSON = response == "" ? "" : jsonDecode(response.body);

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

    void signup() {
    signupNewUser(userEmail, userPassword).then((isValid) {
      print(isValid);
      if (isValid) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              activeUser: UserDTO(userId, userName, userEmail, userPassword, sessionKey),
            )),
        );
      } else {
        showAlert(context, "Invalid User details, please try again.");
      }
    });
  }



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
                  width: 150,
                ),
              ),
              SizedBox(height: 50),
              Form(
                key: _signup_key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      onChanged: (text) {
                        setState(() {
                          userName = text;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your Name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          hintText: "Name",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.green,
                                  style: BorderStyle.solid))),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      onChanged: (text) {
                        setState(() {
                          userEmail = text;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your Email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Email",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.green,
                                  style: BorderStyle.solid))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      key: passKey,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.green,
                                  style: BorderStyle.solid))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (confirmation){
                        var confPassword = passKey.currentState.value;
                        return equals(confirmation, confPassword) ? null : "Confirm Password should match password";
                      },
                      onChanged: (text) {
                        setState(() {
                          userPassword = text;
                        });
                      },
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: "Confirm Password",
                          hintText: "Confirm Password",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
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
                          print("creating a new user");
                          if (_signup_key.currentState.validate()) {
                            signup();
                          }
                        },
                        textColor: Colors.white,
                        color: Colors.green,
                        height: 50,
                        child: Text("SIGNUP"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
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
                        //Use`Navigator` widget to push the second screen to out stack of screens

                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new UserLogin();
                        }));
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
                      height: 50,
                      child: Text("or Login"),
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
