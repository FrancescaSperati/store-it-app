import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import '../home/home.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenWidgetSate createState() => _SignupScreenWidgetSate();
}

class _SignupScreenWidgetSate extends State<SignupScreen> {
  TextEditingController emailEditingContrller = TextEditingController();
  TextEditingController pwdEditingContrller = TextEditingController();
  TextEditingController nameEditingContrller = TextEditingController();
  TextEditingController confPwdEditingContrller = TextEditingController();

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
                  width: 150,
                ),
              ),
              SizedBox(height: 50),
              TextField(
                keyboardType: TextInputType.text,
                controller: emailEditingContrller,
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
              TextField(
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
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.green,
                            style: BorderStyle.solid))),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                controller: pwdEditingContrller,
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
              TextField(
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                controller: pwdEditingContrller,
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
                  //onPressed: () => {print("SUCA")},
                  onPressed: () {
                    print("signup");
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new HomePage();
                    }));
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
