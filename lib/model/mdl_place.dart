class Place {
  int? id;
  String? name;
  String? state;
  String? category;
  String? description;
  String? image;
  double? latitude;
  double? longitude;
  String? contact;
  double? rating;

  Place(
      {id,
      name,
      state,
      category,
      description,
      image,
      latitude,
      longitude,
      contact,
      rating});

  Place.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    state = json['state'];
    category = json['category'];
    description = json['description'];
    image = json['image_url'];
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    contact = json['contact'];
    rating = (json['rating'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['state'] = state;
    data['category'] = category;
    data['description'] = description;
    data['image_url'] = image;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['contact'] = contact;
    data['rating'] = rating;
    return data;
  }
}
