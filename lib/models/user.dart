class User{
  String _name;
  int _gender, _id;

  User(this._id,this._name,this._gender);
  

  User.fromMap(Map<String,dynamic> map){
    this._id = map['id'];
    this._name = map['name'];
    this._gender = map['gender'];
  }

  int get id => _id;
  // ignore: unnecessary_getters_setters
  String get name => _name;
  // ignore: unnecessary_getters_setters
  int get gender => _gender;


  // ignore: unnecessary_getters_setters
  set name(String value){
    _name = value;
  }

  // ignore: unnecessary_getters_setters
  set gender(int value){
    _gender = value;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = Map<String,dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['gender'] = gender;
    return map;
  }
}