import 'dart:io';
import 'main.dart';

import 'package:wallet/BarcodeCard.dart';

import 'BarcodeCard.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



// we use a singleton where this class
// makes a singleton object, it only creates instance once
// so technically when app is run first time
// so if null, creates a new instance

//so order of execution:
 //= runs factory method - which return type of object
    // = if object is null, then runs createInstance , to initialize a database
// if exists it justs return the singleton object
// which is the database instance

//ENTIRE CLASS RUNS ONCE IN LIFECYCLE OF APP -> SINGLETON
class DataStorage {
  // static class we use to initiliaze instance
  static DataStorage dataStorage; // singleton class, created once
  static Database databaseFile; // singleton object




  //databse table columns
  String tableName = 'codes_table';
  String id = 'id';
  String colName = 'name' ;
  String colColors = 'colors';
  String colDisplayCode = 'code';
  String colFormat = 'format';

  DataStorage._createInstance(); // method to create instance, once created not
  // doesn't get destroyed and will always exist

  //

  // runs at the beginnig of the program
  // creates instance once, if application restarted just returns instance since already
  // made first time you made application
  // so add this method at top of class , so it creates instance once

  factory DataStorage(){
    if (dataStorage == null) {
      dataStorage = DataStorage._createInstance(); // goes to line 42
      
    }
    return dataStorage;
  }


 // just getter for database if u want access it
  //
  Future<Database> getDatabase() async {
    if (databaseFile == null) {
      databaseFile = await initializeDatabase(); // line 70, runs once
      
      // even if app restarts because it's not null
    }
    return databaseFile; // which is a table
  }

  // put this method when access database, before widget code starts
  // recommended to put in the init code or before state widget begins
  //runs once, because instance was created once
  // and initialize, create table and all that
// location for database
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path,
        'cards.db'); // add database file directory with the name as 'cards.db'
    //open database
    var myDatabase = await openDatabase(
        path, version: 13, onCreate: makeDatabase);
    return myDatabase;
  }

  //create database so create a table
  void makeDatabase(Database db, int version) async {
    try{

    await db.execute('CREATE TABLE '
        '$tableName' // title of table
        '($id INTEGER PRIMARY KEY, $colName TEXT, $colColors TEXT, $colDisplayCode TEXT, $colFormat TEXT)');
  }
  catch(Exception){
      print(Exception);
  }
  }

  // now for the helper methods_-------------------------________________________________________________________------------------------------------------

  //INSERT - to make new Card
  //Update- if user wants change name
  //delete - to delete a card


  //
   Future<void> insertItem(BarcodeProperty b) async{


    Database db = await this.getDatabase(); Map map = mapIt(b); // to map items
    await db.insert(tableName,map ); //inserts the map to database
     }

     //maps the objects since inserting to database takes in mapped items:
    Map<String, dynamic> mapIt(BarcodeProperty b) {

  

      //the map should be same name as table column titles so as they can be put in right place
      return {
        '$id': idTrack,
        '$colName': b.getName(),
        '$colColors': b.color,
        '$colDisplayCode': b.display,
        '$colFormat': b.getFormat(),
      };





    }


// return list of items, list of items is mapped items
  //used to retieve items in database in order to build when app is closed
Future<List<BarcodeProperty>> getAll() async{
    Database db = await getDatabase();
    List maps =  await db.query(tableName);

    
    //this method turns List<map> to list

    //items update to have database Cards
    return  List.generate(maps.length, (index){
      return  BarcodeProperty(
       maps[index]['$id'],
      maps[index]['$colName'],
      maps[index]['$colColors'],
      maps[index]['$colDisplayCode'],
      maps[index]['$colFormat'],
      );


    });

    

}

// update card if user wants to change name of card
Future<void> updateItem(BarcodeProperty b, String s) async{
    Database db = await getDatabase();
    //where: stands for which column to  update
    //whereArgs: apply the update to colName(names of the card), cards are allowed have same name
    // no errors since id's will be different
    //db.update(tableName, mapIt(b),where: '$colName=?', whereArgs: [b.getName()]);
    // db.update(tableName, mapIt(b),where: '$colColors=?', whereArgs: [b.color]);
    
  int count= await  db.rawUpdate('UPDATE $tableName SET $colName=?, $colColors=? WHERE $colName=? ',
                                   [b.getName(), b.color, s ]);
  print('updated: $count');


  }

// to delete a card
Future<void> deleteItem(String s) async{
   try {
     Database db = await getDatabase();

    db.delete(tableName, where: '$colName = ?', whereArgs: [s]);
      //items.length-=1;


      //items.removeAt(items.length-1); //update listview to remove last item
     // items.removeLast();//change to items.removeAt(items.length-1) because i dont want it to return


     //  db.delete(tableName,where: "id = ?", whereArgs: [b.getName()]);
     //optionally could update id, but wont matter although not in order but still be unique
   }catch(Exception){
     print(Exception);
     return null;
   }

}

//return the number of objects
Future<int> totalSize() async{
    Database db = await getDatabase();
    List <Map<String,dynamic>> map = await db.rawQuery('SELECT COUNT (*) from $tableName');
    int size = Sqflite.firstIntValue(map);
    return size;

}


//returns index/id of last item
Future<int> lastItem() async{
    Database db= await getDatabase();
    List<Map> result = await db.query(tableName);
    if (result.length == 0){
      return 0;
    }
    else{

    int Lastindex = result.length-1;

 

    return result[Lastindex].values.first;} // gets id of the last item.



    



}

}

