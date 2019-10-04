import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import '../add_new/add_new.dart';
import '../profile/profile.dart';
import '../util/list.dart';
import '../filters/filters.dart';
import '../util/UserDTO.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

final String GET_USER_HISTORY_TOT_URI =
    "https://localhost:3002/api/receipt/readTot";

class HomePage extends StatefulWidget {
  final UserDTO activeUser;
  HomePage({Key key, @required this.activeUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _totaleACASO = 0;
  bool filtri = false;

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController businessEditingController = TextEditingController();
  TextEditingController amountEditingController = TextEditingController();
  String _value = "";
  String filterBy = "";
  String  name = "", date ="", business="", amount="";

  @override
  void initState() {
    setTotal();
    super.initState();
  }

  Future<int> getUserHistory(userId) async {
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
    int resp;
    resp = int.parse(response.body);

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
    int tot = await getUserHistory(widget.activeUser.userId);
    setState(() {
      _totaleACASO = tot;
    });
  }

  filterTheList(){
    if(filterBy!= ""){
      //filtra
      
    }else{
      //non filtrare
    }
  }


  @override
  Widget build(BuildContext context) {
    UserDTO user = widget.activeUser;
    return MaterialApp(
      title: 'Store-it-APP',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Store-it-APP'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'Profile',
              onPressed: () => setState(() {
                print('user id: ' + user.userId);
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: _totaleACASO == 0
                      ? SpinKitSpinningCircle(
                          color: Colors.black,
                          size: 50.0,
                        )
                      : Text('Total: $_totaleACASO',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                  floating: true,
                  expandedHeight: 60,
                  backgroundColor: Colors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    RaisedButton(
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
                                                padding: EdgeInsets.all(8.0),
                                                child: TextField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _value = value;
                                                      filterBy = "name";
                                                    });
                                                  },
                                                  controller:
                                                      nameEditingController,
                                                  decoration: InputDecoration(
                                                      labelText: "Name",
                                                      hintText: "Name",
                                                      prefixIcon: Icon(
                                                          Icons.filter_list),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      25.0)))),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text('Name',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                    SizedBox(height: 30),
                                    RaisedButton(
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
                                    SizedBox(height: 30),
                                    RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          _value = "";
                                          filterBy = "business";
                                        });
                                        return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: TextField(
                                                  onChanged: (value) {
                                                    setState(
                                                        () => _value = value);
                                                  },
                                                  controller:
                                                      businessEditingController,
                                                  decoration: InputDecoration(
                                                      labelText: "Business",
                                                      hintText: "Business",
                                                      prefixIcon: Icon(
                                                          Icons.filter_list),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      25.0)))),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text('Business',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                    SizedBox(height: 30),
                                    RaisedButton(
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
                                                padding: EdgeInsets.all(8.0),
                                                child: TextField(
                                                  onChanged: (value) {
                                                    setState(
                                                        () => _value = value);
                                                  },
                                                  controller:
                                                      amountEditingController,
                                                  decoration: InputDecoration(
                                                      labelText: "Amount",
                                                      hintText: "Amount",
                                                      prefixIcon: Icon(
                                                          Icons.filter_list),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      25.0)))),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text('Amount',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 50.0,
                                      width: 280,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 50.0,
                                              width: 153,
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
                                        },
                                        textColor: Colors.white,
                                        color: Colors.red,
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => BodyLayout(user, name, date, business, amount),
                    childCount: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
