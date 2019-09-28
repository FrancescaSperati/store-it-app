import 'package:flutter/material.dart';
import '../receipt_detail/receipt_detail.dart';

class BodyLayout extends StatelessWidget {
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