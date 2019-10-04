import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../receipt_detail/receipt_detail.dart';
import 'UserDTO.dart';
import 'ReceiptDTO.dart';

final String GET_USER_HISTORY_URI =
    "https://localhost:3002/api/receipt/readHistory";

class BodyLayout extends StatefulWidget {
  final UserDTO activeUser;
  final String name;
  final String date;
  final String business;
  final String amount;

  BodyLayout(this.activeUser, this.name, this.date, this.business, this.amount);

  @override
  _BodyLayoutState createState() => _BodyLayoutState();
}

class _BodyLayoutState extends State<BodyLayout> {
  int row_count = 0;
  List<ReceiptDTO> receipts = List();

  @override
  void initState() {
    row_count = receipts.length;
    super.initState();
  }

  Future<bool> getUserHistory(userId) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };
    Map body = {"userId": userId};
    // make POST request
    var response = await http.post(GET_USER_HISTORY_URI,
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      receipts = List();
      for (var item in jsonList) {
        receipts.add(ReceiptDTO(
            item["id"].toString(),
            item["amount"].toString(),
            item["business"].toString(),
            item["date"].toString(),
            item["name"].toString(),
            item["picture"].toString()));
      }
      row_count = receipts.length;
      return true;
    } else {
      return false;
    }
  }

  void setTotal() {
    getUserHistory(widget.activeUser.userId).then((isValid) {
    });
  }

  @override
  Widget build(BuildContext context) {
    setTotal();
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: row_count,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReceiptDetailPage(receipts[index], widget.activeUser)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      // align the text to the left instead of centered
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Name',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(receipts[index].name.toString()),
                      ],
                    ),
                    Column(
                      // align the text to the left instead of centered
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Date',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(receipts[index].date.toString()),
                      ],
                    ),
                    Column(
                      // align the text to the left instead of centered
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Business',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(receipts[index].business.toString()),
                      ],
                    ),
                    Column(
                      // align the text to the left instead of centered
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Amount',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(receipts[index].amount.toString()),
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}
