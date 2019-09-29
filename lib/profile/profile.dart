import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:store_it_app/home/home.dart';
import '../login/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../util/UserDTO.dart';

final String LOGOUT_USER_URI = "https://0.0.0.0:3002/api/validateUser/signout";
final String UPDATE_USER_URI = "https://0.0.0.0:3002/api/validateUser/update";
    

class ProfilePage extends StatefulWidget {
  final UserDTO activeUser;
  ProfilePage({Key key, @required this.activeUser}) : super(key: key);
  
  @override
  _ProfilePageWidgetSate createState() => _ProfilePageWidgetSate();
}

class _ProfilePageWidgetSate extends State<ProfilePage> {

  File _image;

  final _form_key = GlobalKey<FormState>();
  String userName = "";
  String userEmail = "";
  String userPicture = "";
  String userId = "";
  TextEditingController nameEditingContrller;

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text('Take a picture'),
                  onTap: getImage,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: new Text('Select from gallery'),
                  onTap: getImageFromGallery,
                ),
              ],
            ),
          ),
        );
      }
    );
  }


  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera);
      setState(() {
        _image = image;
        userPicture = "jdhsgcfkjsebfhjkcb";
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery);
      setState(() {
        _image = image;
        userPicture = "kjsdbfjklsdbn";
    });
  }


  
  Future<bool> logoutUser() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);
    var response = await http.get(LOGOUT_USER_URI);
    if (response.statusCode == 200) {
      print("Successfully logged out! -> isLogged : false");
      return false;
    }else{
      return true;
    }
  }

  Future<bool> updateUser(userName, picture) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);

    Map<String, String> headers = {
        "Accept": "application/json",
        "Content-type": "application/json"
      };
      Map body = {"userName": userName, "userPicture": picture};
      // make POST request
      var response = await http.post(UPDATE_USER_URI, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        print("User successfully updated!");
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

  @override
  void initState() {
    print("USER: ${widget.activeUser.userName}");
    nameEditingContrller = new TextEditingController(text: widget.activeUser.userName);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    UserDTO updatedUser = widget.activeUser;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              tooltip: 'Back', 
              onPressed: () {
                Navigator.pop(context);
              },
          ),
          title: Text('Profile'),
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                ButtonTheme(
                  minWidth: double.infinity,
                  child: MaterialButton(
                    elevation: 4,
                    highlightElevation: 2,
                    minWidth: 35,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onPressed: () async{
                      var isLogged = true;                    
                      isLogged = await logoutUser();
                      print("trying to logout $isLogged");
                      if(!isLogged){
                        
                        Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          return UserLogin();
                        }));
                      }
                    },
                    textColor: Colors.white,
                    color: Colors.red,
                    height: 35,
                    child: new Text(
                      "LOGOUT",
                      style: new TextStyle(
                        fontSize: 10.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ],
                ),

                Form(
                key: _form_key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                    SizedBox(height: 10),

                    ButtonTheme(
                      minWidth: 100,
                      child: MaterialButton(
                        elevation: 4,
                        highlightElevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: () {
                          _optionsDialogBox();
                        },
                        textColor: Colors.white,
                        color: Colors.blue,
                        height: 50,
                        child: Icon(Icons.photo),
                      ),
                    ),
                    SizedBox(height: 30),
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
                      controller: nameEditingContrller,
                      decoration: InputDecoration(
                        contentPadding:  EdgeInsets.all(15.0),
                        labelText: updatedUser.userName,
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
                    SizedBox(height: 10),
                    ButtonTheme(
                  minWidth: double.infinity,
                  child: MaterialButton(
                    elevation: 4,
                    highlightElevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                        onPressed: () async{
                          var isUpdated = false;                    
                          isUpdated = await updateUser(userName, userPicture);
                          print("checking on all fields");

                          if(isUpdated){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  activeUser: UserDTO(userId, userName, userEmail, updatedUser.password, updatedUser.sessionKey),
                                )),
                            );
                          }
                        },
                        textColor: Colors.white,
                        color: Colors.blue,
                        height: 50,
                        child: Text("Update"),
                  ),
                ),
                
                  ],
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
