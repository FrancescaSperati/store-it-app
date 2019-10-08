import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:store_it_app/home/home.dart';
import 'dart:io';
import 'package:store_it_app/util/UserDTO.dart';
import '../util/UserDTO.dart';
import 'package:intl/intl.dart';

final String ADD_NEW_RECEIPT_URI = "https://10.1.6.133:3002/api/receipt/add";

class AddNewReceipt extends StatefulWidget {
  final UserDTO activeUser;
  AddNewReceipt({Key key, @required this.activeUser}) : super(key: key);

  @override
  _AddNewReceiptWidgetState createState() => _AddNewReceiptWidgetState();
}

class _AddNewReceiptWidgetState extends State<AddNewReceipt> {
  final _addNew_key = GlobalKey<FormState>();
  String userId = "";
  String dateNow = new DateTime.now().toString();
  String receiptId;
  String receiptAmount = "";
  String receiptName = "";
  String receiptBusiness = "";
  String receiptDate = "";
  TextEditingController dateController = TextEditingController();
  FocusNode nameFocusNome = new FocusNode();
  FocusNode dateFocusNome = new FocusNode();
  FocusNode businessFocusNome = new FocusNode();
  FocusNode amountFocusNome = new FocusNode();

  @override
  void initState() {
    userId = widget.activeUser.userId;
    super.initState();
  }

  

  
  Future<bool> addExpense(String receiptId, String userId, String date,
      String business, String name, String amount) async {
    receiptId = dateNow
        .replaceAll("-", "")
        .replaceAll(" ", "")
        .replaceAll(".", "")
        .replaceAll(":", "");

    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };
    Map body = {
      "receiptId": receiptId,
      "userId": userId,
      "date": date,
      "business": business,
      "name": name,
      "amount": amount,
      "picture": "",
    };
    // make POST request
    var response = await http.post(ADD_NEW_RECEIPT_URI,
        headers: headers, body: jsonEncode(body));
    print("response: ");
    print(response.statusCode);
    print("receiptId" +
        receiptId +
        "userId" +
        userId +
        "date" +
        date +
        "business" +
        business +
        "name" +
        name +
        "amount" +
        amount);
    if (response.statusCode == 200) {
      print("new receipt successfully added");
      return true;
    } else {
      return false;
    }
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2022));
    if (picked != null) {
      setState(() {
        receiptDate = DateFormat("dd-MM-yyyy").format(picked).toString();
        dateController.text = receiptDate;
      });
    }
  }

  void addNewReceipt() {
    addExpense(receiptId, userId, receiptDate, receiptBusiness, receiptName,
            receiptAmount)
        .then((isValid) {
      if (isValid) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(activeUser: widget.activeUser)));
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
          backgroundColor: Colors.lightGreen[700],
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
                
                TextFormField(
                  focusNode: nameFocusNome,
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
                          color: nameFocusNome.hasFocus ? Colors.red : Colors.black,
                          fontSize: 16,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent[400], width: 2),
                          ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.redAccent[400],
                            style: BorderStyle.solid))),
                ),
                SizedBox(height: 10),
                TextFormField(
                  focusNode: dateFocusNome,
                  onChanged: (text) {
                    setState(() {
                      receiptDate = text;
                      print(receiptDate);
                    });
                  },
                  onTap: () {
                    _selectDate();
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter the date of the expense';
                    }
                    return null;
                  },
                  controller: dateController,
                  decoration: InputDecoration(
                      labelText: "Date",
                      hintText: "Date",
                      labelStyle: TextStyle(
                        color: dateFocusNome.hasFocus ? Colors.red : Colors.black,
                          fontSize: 16,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent[400], width: 2),
                          ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.redAccent[400],
                            style: BorderStyle.solid)))
                ),
                SizedBox(height: 10),
                TextFormField(
                  focusNode: businessFocusNome,
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
                          color: businessFocusNome.hasFocus ? Colors.red : Colors.black,
                          fontSize: 16,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent[400], width: 2),
                          ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.redAccent[400],
                            style: BorderStyle.solid)))
                ),
                SizedBox(height: 10),
                TextFormField(
                  focusNode: amountFocusNome,
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
                          color: amountFocusNome.hasFocus ? Colors.red : Colors.black,
                          fontSize: 16,
                        ),
                        
                        focusedBorder: OutlineInputBorder(
                          
                            borderSide:
                                BorderSide(color: Colors.redAccent[400], width: 2),
                          ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.redAccent[400],
                            style: BorderStyle.solid)))
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
                    color: Colors.green[300],
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
