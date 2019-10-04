import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:store_it_app/util/ReceiptDTO.dart';
import 'package:store_it_app/util/UserDTO.dart';

final String DELETE_RECEIPT_URI = "https://localhost:3002/api/receipt/delete";

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

    Map body = { "userId": this.user.userId, "receiptId": this.receipt.receiptId};
    // make POST request
    var response =
        await http.post(DELETE_RECEIPT_URI, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      print("new receipt successfully deleted");
      return true;
    } else {
      return false;
    }
  }
  deleteReceipt(){
    deleteExpense();
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
          title: Text('Receipt Details'),
          
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                Hero(
                  tag: "photo",
                  child: Container(
                    child: Image.asset('assets/logo.jpg'),
                    width: 250,
                  ),
                ),
                
                SizedBox(height: 50),
                
                Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Name', style: TextStyle(fontSize: 16),),
                              Text(receipt.name),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Date', style: TextStyle(fontSize: 16),),
                              Text(receipt.date),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Business', style: TextStyle(fontSize: 16),),
                              Text(receipt.business),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Amount', style: TextStyle(fontSize: 16),),
                              Text(receipt.amount),
                            ],
                          ),
                        ]
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
                        borderRadius: BorderRadius.circular(10)
                      ),
                      onPressed: () {
                        print('DELETED');
                        deleteReceipt();
                        Navigator.pop(context);
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
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
