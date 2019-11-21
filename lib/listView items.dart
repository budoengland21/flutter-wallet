import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet/cardTappedQR.dart';
import 'main.dart';
import 'cardTappedBarcode.dart';



class makeListView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    //add separator
    return ListView.builder(

      itemCount: items.length, itemBuilder: (context, index){
      return  SafeArea(


          child: GestureDetector(

            child: Hero(
              tag: items[index],
              child: Container(


                  height: 120,

                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: hexToColor(items[index].color), borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),

                  ),
                   boxShadow: [BoxShadow(
                      color: Colors.blueGrey, blurRadius: 10, spreadRadius: 5)],
                   ),




                //  margin: EdgeInsets.symmetric(vertical: 0,),
                  child: Center(child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(items[index].getName(), style: TextStyle(decoration: TextDecoration.none,fontSize: 25,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                    //items[index].getName
                  ),),



              ),
            ),
            //run code to display QR image//barcode
            onTap:(){
             
              //IF its is a QR code
              if (items[index].getFormat().toString() == 'QR CODE'){
                  Navigator.push(fam, MaterialPageRoute(builder: (context)=> displayImageQR(items[index],index),));
                }
              else{
                Navigator.push(fam, MaterialPageRoute(builder: (context)=> displayImageBar(items[index],index)));
              }

//COMMENTED FOR TESTING
      //
      },

        )
      );

    },
    );
  }
}

