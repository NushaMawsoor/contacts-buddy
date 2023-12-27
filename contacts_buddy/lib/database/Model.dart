class Model {
  int? id;
  String? personName;
  String? number;
  String? photoName;

  Model({this.id, this.personName, this.number, this.photoName});

  void setPhoto(int i, String imgString) {
    this.photoName = imgString;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'photoName': photoName,
    };
    return map;
  }

  Model.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photoName = map['photoName'];
  }

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      personName: json['name'],
      number: json['number'],
      photoName: json['photoname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': personName, 'number': number, 'photoname': photoName};
  }
}
