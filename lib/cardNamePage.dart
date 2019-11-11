import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet/BarcodeCard.dart';
import 'package:wallet/cardTappedBarcode.dart';
import 'package:wallet/cardTappedQR.dart';
import 'package:wallet/main.dart' ;

import 'main.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'BarcodeCard.dart';
import 'StoredData.dart';

class modifyCard extends StatefulWidget {
   //half the screen
  BarcodeProperty barcodeProperty; // for updating if users  wants to
  final Barcode barcode; // this is just barcode that was scanner
 int runOnce=0;


  modifyCard(this.barcodeProperty, this.barcode); //);

  @override
  _modifyCardState createState() => _modifyCardState();
}

class _modifyCardState extends State<modifyCard> {
  double wid = MediaQuery.of(fam).size.width - 40;
  double hei = MediaQuery.of(fam).size.height;
  Color pickerColor = Color(0xff443a49);
  String oldTitle;
  int runOnce=0;
  TextEditingController nickname = new TextEditingController();
  Color originalBackground=Color(0xFF000000);
  String title='Enter Card Name';

  // ValueChanged<Color> callback
  void changeColor(Color picked) {// so when called, user clicks on color, picked updated
    setState(() {
      pickerColor = picked;


    });}
// get original color and name


  @override
  Widget build(BuildContext context) {
    if (widget.barcode == null && runOnce==0){//that means user is trying to update card
      setState(() {
        title = widget.barcodeProperty.getName();
        oldTitle = widget.barcodeProperty.getName();

       pickerColor= (hexToColor(widget.barcodeProperty.color));

      });

    }
    runOnce=1;

    return Scaffold(
      backgroundColor: originalBackground, // cover the top
      resizeToAvoidBottomInset: false,


      body: SafeArea(
          child: Container(
            color: Colors.grey, // wrapped in container to apply color around round border
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(


                    decoration: BoxDecoration(color: originalBackground, borderRadius: BorderRadius.only(bottomLeft: (Radius.circular(20)), bottomRight: Radius.circular(20))),

                    height: wid/2,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50, left:30, right:30 ),
                      child: Container(

                        decoration: BoxDecoration(color: pickerColor, borderRadius: BorderRadius.only(topLeft: (Radius.circular(20)), topRight: Radius.circular(20))),
                        child: Center(
                          child: Text(
                            title,style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // crossAxisAlignment: CrossAxisAlignment.center,





                      ),
                    ),


                  ),

                  Expanded(

                    child:
                    Container(
                      //color: Colors.purple,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
                            child: TextFormField(
                              //update name as user writes
                              onChanged: (nickname){
                                setState(() {
                                  title = nickname.toString();

                                });
                              } ,

                              controller: nickname,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(

                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  hintText: 'Enter name of Card',hintStyle:TextStyle(fontSize: 20, color: Colors.white)
                              ),
                              textInputAction: TextInputAction.done,




                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:50.0),
                            child: SizedBox( // for button resizing
                              height: 50,
                              width: 250,



                              child: RaisedButton(
                                onPressed:(
                                    ) {
                                  //showdialog which returns a dialog showing colors
                                  showDialog(context:context,builder: (BuildContext context){
                                    return  AlertDialog(
                                        title: const Text('Choose Card Color'),


                                        content: SingleChildScrollView(
                                      // allow scroll in color widgetview
                                         child: BlockPicker( // picker class from flutter_color_picker widget
                                        pickerColor: pickerColor,// just initial color provided
                                        onColorChanged: changeColor,
                                        availableColors: [
                                          Colors.red,
                                          Colors.purple,
                                          Colors.lightBlue,
                                          Colors.yellow,
                                          Colors.orange,
                                          Colors.cyan,
                                          Colors.pink,
                                          Colors.lime,

                                        ],
                                        // callback to update container
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Got It!'),
                                        onPressed:(){
                                          //pops off this dialog box
                                          Navigator.of(context).pop();},
                                      )
                                    ],
                                  );
                                  },);



                                },
                                color: Colors.green,
                                elevation: 8,



                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.white)
                                ),
                                child: Text(
                                    'Pick A Color'
                                ) ,



                              ),
                            ),
                          ),






                        ],

                      ),
                    ),




                  )

                  ,]
            ),
          )



      ),floatingActionButton: FloatingActionButton(

        onPressed:(){
          if (widget.barcode == null){//if updating
            print('pass');
            updateDatabase(widget.barcodeProperty, nickname.text, colorToHex(pickerColor), oldTitle);
            updateStateOfList(widget.barcodeProperty,title, pickerColor);
            Navigator.pop(context);//pop it and go back to where your barcode displayed
          }
          else{//add to database
           idTrack+=1; // increase id each time add card


          BarcodeProperty card = new BarcodeProperty(idTrack ,nickname.text,colorToHex(pickerColor),widget.barcode.displayValue,widget.barcode.getFormatString());
        insertDatabase(card);
        items.add(card);
        Navigator.pop(context);barcodes.clear();}
        },
        child: Icon(Icons.done),
         backgroundColor: Colors.orange,
          elevation: 8,
    ),

    );
  }
}
//method allows input details of card, and passed in the list so as to add barcode info to list in order to build home page
// color picker

//dont need to wait for this to finish
void insertDatabase(BarcodeProperty card)   {
  DataStorage storage =  DataStorage();
   storage.insertItem(card);///store in database
   storage.lastItem();//get idNumber of last item so as update ids and add to it incase user deleted


}
void updateDatabase(BarcodeProperty b, String name, String pick, String oldTitle) {
  DataStorage storage = DataStorage();
  print('$name');
  print('CHANGEDDDD');
  b.setColor(pick);
  b.setName(name);
  storage.updateItem(b, oldTitle);
  //storage.updateColor(b);



}

void updateStateOfList(BarcodeProperty type, String newName, Color newColor){
  if (type.getFormat().toString() == 'QR CODE'){
    items.elementAt(QRindexValue).setName(newName);
    items.elementAt(QRindexValue).setColor(colorToHex(newColor));
  }
 else{
    items.elementAt(BarindexValue).setName(newName);
    items.elementAt(BarindexValue).setColor(colorToHex(newColor));
  }


}
