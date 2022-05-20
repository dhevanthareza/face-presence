class PresenceEntity {
  String? sId;
  String? userId;
  String? date;
  String? checkInDatetime;
  CroppedPhoto? croppedPhoto;
  CroppedPhoto? photo;
  double? distance;
  String? createdAt;
  String? updatedAt;
  CroppedPhoto? checkOutCroppedPhoto;
  String? checkOutDatetime;
  double? checkOutDistance;
  CroppedPhoto? checkOutPhoto;

  PresenceEntity({
    this.sId,
    this.userId,
    this.date,
    this.checkInDatetime,
    this.croppedPhoto,
    this.photo,
    this.distance,
    this.createdAt,
    this.updatedAt,
    this.checkOutCroppedPhoto,
    this.checkOutDatetime,
    this.checkOutDistance,
    this.checkOutPhoto,
  });

  PresenceEntity.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    date = json['date'];
    checkInDatetime = json['check_in_datetime'];
    croppedPhoto = json['cropped_photo'] != null
        ? CroppedPhoto.fromJson(json['cropped_photo'])
        : null;
    photo =
        json['photo'] != null ? CroppedPhoto.fromJson(json['photo']) : null;
    distance = json['distance'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    checkOutCroppedPhoto = json['check_out_cropped_photo'] != null
        ? CroppedPhoto.fromJson(json['check_out_cropped_photo'])
        : null;
    checkOutDatetime = json['check_out_datetime'];
    checkOutDistance = json['check_out_distance'];
    checkOutPhoto = json['check_out_photo'] != null
        ? CroppedPhoto.fromJson(json['check_out_photo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['userId'] = userId;
    data['date'] = date;
    data['check_in_datetime'] = checkInDatetime;
    if (croppedPhoto != null) {
      data['cropped_photo'] = croppedPhoto!.toJson();
    }
    if (photo != null) {
      data['photo'] = photo!.toJson();
    }
    data['distance'] = distance;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (checkOutCroppedPhoto != null) {
      data['check_out_cropped_photo'] = checkOutCroppedPhoto!.toJson();
    }
    data['check_out_datetime'] = checkOutDatetime;
    data['check_out_distance'] = checkOutDistance;
    if (checkOutPhoto != null) {
      data['check_out_photo'] = checkOutPhoto!.toJson();
    }
    return data;
  }
}

class CroppedPhoto {
  String? name;
  String? tag;
  String? access;
  String? location;

  CroppedPhoto({this.name, this.tag, this.access, this.location});

  CroppedPhoto.fromJson(Map<String, dynamic> json) {
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
