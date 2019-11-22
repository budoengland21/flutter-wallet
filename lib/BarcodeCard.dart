

class BarcodeProperty{

     int _idName;
     String _name; // nickname of barcode
     String _color; // color of card

     String _displayValue; // value of barcode/QRcode
     String _format; // format of barcode

     BarcodeProperty( this._idName, this._name, this._color, this._displayValue, this._format);

     void increaseId(){

     }

     void setName(String given){_name = given;}

     void setDisplayValue(String i){_displayValue = i;}
     void setFormat(String s){_format = s;}
     //void setHeight(int i){_idName = i;}
     void setColor(String c){_color = c;}
     String getName() {return _name;}
     String getFormat(){return _format;}
     String get display{return _displayValue;}
// another way of implementing getters
       int get idName => _idName;
       String get color => _color; // f




     }

