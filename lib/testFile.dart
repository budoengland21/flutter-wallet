

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Item{
  int id;
  String name;
  String disp;

  Item(this.id, this.name, this.disp);

  //use a map with titles as id,code,format
  Map<String, dynamic> mapIt(){
    return {
      'id': id,
      'code': name,
      'format': disp,
    };


}
 String getname(){
    return name;
 }

}


void main() {
   Color c = Colors.blue;
 //  String v = c.value.toRadixString(16);
   
  // print(c.value.toRadixString(16).substring(2));


  String hex = '#${c.value.toRadixString(16).substring(2)}'; //change color to hex #f00000
   print(hex);
  print (Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000));


   Color(0xff2196f3);
  //Color(0xffff0000);
  Color(0xffffff00);



}