import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../receipt_detail/receipt_detail.dart';
import 'UserDTO.dart';


final String GET_USER_HISTORY_URI = "https://localhost:3002/api/receipt/readHistory";

class BodyLayout extends StatelessWidget {
  final UserDTO activeUser;
  BodyLayout( @required this.activeUser, String name, String date, String business, String amount);
/*

  Future<bool> getUserHistory(userId) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };
    Map body = {"userId": userId};
    // make POST request
    var response = await http.post(GET_USER_HISTORY_URI, headers: headers, body: jsonEncode(body));
    print('response: ' + response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  setTotal() async{
    await getUserHistory(activeUser.userId);
    setState(() {
      _totaleACASO = tot;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {

  // the Expanded widget lets the columns share the space
  Widget column2 = Expanded(
    child: Column(
      // align the text to the left instead of centered
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Date', style: TextStyle(fontSize: 16),),
        Text('subtitle'),
      ],
    ),
  );
  Widget column1 = Expanded(
    child: Column(
      // align the text to the left instead of centered
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Name', style: TextStyle(fontSize: 16),),
        Text('subtitle'),
      ],
    ),
  );
  Widget column3 = Expanded(
    child: Column(
      // align the text to the left instead of centered
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Business', style: TextStyle(fontSize: 16),),
        Text('subtitle'),
      ],
    ),
  );
  Widget column4 = Expanded(
    child: Column(
      // align the text to the left instead of centered
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Amount', style: TextStyle(fontSize: 16),),
        Text('subtitle'),
      ],
    ),
  );
  

  return ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: 10,
    itemBuilder: (context, index) {
      return Card(
        child: InkWell(
          onTap: () {
            print('tapped $index');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReceiptDetailPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: <Widget>[
                column1,
                column2,
                column3,
                column4,
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        ),
      );
    },
  );
}