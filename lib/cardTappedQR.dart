import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:wallet/main.dart' as prefix0;
import 'main.dart';
import 'BarcodeCard.dart';
import 'cardNamePage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/StoredData.dart';
import 'package:flutter_screen/flutter_screen.dart';


//when card clicked displays QR code
BuildContext QRcontext;
int QRindexValue;
class displayImageQR extends StatelessWidget {


  void delete(BarcodeProperty b) async{
    DataStorage storage =  DataStorage();
     prefix0.items.removeAt(index);//remove item at that index, so update items in list when it builds again
     await storage.deleteItem(QR.getName());
    FlutterScreen.resetBrightness();
     int last = await storage.lastItem(); //get index of last item so as  avoid id's being same in databse
     idTrack = last;





  }

  final BarcodeProperty QR;
  final int index;
  double normalBright;
  displayImageQR(this.QR, this.index);

  void obtainScreenBrightness() async{
    double brightness = await FlutterScreen.brightness;
    normalBright = brightness;

  }
  Future<bool> BackPressed() async {

    FlutterScreen.resetBrightness(); // reset brightness not working with ios

    return true;
  }
  void updateCard() async{ // just substitute width with index,(workaround) since we dont use width in modify card
    //DataStorage storage = DataStorage();
    Navigator.push(fam, MaterialPageRoute(builder: (context)=> modifyCard(QR,null )) );//null will mean that wanna update


  }


  @override
  Widget build(BuildContext context) {

    QRindexValue=index; // to update the list

    FlutterScreen.setBrightness(1);//increase brightness
    FlutterScreen.keepOn(true);



    double  height = (MediaQuery.of(context).size.height) ;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: BackPressed,
      child: Scaffold(appBar: AppBar(
        backgroundColor: prefix0.hexToColor(QR.color),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black,size: 30),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),iconSize: 30,padding: EdgeInsets.only(right: 50),

          onPressed : ()  {

            updateCard();



              },
       ),
          IconButton(
            icon: Icon(Icons.delete), iconSize: 30,
            onPressed: (){

              delete(QR);
              Navigator.pop(context);
            },
          ),
        ]
        ),

        backgroundColor: prefix0.hexToColor(QR.color),
        body:

        Center(
          child: Card(
            //margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              color: Colors.white,
              elevation: 10,
              child: Container(
                height: height/2,
                width: width-20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Hero(
                      tag: index,//fix

                       child: Text(
                          QR.getName(), style: TextStyle(fontSize: 40, decoration: TextDecoration.none),
                        ),
                     ),



                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Center(
                        child: Container(
                          child: QrImage(
                            data: QR.display,
                            version: QrVersions.auto,
                            size: height/4,


                          ),

                        ),
                      ),
                    )

                  ],
                ),
              )
          ),
        ),



      ),
    );

  }
}