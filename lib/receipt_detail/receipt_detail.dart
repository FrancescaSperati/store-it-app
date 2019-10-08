import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:store_it_app/util/ReceiptDTO.dart';
import 'package:store_it_app/util/UserDTO.dart';

final String DELETE_RECEIPT_URI = "https://10.1.6.133:3002/api/receipt/delete";

class ReceiptDetailPage extends StatelessWidget {
  final ReceiptDTO receipt;
  final UserDTO user;

  ReceiptDetailPage(this.receipt, this.user);

  Future<bool> deleteExpense() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };

    Map body = {
      "userId": this.user.userId,
      "receiptId": this.receipt.receiptId
    };
    // make POST request
    var response = await http.post(DELETE_RECEIPT_URI,
        headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      print("new receipt successfully deleted");
      return true;
    } else {
      return false;
    }
  }

  deleteReceipt() {
    deleteExpense();
  }

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;

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
          title: Text('Receipt Details'),
        ),
        body: Container(
          width: deviceWidth,
          color: Colors.white,
          padding: EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  color: Colors.yellow[100],
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child:
                        Text("RECEIPT",
                        style: TextStyle(fontSize: 34),
                        textAlign: TextAlign.center,
                        ),),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            '-----------------------------------------------------',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                            softWrap: false,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Name',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(receipt.name,
                        style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Date',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(receipt.date,
                        style: TextStyle(fontSize: 30),),
                        SizedBox(height: 20),
                        Text(
                          'Business',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(receipt.business,
                        style: TextStyle(fontSize: 30),),
                        SizedBox(height: 20),
                        Text(
                          'Amount',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(receipt.amount,
                        style: TextStyle(fontSize: 30),),
                        SizedBox(height: 50),
                        Center(
                          child: Text(
                            '-----------------------------------------------------',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                ButtonTheme(
                  minWidth: 100,
                  child: MaterialButton(
                    elevation: 4,
                    highlightElevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      print('DELETED');
                      deleteReceipt();
                      Navigator.pop(context);
                    },
                    textColor: Colors.white,
                    color: Colors.red[400],
                    height: 50,
                    child: Text("Delete"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
