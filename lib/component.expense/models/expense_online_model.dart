class ExpenseOnline{

  int _id;
  String _storename;
  double _amount;
  DateTime _date;
  String _desc;

  //default constructor
  ExpenseOnline(this._storename,this._amount,[this._date,this._desc]);

  //NamedConstructor
  ExpenseOnline.withId(this._id,this._storename,this._amount,[this._date,this._desc]);

  //Getters
  int get id => _id;
  String get storename => _storename;
  double get amount => _amount;
  DateTime get date => _date;
  String get desc => _desc;

  //Setters
  set storename(String store){
    if(store.length <= 30){
      this._storename = store;
    }
  }


  set amount(double amount){
    this._amount = amount;
  }

  set date(DateTime date){
    this._date = date;
  }

  set desc(String desc){
    this._desc = desc;
  }


  //Convert the Input data into MapObject
  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(_id != null){
      map['id'] = _id;
    }
    map['storename'] = _storename;
    map['amount'] = _amount;
    map['date'] = _date;
    map['description'] = _desc;

    return map;  
  }
}