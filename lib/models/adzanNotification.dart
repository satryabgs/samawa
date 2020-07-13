class AdzanNotification{
  String _location;
  String _name;
  String _date;
  String _time;
  int  _id;
  AdzanNotification(this._id,this._name, this._time,this._date,this._location);

  AdzanNotification.fromMap(Map<String,dynamic> map){
    this._id = map['id'];
    this._name = map['name'];
    this._time = map['time'];
    this._date = map['date'];
    this._location = map['location'];
  }
  
  int get id => _id;
  // ignore: unnecessary_getters_setters
  String get name => _name;
  // ignore: unnecessary_getters_setters
  String get time => _time;
  // ignore: unnecessary_getters_setters
  String get date => _date;
  // ignore: unnecessary_getters_setters
  String get location => _location;

  // ignore: unnecessary_getters_setters
  set name(String value){
    _name = value;
  }

  // ignore: unnecessary_getters_setters
  set time(String value){
    _time = value;
  }
  // ignore: unnecessary_getters_setters
  set date(String value){
    _date = value;
  }

  // ignore: unnecessary_getters_setters
  set location(String value){
    _location = value;
  }


  Map<String, dynamic>toMap(){
    Map<String,dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['time'] = this.time;
    map['date'] = this.date;
    map['location'] = this.location;
    return map;
  }
}