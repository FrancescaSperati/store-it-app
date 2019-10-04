import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_it_app/util/UserDTO.dart';
import '../util/list.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class FiltersPage extends StatefulWidget {
  final BodyLayout lista;
  FiltersPage(this.lista);

  @override
  _FiltersPageWidgetState createState() => _FiltersPageWidgetState();
}

class _FiltersPageWidgetState extends State<FiltersPage> {

TextEditingController nameEditingController = TextEditingController();
TextEditingController businessEditingController = TextEditingController();
TextEditingController amountEditingController = TextEditingController();
String _value = '';


  @override
  void initState() {
    super.initState();
  }


  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2022)
    );
    
    if(picked != null) setState(() => _value = DateFormat("dd-MM-yyyy").format(picked).toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              tooltip: 'Back', 
              onPressed: () {
                Navigator.pop(context);
              },
          ),
          title: Text('Filters'),
        ),

        body: Column(
          children: [
            Container(
              
              margin: EdgeInsets.all(10.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  <Widget>[

                  RaisedButton(
                    onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    
                                  },
                                  controller: nameEditingController,
                                  decoration: InputDecoration(
                                      labelText: "Name",
                                      hintText: "Name",
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                                ),
                              ),
                            );
                          },
                        ) ;
                    },
                    child: Text(
                      'Name',
                      style: TextStyle(fontSize: 12)
                    ),
                  ),
                  SizedBox(height: 30),

                  RaisedButton(
                    onPressed: () {
                      _selectDate();
                    },
                    child: Text(
                      'Date',
                      style: TextStyle(fontSize: 12)
                    ),
                  ),
                  SizedBox(height: 30),

                  RaisedButton(
                    onPressed: () {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    
                                  },
                                  controller: businessEditingController,
                                  decoration: InputDecoration(
                                      labelText: "Business",
                                      hintText: "Business",
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                                ),
                              ),
                            );
                          },
                        ) ;
                    },
                    child: Text(
                      'Business',
                      style: TextStyle(fontSize: 12)
                    ),
                  ),
                  SizedBox(height: 30),

                  RaisedButton(
                    onPressed: () {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    
                                  },
                                  controller: amountEditingController,
                                  decoration: InputDecoration(
                                      labelText: "Amount",
                                      hintText: "Amount",
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                                ),
                              ),
                            );
                          },
                        ) ;
                    },
                    child: Text(
                      'Amount',
                      style: TextStyle(fontSize: 12)
                    ),
                  ),
                ],
              ),


            ),
            Expanded(
              child: Container(
              
              margin: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(_value),
                    SizedBox(height: 50),
                    widget.lista
                    
                  ],
                )
                
                
                
                
              ),
            )
          ]
        )
        
      ),
    );
  }
}
