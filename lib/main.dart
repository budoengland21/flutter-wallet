import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet/BarcodeCard.dart';
import 'package:wallet/StoredData.dart';
import 'package:wallet/listView%20items.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';


import 'cardNamePage.dart';
import 'BarcodeCard.dart';



void main(){
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: cardStack(),));


}
BuildContext fam;
BuildContext Cardcontext; //context build variable for when user tries to update;
int idTrack = 0; // keep track of id's for database
List<BarcodeProperty> items = new List<BarcodeProperty>(); // store cards
List<Barcode> barcodes = []; // to store barcodes when pic taken
DataStorage storage;
int size;  //to update size when fetching from database
int lastId;








class cardStack extends StatefulWidget {


  @override
  _cardStackState createState() => _cardStackState();


}



class _cardStackState extends State<cardStack> {
//method retrieves info from database
  void updateDatabase() async {
      storage = DataStorage(); //runs DataStorage() method to check if instance exists(which is created once only btw)
      await storage.initializeDatabase();
      items = await storage.getAll(); // kinda slow doesn't show first time, so list will now be updated with the items in database
      size = await storage.totalSize(); // get the total size

      lastId  = await storage.lastItem();//get the last id in database


      setState(() {
        items.length = size; // just to inform the widget size has change so listview can be built with list updated
        idTrack = lastId; // initialize idtrack to last id, so it keeps adding to the database ID..
  });




  }
  //in this initial state,
  // retrieve database if exists, set the idTracker, obtain barcode property(cards) to build the listview(makeListView method)
  @override //________________________________________________________________________
  void initState() {
    
    super.initState();
    FlutterMobileVision.start(); //start the ML and asks permission before app starts, only runs once if permission denied close app and rerun
    //database retrieval
   updateDatabase(); //fetch database
    }



//build__________________________________________________________________________
    @override
    Widget build(BuildContext context) {
      fam = context;

      double width = MediaQuery
          .of(context)
          .size
          .width - 40;
      double height = MediaQuery
          .of(context)
          .size
          .height;
         // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);


      return Scaffold(
        appBar: AppBar(title:  Text('Pocket Rewards',),backgroundColor: Colors.black ,centerTitle: true,),
        backgroundColor: Colors.grey,

        body: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: makeListView(),
        ),
        // items should already be update, if cards were there, first time should be empty
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          tooltip: 'Take Image',
          onPressed: () => scan(width, height)


           //.Navigator.push(context, MaterialPageRoute(builder: (context)=> modifyCard(height/2,width))),//for testing just

        ),

      );
    }
    //_________________________________________________________________________
    // scans the barcode format using back camera
    Future<void> scan(double w, double h) async {
//    List<Barcode> tempList =[];
      //await until the function completes
      try {
        barcodes = await FlutterMobileVision.scan(
          formats: Barcode.ALL_FORMATS,
          showText: false,
          autoFocus: true,
          camera: FlutterMobileVision.CAMERA_BACK, // uses back camera to take
          flash: true,

        );


        //then go to different page that will allow to enter details of barcode for your card, - name
        // barcodes[0] first items of list then reset the list
          Navigator.push(fam, MaterialPageRoute(builder: (context)=> modifyCard(null,barcodes[0])));
      } catch (e) { // if error in scanning, unlikely to happen but enable back button to quit
        print('Error caught $e');
      }

      // test, assume barcode has display value from camera
    }
  }

Color hexToColor(String s){ // to retrieve string hex color and turn to color
  return (Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000)); // changes String in hex format #f000000 to Color(0xf00000)
}
String colorToHex(Color c){ //for database to store color as string
  return  '#${c.value.toRadixString(16).substring(2)}'; //change eg color(blue) to hex #f00000
}





