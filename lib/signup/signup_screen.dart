import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:path/path.dart';
import 'package:store_it_app/util/UserDTO.dart';
import '../home/home.dart';

final String SIGNUP_USER_URI = "https://0.0.0.0:3002/api/validateUser/addUser";


class SignupScreen extends StatefulWidget {
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
      var responseJSON = response.body == "" ? "" : jsonDecode(response.body);

      if(responseJSON != "")
      {

        userId= responseJSON["id"].toString();


//prendi lo user




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
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.2, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.redAccent[400],
              Colors.pinkAccent[400],
              Colors.orange[600],
              Colors.orange[300],
            ],
          ),
        ),
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             
              SizedBox(height: 50),
              Form(
                key: _signup_key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "sia",
                      style: TextStyle(
                        fontSize: 80.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Rock_Salt",
                      ),
                    ),
                    TextFormField(

                      style: new TextStyle(color: Colors.white),
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
                          hintText: "Name",errorStyle: TextStyle(
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
                    SizedBox(height: 30),
                    TextFormField(
                      style: new TextStyle(color: Colors.white),
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
                      height: 30,
                    ),
                    TextFormField(
                      style: new TextStyle(color: Colors.white),
                      key: passKey,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Password",
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
                      height: 30,
                    ),
                    TextFormField(
                      style: new TextStyle(color: Colors.white),
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
                          print("creating a new user");
                          if (_signup_key.currentState.validate()) {
                            signup();
                          }
                        },
                        textColor: Colors.white,
                        color: Colors.green[300],
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

                        Navigator.pop(context);
                      },
                      textColor: Colors.white,
                      color: Colors.blue[300],
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
