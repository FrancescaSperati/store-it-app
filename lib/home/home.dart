import 'package:flutter/material.dart';
import '../add_new/add_new.dart';
import '../profile/profile.dart';
import '../util/list.dart';
import '../filters/filters.dart';
import '../util/UserDTO.dart';


class HomePage extends StatefulWidget {
  final UserDTO activeUser;
  HomePage({Key key, @required this.activeUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  
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
                    return new FiltersPage();
                }));
              }),
            ),
          ],
        ),

        //body: BodyLayout(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text(
                    'Total: ',
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
                    (context, index) => BodyLayout(),
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
              return new AddNewReceipt();
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



