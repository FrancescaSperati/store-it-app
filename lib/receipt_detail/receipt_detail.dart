import 'package:flutter/material.dart';

class ReceiptDetailPage extends StatelessWidget {
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
                              Text('subtitle'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Date', style: TextStyle(fontSize: 16),),
                              Text('subtitle'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Business', style: TextStyle(fontSize: 16),),
                              Text('subtitle'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Amount', style: TextStyle(fontSize: 16),),
                              Text('subtitle'),
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
