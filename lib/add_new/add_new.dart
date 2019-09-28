import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNewReceipt extends StatefulWidget {
  @override
  _AddNewReceiptWidgetState createState() => _AddNewReceiptWidgetState();
}

class _AddNewReceiptWidgetState extends State<AddNewReceipt> {
  TextEditingController nameContrller = TextEditingController();
  TextEditingController dateContrller = TextEditingController();
  TextEditingController businessContrller = TextEditingController();
  TextEditingController amountContrller = TextEditingController();
  TextEditingController pictureContrller = TextEditingController();
  
  File _image;

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text('Take a picture'),
                  onTap: getImage,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: new Text('Select from gallery'),
                  onTap: getImageFromGallery,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera);
      setState(() {
        _image = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery);
      setState(() {
        _image = image;
    });
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
          title: Text('Add a new Receipt'),
          
        ),
        body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              
                _image == null
                  ? Text('No image selected.')
                  : Image.file(_image),
                SizedBox(height: 10),


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 100,
                    child: MaterialButton(
                      elevation: 4,
                      highlightElevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      onPressed: () {
                        _optionsDialogBox();
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
                      height: 50,
                      child: Icon(Icons.photo),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              
              TextField(
                keyboardType: TextInputType.text,
                controller: nameContrller,
                decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Name",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.green,
                            style: BorderStyle.solid))),
              ),
              SizedBox(height: 10),

              TextField(
                keyboardType: TextInputType.datetime,
                controller: dateContrller,
                decoration: InputDecoration(
                    labelText: "Date",
                    hintText: "Date",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.green,
                            style: BorderStyle.solid))),
              ),
              SizedBox(height: 10),

              TextField(
                keyboardType: TextInputType.text,
                controller: businessContrller,
                decoration: InputDecoration(
                    labelText: "Business",
                    hintText: "Business",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.green,
                            style: BorderStyle.solid))),
              ),
              SizedBox(height: 10),

              TextField(
                keyboardType: TextInputType.number,
                controller: amountContrller,
                decoration: InputDecoration(
                    labelText: "Amount",
                    hintText: "Amount",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.green,
                            style: BorderStyle.solid))),
              ),
              SizedBox(height: 10),
              
              ButtonTheme(
                minWidth: double.infinity,
                child: MaterialButton(
                  elevation: 4,
                  highlightElevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () { 
                    print("checking all fields BEFORE ADDING A NEW ROW");
                    Navigator.pop(context);
                  },
                  textColor: Colors.white,
                  color: Colors.green,
                  height: 50,
                  child: Text("Add"),
                ),
              ),
              
              
            ],
          ),
        ),
      ),
      ),
    );
  }
}
