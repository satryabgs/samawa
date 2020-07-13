class AdzanIndicator{
  int _indicator, _id;

  AdzanIndicator(this._id,this._indicator);
  

  AdzanIndicator.fromMap(Map<String,dynamic> map){
    this._id = map['id'];
    this._indicator = map['indicator'];
  }

  int get id => _id;
  // ignore: unnecessary_getters_setters
  int get indicator => _indicator;


  // ignore: unnecessary_getters_setters
  set indicator(int value){
    _indicator = value;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = Map<String,dynamic>();
    map['id'] = this._id;
    map['indicator'] = indicator;
    return map;
  }
}