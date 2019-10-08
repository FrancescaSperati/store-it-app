import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../add_new/add_new.dart';
import '../profile/profile.dart';
import '../util/list.dart';
import '../util/UserDTO.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

final String GET_USER_HISTORY_TOT_URI =
    "https://10.1.6.133:3002/api/receipt/readTot";

class HomePage extends StatefulWidget {
  final UserDTO activeUser;
  HomePage({Key key, @required this.activeUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _totaleACASO = 0;
  bool filtri = false;
  String _value = "";
  String filterBy = "";
  String name = "", date = "", business = "", amount = "";

  @override
  void initState() {
    setTotal();
    super.initState();
  }

  Future<int> getUserTotal(userId) async {
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
    var response = await http.post(GET_USER_HISTORY_TOT_URI,
        headers: headers, body: jsonEncode(body));
    print('response: ' + response.body);

    int resp = 0; //initialize the total
    if (response.body != "") {
      //user has data
      var checkBody = jsonDecode(response.body);
      print(checkBody);
      resp = int.parse(checkBody.toString());
    }

    //print(int.parse(response.body)+1);
    if (response.statusCode == 200) {
      return resp;
    } else {
      return -1;
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
        _value = DateFormat("dd-MM-yyyy").format(picked).toString();
        filterBy = "date";
      });
    }
  }

  setTotal() async {
    int tot = await getUserTotal(widget.activeUser.userId);
    setState(() {
      _totaleACASO = tot;
    });
  }

  filterTheList() {
    if ((filterBy == "") || (filterBy == "NO FILTERS!!")) {
      name = "";
      date = "";
      business = "";
      amount = "";
    } else {
      if (filterBy == "name")
        name = _value;
      else if (filterBy == "date")
        date = _value;
      else if (filterBy == "amount")
        amount = _value;
      else
        business = _value;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserDTO user = widget.activeUser;
    return MaterialApp(
      title: 'Store-it-APP',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[700],
          title: Text('Store-it-APP'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'Profile',
              onPressed: () => setState(() {
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new ProfilePage(activeUser: user);
                }));
              }),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'Filter',
              onPressed: () => setState(() {
                filtri = !filtri;
              }),
            ),
          ],
        ),
        body: Container(
          
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    title: _totaleACASO == 0
                        ? SpinKitSpinningCircle(
                            color: Colors.black,
                            size: 20.0,
                          )
                        : Text('Total: $_totaleACASO',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                    floating: true,
                    expandedHeight: 60,
                    backgroundColor: Colors.transparent,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        filtri
                            ? Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      ButtonTheme(
                                        minWidth: 5,
                                        padding: new EdgeInsets.all(13.0),
                                        child: RaisedButton(
                                          textColor: Colors.white,
                                          color: Colors.lime[400],
                                          onPressed: () {
                                            setState(() {
                                              _value = "";
                                              filterBy = "";
                                            });

                                            return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _value = value;
                                                          filterBy = "name";
                                                        });
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText: "Name",
                                                          hintText: "Name",
                                                          prefixIcon: Icon(Icons
                                                              .filter_list),
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25.0)))),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Confirm'),
                                                      onPressed: () {
                                                        filterTheList();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('Name',
                                              style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ButtonTheme(
                                        minWidth: 5,
                                        padding: new EdgeInsets.all(13.0),
                                        child: RaisedButton(
                                          textColor: Colors.white,
                                          color: Colors.lime[400],
                                          onPressed: () {
                                            setState(() {
                                              _value = "";
                                              filterBy = "";
                                            });
                                            _selectDate();
                                          },
                                          child: Text('Date',
                                              style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ButtonTheme(
                                        minWidth: 5,
                                        padding: new EdgeInsets.all(13.0),
                                        child: RaisedButton(
                                          textColor: Colors.white,
                                          color: Colors.lime[400],
                                          onPressed: () {
                                            setState(() {
                                              _value = "";
                                              filterBy = "";
                                            });
                                            return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _value = value;
                                                          filterBy = "business";
                                                        });
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText: "Business",
                                                          hintText: "Business",
                                                          prefixIcon: Icon(Icons
                                                              .filter_list),
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25.0)))),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Confirm'),
                                                      onPressed: () {
                                                        filterTheList();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('Business',
                                              style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ButtonTheme(
                                        minWidth: 5,
                                        padding: new EdgeInsets.all(13.0),
                                        child: RaisedButton(
                                          textColor: Colors.white,
                                          color: Colors.lime[400],
                                          onPressed: () {
                                            setState(() {
                                              _value = "";
                                              filterBy = "amount";
                                            });
                                            return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _value = value;
                                                          filterBy = "amount";
                                                        });
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText: "Amount",
                                                          hintText: "Amount",
                                                          prefixIcon: Icon(Icons
                                                              .filter_list),
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25.0)))),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Confirm'),
                                                      onPressed: () {
                                                        filterTheList();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('Amount',
                                              style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ButtonTheme(
                                        minWidth: 5,
                                        padding: new EdgeInsets.all(13.0),
                                        child: IconButton(
                                          icon: const Icon(Icons.refresh),
                                          tooltip: 'refresh',
                                          onPressed: () => setState(() {
                                            _value = "SHOW ALL";
                                            filterBy = "NO FILTERS!!";
                                            filterTheList();
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 50.0,
                                        width: 250,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[300],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                height: 50.0,
                                                width: 150,
                                                child: Row(
                                                  children: <Widget>[
                                                    Text("Filter by "),
                                                    Text(filterBy),
                                                  ],
                                                ),
                                              ),
                                              Text(_value),
                                            ]),
                                      ),
                                      ButtonTheme(
                                        minWidth: double.infinity,
                                        child: MaterialButton(
                                          elevation: 4,
                                          highlightElevation: 2,
                                          minWidth: 35,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onPressed: () {
                                            filterTheList();
                                            setState(() {});
                                          },
                                          textColor: Colors.white,
                                          color: Colors.lightGreenAccent[700],
                                          height: 50,
                                          child: new Text(
                                            "GO",
                                            style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  new SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (_totaleACASO != 0) {
                          return new BodyLayout(
                              user, name, date, business, amount);
                        } else {
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 100,
                                ),
                                Text(":) Nothing to show",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.black,
                                    )),
                                SizedBox(
                                  height: 50,
                                ),
                                Text("Start adding new elements to your Store",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                    ))
                              ]);
                        }
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.lightGreen[700],
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreenAccent[700],
          onPressed: () => setState(() {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new AddNewReceipt(activeUser: user);
            }));
          }),
          tooltip: 'Add New Receipt',
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
