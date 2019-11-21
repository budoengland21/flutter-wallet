import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:wallet/cardNamePage.dart';
import 'StoredData.dart';
import 'main.dart';
import 'BarcodeCard.dart';
import 'package:barcode_flutter/barcode_flutter.dart';


int BarindexValue;

// when a card tapped that is supposed to produce a Barcode
class displayImageBar extends StatelessWidget {



  final BarcodeProperty barcode;
  final int index;
  double normalBright;
  displayImageBar(this.barcode, this.index);

  void delete() async{
    DataStorage storage =  DataStorage();
   items.removeAt(index);//remove item at that index, so update items in list when it builds again

    await storage.deleteItem(barcode.getName());
    FlutterScreen.resetBrightness();
    int last = await storage.lastItem(); //get index of last item so as  avoid id's being same in databse
    idTrack = last;



}
//go back to cardNamePage and allow user to change name or color
 void updateCard() async{ // just substitute width with index,(workaround) since we dont use width in modify card
    //DataStorage storage = DataStorage();
    Navigator.push(fam, MaterialPageRoute(builder: (context)=> modifyCard(barcode,null )) );//1 = means that updating card
   
 }

  Future<bool> BackPressed() async {
    //put back normal brightness
    FlutterScreen.resetBrightness();
    // Navigator.pop(QRcontext,true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    BarindexValue = index; // so as to know where index of item to update on another page(thats why static to access it)

    FlutterScreen.setBrightness(1);//increase brightness
    FlutterScreen.keepOn(true);




    double  height = (MediaQuery.of(context).size.height) ;
     double width = MediaQuery.of(context).size.width;
    // const h = height;

    return WillPopScope(
      onWillPop: BackPressed,
      child: Scaffold(appBar: AppBar(
          backgroundColor: hexToColor(barcode.color),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black,size: 30),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),iconSize: 30,padding: EdgeInsets.only(right: 50),

              onPressed: () { updateCard();


              },
            ),
            IconButton(
              icon: Icon(Icons.delete), iconSize: 30,
              onPressed: (){
                delete();
                Navigator.pop(context);

              },
            )
          ]
       ),
        backgroundColor: hexToColor(barcode.color),
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
                          tag: index,
                          child: Text(
                            barcode.getName(), style: TextStyle(fontSize: 40, decoration: TextDecoration.none),
                          ),


                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
                        child: FittedBox(
                          fit: BoxFit.contain,
                                alignment: Alignment.center,




                                child: BarCodeImage(
                                  data: barcode.display,
                                 //padding: EdgeInsets.all(20),
                                 hasText: true,
                                 lineWidth: 1.5,

                                 codeType: BarCodeType.Code128,
                                barHeight: 150,//get barheight and apply white background
//use container wrapped in white background
                                ),


                          ),
                      ),


                    ],
                  ),
                )
              ),
            ),



      ),
    );

  }
}

/*BarCodeImage(
data: "1234ABCD",
hasText: true,
codeType: BarCodeType.Code39,
barHeight: 8,//get barheight and apply white background
//use container wrapped in white background


)*/
