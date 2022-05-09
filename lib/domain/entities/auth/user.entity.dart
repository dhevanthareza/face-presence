class UserEntity {
  String? sId;
  String? fullname;
  String? email;
  String? password;
  Photo? photo;
  Photo? croppedPhoto;
  List<dynamic>? photoFeature;
  int? iV;

  UserEntity(
      {this.sId,
      this.fullname,
      this.email,
      this.password,
      this.photo,
      this.croppedPhoto,
      this.photoFeature,
      this.iV});

  UserEntity.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullname = json['fullname'];
    email = json['email'];
    password = json['password'];
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    croppedPhoto = json['cropped_photo'] != null
        ? new Photo.fromJson(json['cropped_photo'])
        : null;
    photoFeature = json['photo_feature'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['password'] = this.password;
    if (this.photo != null) {
      data['photo'] = this.photo!.toJson();
    }
    if (this.croppedPhoto != null) {
      data['cropped_photo'] = this.croppedPhoto!.toJson();
    }
    data['photo_feature'] = this.photoFeature;
    data['__v'] = this.iV;
    return data;
  }
}

class Photo {
  String? name;
  String? tag;
  String? access;
  String? location;

  Photo({this.name, this.tag, this.access, this.location});

  Photo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    tag = json['tag'];
    access = json['access'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['tag'] = this.tag;
    data['access'] = this.access;
    data['location'] = this.location;
    return data;
  }
}