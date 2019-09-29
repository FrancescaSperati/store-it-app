import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_it_app/home/home.dart';
import 'dart:io';
import 'package:store_it_app/util/UserDTO.dart';

final String ADD_NEW_RECEIPT_URI = "https://localhost:3002/api/receipt/add";

class AddNewReceipt extends StatefulWidget {
  final UserDTO activeUser;
  AddNewReceipt({Key key, @required this.activeUser}) : super(key: key);

  @override
  _AddNewReceiptWidgetState createState() => _AddNewReceiptWidgetState();
}

class _AddNewReceiptWidgetState extends State<AddNewReceipt> {
  
  final _addNew_key = GlobalKey<FormState>();
  File _image;
  String userId = "";
  String dateNow = new DateTime.now().toString();
  String receiptId;
  String receiptAmount = "";
  String receiptName = "";
  String receiptBusiness = "";
  String receiptDate = "";
  String receiptPicture = "hgds";

  @override
  void initState() {
    userId =  widget.activeUser.userId;
    super.initState();
  }

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
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery);
      setState(() {
        _image = image;
    });
  }

  Future<bool> addExpense(String receiptId,String  userId,String  date,String  business,String  name,String  amount) async {

    receiptId = dateNow.replaceAll("-", "").replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "");

    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };
    Map body = {"receiptId": receiptId, "userId": userId, "date": date, 
                "business": business, "name": name, "amount": amount, "picture": receiptPicture};
    // make POST request
    var response =
        await http.post(ADD_NEW_RECEIPT_URI, headers: headers, body: jsonEncode(body));
    print("response: ");
    print(response.statusCode);
    print("receiptId"+ receiptId+"userId"+ userId+ "date"+ date+ "business"+ business+ 
                "name"+ name+ "amount"+ amount);
    if (response.statusCode == 200) {
      print("new receipt successfully added");
      return true;
    } else {
      return false;
    }
  }

  void addNewReceipt() {
    print(receiptId);
    addExpense(receiptId, userId, receiptDate, receiptBusiness, receiptName, receiptAmount).then((isValid) {
      print(isValid);
      if (isValid) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(activeUser: widget.activeUser)
            ));
      } else {
        showAlert(context, "Invalid Receipt details, please try again.");
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
          title: Text('Add a new Receipt'),
          
        ),
        body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(24),
        child: Form(
          key: _addNew_key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              _image == null
                ? Text('No image selected.')
                : Image.file(_image),
              SizedBox(height: 10),

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
                        _optionsDialogBox();
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
                      height: 50,
                      child: Icon(Icons.photo),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              
              TextFormField(
                onChanged: (text) {
                  setState(() {
                    receiptName = text;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a name for the expense';
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
              SizedBox(height: 10),

              TextFormField(
                onChanged: (text) {
                  setState(() {
                    receiptDate = text;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the date of the expense';
                  }
                  return null;
                },
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    labelText: "Date",
                    hintText: "Date",
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

              TextFormField(
                onChanged: (text) {
                  setState(() {
                    receiptBusiness = text;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the business name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Business",
                    hintText: "Business",
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

              TextFormField(
                onChanged: (text) {
                  setState(() {
                    receiptAmount = text;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the amount of the expense';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Amount",
                    hintText: "Amount",
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
                  onPressed: () { 
                    if (_addNew_key.currentState.validate()) {
                      print("checking all fields BEFORE ADDING A NEW ROW");
                      addNewReceipt();
                    }
                  },
                  textColor: Colors.white,
                  color: Colors.green,
                  height: 50,
                  child: Text("Add"),
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
