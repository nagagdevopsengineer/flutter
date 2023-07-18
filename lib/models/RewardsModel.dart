class RewardsModel {
  int? id;
  String? memberid;
  String? billamount;
  String? discountid;
  String? finalamount;
  String? otp;
  bool? isotpvalidated;
  String? createdat;
  String? restaurantuniqueid;
  String? rewardspoints;
  String? restaurantid;
  Restaurants? restaurants;

  RewardsModel(
      {this.id,
      this.memberid,
      this.billamount,
      this.discountid,
      this.finalamount,
      this.otp,
      this.isotpvalidated,
      this.createdat,
      this.restaurantuniqueid,
      this.rewardspoints,
      this.restaurantid,
      this.restaurants});

  RewardsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberid = json['memberid'];
    billamount = json['billamount'];
    discountid = json['discountid'];
    finalamount = json['finalamount'];
    otp = json['otp'];
    isotpvalidated = json['isotpvalidated'];
    createdat = json['createdat'];
    restaurantuniqueid = json['restaurantuniqueid'];
    rewardspoints = json['rewardspoints'];
    restaurantid = json['restaurantid'];
    restaurants = json['restaurants'] != null
        ? new Restaurants.fromJson(json['restaurants'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['memberid'] = this.memberid;
    data['billamount'] = this.billamount;
    data['discountid'] = this.discountid;
    data['finalamount'] = this.finalamount;
    data['otp'] = this.otp;
    data['isotpvalidated'] = this.isotpvalidated;
    data['createdat'] = this.createdat;
    data['restaurantuniqueid'] = this.restaurantuniqueid;
    data['rewardspoints'] = this.rewardspoints;
    data['restaurantid'] = this.restaurantid;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants!.toJson();
    }
    return data;
  }
}

class Restaurants {
  int? id;
  String? name;
  String? contactperson;
  String? phonenumber;
  String? cin;
  String? gst;
  String? pan;
  String? uniqueid;
  String? imahge;
  int? pincode;
  String? location;
  String? createdAt;
  String? updatedAt;
  String? remarks;
  String? userId;
  String? createdById;
  String? updatedById;
  bool? isDeleted;
  String? menuurl;
  String? picksurl;
  String? cuisines;
  String? email;
  String? acctemail;
  String? districtsId;
  String? restaurantsGroupsId;

  Restaurants(
      {this.id,
      this.name,
      this.contactperson,
      this.phonenumber,
      this.cin,
      this.gst,
      this.pan,
      this.uniqueid,
      this.imahge,
      this.pincode,
      this.location,
      this.createdAt,
      this.updatedAt,
      this.remarks,
      this.userId,
      this.createdById,
      this.updatedById,
      this.isDeleted,
      this.menuurl,
      this.picksurl,
      this.cuisines,
      this.email,
      this.acctemail,
      this.districtsId,
      this.restaurantsGroupsId});

  Restaurants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contactperson = json['contactperson'];
    phonenumber = json['phonenumber'];
    cin = json['cin'];
    gst = json['gst'];
    pan = json['pan'];
    uniqueid = json['uniqueid'];
    imahge = json['imahge'];
    pincode = json['pincode'];
    location = json['location'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    remarks = json['remarks'];
    userId = json['userId'];
    createdById = json['createdById'];
    updatedById = json['updatedById'];
    isDeleted = json['isDeleted'];
    menuurl = json['menuurl'];
    picksurl = json['picksurl'];
    cuisines = json['cuisines'];
    email = json['email'];
    acctemail = json['acctemail'];
    districtsId = json['districtsId'];
    restaurantsGroupsId = json['restaurantsGroupsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contactperson'] = this.contactperson;
    data['phonenumber'] = this.phonenumber;
    data['cin'] = this.cin;
    data['gst'] = this.gst;
    data['pan'] = this.pan;
    data['uniqueid'] = this.uniqueid;
    data['imahge'] = this.imahge;
    data['pincode'] = this.pincode;
    data['location'] = this.location;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['remarks'] = this.remarks;
    data['userId'] = this.userId;
    data['createdById'] = this.createdById;
    data['updatedById'] = this.updatedById;
    data['isDeleted'] = this.isDeleted;
    data['menuurl'] = this.menuurl;
    data['picksurl'] = this.picksurl;
    data['cuisines'] = this.cuisines;
    data['email'] = this.email;
    data['acctemail'] = this.acctemail;
    data['districtsId'] = this.districtsId;
    data['restaurantsGroupsId'] = this.restaurantsGroupsId;
    return data;
  }
}
