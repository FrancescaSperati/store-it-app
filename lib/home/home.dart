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


final String GET_USER_HISTORY_TOT_URI = "https://localhost:3002/api/receipt/readTot";

class HomePage extends StatefulWidget {
  final UserDTO activeUser;
  HomePage({Key key, @required this.activeUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _totaleACASO = 0;
  @override
  void initState() {
    setTotal();
    super.initState();
  }

  
  Future<int> getUserHistory(userId) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json"
    };
    Map body = {"userId": userId};
    // make POST request
    var response = await http.post(GET_USER_HISTORY_TOT_URI, headers: headers, body: jsonEncode(body));
    print('response: ' + response.body);
    int resp = int.parse(response.body);
    //print(int.parse(response.body)+1);
    if (response.statusCode == 200) {
      return resp;
    } else {
      return -1;
    }
  }

  setTotal() async{
    int tot = await getUserHistory(widget.activeUser.userId);
    setState(() {
      _totaleACASO = tot;
    });
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
                print('user id: '+user.userId);
                Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new ProfilePage(activeUser: user);
                }));
              }),

            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'Filter', 
              onPressed: () => setState(() {
                Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new FiltersPage(user);
                }));
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
                    ) : Text(
                    'Total: $_totaleACASO',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)
                  ),
                  floating: true,
                  expandedHeight: 60,
                  backgroundColor:  Colors.white,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => BodyLayout(user,"","","",""),
                    childCount: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 50.0,),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            Navigator.of(context).push(MaterialPageRoute<Null>(
                builder: (BuildContext context) {
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



