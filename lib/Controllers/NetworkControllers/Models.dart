class Member {
  int? id;
  String? email;
  String? dob;
  String? image;
  String? address;
  String? pincode;
  String? remarks;
  String? firstname;
  String? lastname;
  String? memberid;
  bool? isVerified;
  bool? isActivated;
  bool? isDeleted;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? userId;
  String? districtsId;
  String? createdById;
  String? updatedById;
  String? mobile;
  String? updatedAt;
  String? uuid;
  String? membertypeid;
  String? anniversarydate;
  String? tempurl;
  String? otp;
  bool? isVeg;
  String? playerId;
  String? rewardspoints;

  Member(
      {this.id,
      this.email,
      this.dob,
      this.image,
      this.address,
      this.pincode,
      this.remarks,
      this.firstname,
      this.lastname,
      this.memberid,
      this.isVerified,
      this.isActivated,
      this.isDeleted,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.userId,
      this.districtsId,
      this.createdById,
      this.updatedById,
      this.mobile,
      this.updatedAt,
      this.uuid,
      this.membertypeid,
      this.anniversarydate,
      this.tempurl,
      this.otp,
      this.playerId,
      this.rewardspoints,
      this.isVeg});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    dob = json['dob'];
    image = json['image'];
    address = json['address'];
    pincode = json['pincode'];
    remarks = json['remarks'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    memberid = json['memberid'];
    isVerified = json['isVerified'] ?? false;
    isActivated = json['isActivated'] ?? false;
    isDeleted = json['isDeleted'] ?? false;
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdAt = json['createdAt'];
    rewardspoints = json["rewardspoints"];
    userId = json['userId'];
    districtsId = json['districtsId'];
    createdById = json['createdById'];
    updatedById = json['updatedById'];
    mobile = json['mobile'];
    updatedAt = json['updatedAt'];
    uuid = json['uuid'];
    membertypeid = json['membertypeid'];
    anniversarydate = json['anniversarydate'] ?? "";
    tempurl = json['tempurl'] ?? "null";
    otp = json['otp'].toString();
    isVeg = json['isveg'];
    playerId = json['playerid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['image'] = this.image;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['remarks'] = this.remarks;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data["rewardspoints"] = this.rewardspoints;
    data['memberid'] = this.memberid;
    data['isVerified'] = this.isVerified;
    data['isActivated'] = this.isActivated;
    data['isDeleted'] = this.isDeleted;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['createdAt'] = this.createdAt;
    data['userId'] = this.userId;
    data['districtsId'] = this.districtsId;
    data['createdById'] = this.createdById;
    data['updatedById'] = this.updatedById;
    data['mobile'] = this.mobile;
    data['updatedAt'] = this.updatedAt;
    data['uuid'] = this.uuid;
    data['membertypeid'] = this.membertypeid;
    data['anniversarydate'] = this.anniversarydate;
    data['tempurl'] = this.tempurl;
    data['isveg'] = this.isVeg;
    return data;
  }
}

class Restaurant {
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
  String? restaurantsGroupsId;
  String? userId;
  String? districtsId;
  String? createdById;
  String? updatedById;
  bool? isDeleted;
  String? menuurl;
  String? picksurl;
  String? cuisines;
  List<Discounts>? discounts;

  Restaurant(
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
      this.restaurantsGroupsId,
      this.userId,
      this.districtsId,
      this.createdById,
      this.updatedById,
      this.isDeleted,
      this.menuurl,
      this.picksurl,
      this.cuisines,
      this.discounts});

  Restaurant.fromJson(Map<String, dynamic> json) {
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
    restaurantsGroupsId = json['restaurantsGroupsId'];
    userId = json['userId'];
    districtsId = json['districtsId'];
    createdById = json['createdById'];
    updatedById = json['updatedById'];
    isDeleted = json['isDeleted'];
    menuurl = json['menuurl'];
    picksurl = json['picksurl'];
    cuisines = json['cuisines'];
    if (json['discounts'] != null) {
      discounts = <Discounts>[];
      json['discounts'].forEach((v) {
        discounts!.add(new Discounts.fromJson(v));
      });
    }
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
    data['restaurantsGroupsId'] = this.restaurantsGroupsId;
    data['userId'] = this.userId;
    data['districtsId'] = this.districtsId;
    data['createdById'] = this.createdById;
    data['updatedById'] = this.updatedById;
    data['isDeleted'] = this.isDeleted;
    data['menuurl'] = this.menuurl;
    data['picksurl'] = this.picksurl;
    data['cuisines'] = this.cuisines;
    if (this.discounts != null) {
      data['discounts'] = this.discounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Discounts {
  int? id;
  String? name;
  int? discount;
  String? discountStartDate;
  String? discountEndDate;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? billAmount;
  String? createdById;
  String? updatedById;
  String? restaurantsId;

  Discounts(
      {this.id,
      this.name,
      this.discount,
      this.discountStartDate,
      this.discountEndDate,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.billAmount,
      this.createdById,
      this.updatedById,
      this.restaurantsId});

  Discounts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    discount = json['discount'];
    discountStartDate = json['discountStartDate'];
    discountEndDate = json['discountEndDate'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    billAmount = json['billAmount'];
    createdById = json['createdById'];
    updatedById = json['updatedById'];
    restaurantsId = json['restaurantsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['discount'] = this.discount;
    data['discountStartDate'] = this.discountStartDate;
    data['discountEndDate'] = this.discountEndDate;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['billAmount'] = this.billAmount;
    data['createdById'] = this.createdById;
    data['updatedById'] = this.updatedById;
    data['restaurantsId'] = this.restaurantsId;
    return data;
  }
}

class Event {
  int? id;
  String? name;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? eventDescription;
  String? location;
  String? pincode;
  String? image;
  String? seats;
  String? remarks;
  String? createdAt;
  String? updatedAt;
  String? extraString;
  bool? isActive;
  bool? isDeleted;
  String? createdById;
  String? updatedById;
  String? districtid;
  bool? isregistrationstopped;
  var price;
  String? contactperson;
  String? contactnumber;
  String? menuurl;

  Event(
      {this.id,
      this.name,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.eventDescription,
      this.location,
      this.pincode,
      this.image,
      this.seats,
      this.remarks,
      this.createdAt,
      this.updatedAt,
      this.extraString,
      this.isActive,
      this.isDeleted,
      this.createdById,
      this.updatedById,
      this.districtid,
      this.price,
      this.menuurl,
      this.contactnumber,
      this.contactperson,
      this.isregistrationstopped});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    eventDescription = json['eventDescription'];
    location = json['location'];
    pincode = json['pincode'];
    image = json['image'];
    seats = json['seats'];
    remarks = json['remarks'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    extraString = json['extraString'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdById = json['createdById'];
    updatedById = json['updatedById'];
    districtid = json['districtid'];
    isregistrationstopped = json['isregistrationstopped'];
    contactnumber = json['contactnumber'];
    contactperson = json['contactperson'];
    price = json['price'] ?? 0;
    menuurl = json['menuurl'] == "" ? null : json['menuurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['eventDescription'] = this.eventDescription;
    data['location'] = this.location;
    data['pincode'] = this.pincode;
    data['image'] = this.image;
    data['seats'] = this.seats;
    data['remarks'] = this.remarks;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['extraString'] = this.extraString;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['createdById'] = this.createdById;
    data['updatedById'] = this.updatedById;
    data['districtid'] = this.districtid;
    data['isregistrationstopped'] = this.isregistrationstopped;
    data['contactperson'] = this.contactperson;
    data['contactnumber'] = this.contactnumber;
    data['price'] = this.price;
    data['menuurl'] = this.menuurl;
    return data;
  }
}

class EventRegistration {
  String? createdAt;
  String? updatedAt;
  int? seats;
  String? remarks;
  String? description;
  bool? isActive;
  bool? isDeleted;
  String? extratString;
  String? userId;
  String? createdById;
  String? updatedById;
  int? eventsId;

  EventRegistration(
      {this.createdAt,
      this.updatedAt,
      this.seats,
      this.remarks,
      this.description,
      this.isActive,
      this.isDeleted,
      this.extratString,
      this.userId,
      this.createdById,
      this.updatedById,
      this.eventsId});

  EventRegistration.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    seats = json['seats'];
    remarks = json['remarks'];
    description = json['description'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    extratString = json['extratString'];
    userId = json['userId'];
    createdById = json['createdById'];
    updatedById = json['updatedById'];
    eventsId = json['eventsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['seats'] = this.seats;
    data['remarks'] = this.remarks;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['extratString'] = this.extratString;
    data['userId'] = this.userId;
    data['createdById'] = this.createdById;
    data['updatedById'] = this.updatedById;
    data['eventsId'] = this.eventsId;
    return data;
  }
}

class MasterTag {
  String? name;
  String? remarks;
  int? id;

  MasterTag({this.name, this.remarks, this.id});

  MasterTag.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    remarks = json['remarks'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['remarks'] = this.remarks;
    data['id'] = this.id;
    return data;
  }
}

class ChildTag {
  int? id;
  String? name;
  String? description;
  String? mastertagid;

  ChildTag({this.id, this.name, this.description, this.mastertagid});

  ChildTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    mastertagid = json['mastertagid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['mastertagid'] = this.mastertagid;
    return data;
  }
}

class Hotel {
  int? id;
  String? name;
  String? location;
  String? description;
  String? remarks;
  String? districtsId;

  Hotel(
      {this.id,
      this.name,
      this.location,
      this.description,
      this.remarks,
      this.districtsId});

  Hotel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    description = json['description'];
    remarks = json['remarks'];
    districtsId = json['districtsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['description'] = this.description;
    data['remarks'] = this.remarks;
    data['districtsId'] = this.districtsId;
    return data;
  }
}

class States {
  int? id;
  String? name;

  States({this.id, this.name});

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class District {
  int? id;
  String? name;

  District({this.id, this.name});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class NotificationModel {
  int? id;
  String? clientid;
  String? clientname;
  String? notificationtype;
  String? notificationcontent;
  String? playerid;
  DateTime? createdAt;

  NotificationModel(
      {this.id,
      this.clientid,
      this.clientname,
      this.notificationtype,
      this.notificationcontent,
      this.createdAt,
      this.playerid});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientid = json['clientid'];
    clientname = json['clientname'];
    notificationtype = json['notificationtype'] ?? "";
    notificationcontent = json['notificationcontent'];
    playerid = json['playerid'] ?? "";
    createdAt = json['createdat'] != null
        ? DateTime.parse(json['createdat'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['clientid'] = this.clientid;
    data['clientname'] = this.clientname;
    data['notificationtype'] = this.notificationtype;
    data['notificationcontent'] = this.notificationcontent;
    data['playerid'] = this.playerid;
    return data;
  }
}

class ContactUsQueryModel {
  int? id;
  String? subject;
  String? details;
  String? membersid;
  DateTime? createdat;
  String? updatedat;
  String? reply;

  ContactUsQueryModel(
      {this.id,
      this.subject,
      this.details,
      this.membersid,
      this.createdat,
      this.updatedat,
      this.reply});

  ContactUsQueryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    details = json['details'];
    membersid = json['membersid'];
    createdat = json['createdat'] != null
        ? DateTime.parse(json['createdat'].toString())
        : null;
    updatedat = json['updatedat'];
    reply = json['reply'] == "null" ? null : json['reply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['details'] = this.details;
    data['membersid'] = this.membersid;
    data['createdat'] = this.createdat.toString();
    data['updatedat'] = this.updatedat.toString();
    data['reply'] = this.reply;
    return data;
  }
}

class SignUpModel {
  String? email;
  String? dob;
  String? image;
  String? address;
  int? pincode;
  String? remarks;
  String? firstname;
  String? lastname;
  int? memberid;
  bool? isVerified;
  bool? isActivated;
  bool? isDeleted;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? userId;
  String? createdById;
  String? updatedById;
  int? mobile;
  String? updatedAt;
  String? uuid;
  String? anniversarydate;
  String? tempurl;
  int? membertypeid;
  int? otp;
  String? playerid;
  bool? isveg;
  int? rewardspoints;
  int? districtsId;

  SignUpModel(
      {this.email,
      this.dob,
      this.image,
      this.address,
      this.pincode,
      this.remarks,
      this.firstname,
      this.lastname,
      this.memberid,
      this.isVerified,
      this.isActivated,
      this.isDeleted,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.userId,
      this.createdById,
      this.updatedById,
      this.mobile,
      this.updatedAt,
      this.uuid,
      this.anniversarydate,
      this.tempurl,
      this.membertypeid,
      this.otp,
      this.playerid,
      this.isveg,
      this.rewardspoints,
      this.districtsId});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    dob = json['dob'];
    image = json['image'];
    address = json['address'];
    pincode = json['pincode'];
    remarks = json['remarks'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    memberid = json['memberid'];
    isVerified = json['isVerified'];
    isActivated = json['isActivated'];
    isDeleted = json['isDeleted'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdAt = json['createdAt'];
    userId = json['userId'];
    createdById = json['createdById'];
    updatedById = json['updatedById'];
    mobile = json['mobile'];
    updatedAt = json['updatedAt'];
    uuid = json['uuid'];
    anniversarydate = json['anniversarydate'];
    tempurl = json['tempurl'];
    membertypeid = json['membertypeid'];
    otp = json['otp'];
    playerid = json['playerid'];
    isveg = json['isveg'];
    rewardspoints = json['rewardspoints'];
    districtsId = json['districtsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['image'] = this.image;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['remarks'] = this.remarks;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['memberid'] = this.memberid;
    data['isVerified'] = this.isVerified;
    data['isActivated'] = this.isActivated;
    data['isDeleted'] = this.isDeleted;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['createdAt'] = this.createdAt;
    data['userId'] = this.userId;
    data['createdById'] = this.createdById;
    data['updatedById'] = this.updatedById;
    data['mobile'] = this.mobile;
    data['updatedAt'] = this.updatedAt;
    data['uuid'] = this.uuid;
    data['anniversarydate'] = this.anniversarydate;
    data['tempurl'] = this.tempurl;
    data['membertypeid'] = this.membertypeid;
    data['otp'] = this.otp;
    data['playerid'] = this.playerid;
    data['isveg'] = this.isveg;
    data['rewardspoints'] = this.rewardspoints;
    data['districtsId'] = this.districtsId;
    return data;
  }
}

class SelectedChildTag {
  int? id;
  String? childtagsid;
  String? memberid;
  String? description;
  bool? iddeleted;
  String? createdat;

  SelectedChildTag(
      {this.id,
      this.childtagsid,
      this.memberid,
      this.description,
      this.iddeleted,
      this.createdat});

  SelectedChildTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    childtagsid = json['childtagsid'];
    memberid = json['memberid'];
    description = json['description'];
    iddeleted = json['iddeleted'];
    createdat = json['createdat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['childtagsid'] = this.childtagsid;
    data['memberid'] = this.memberid;
    data['description'] = this.description;
    data['iddeleted'] = this.iddeleted;
    data['createdat'] = this.createdat;
    return data;
  }
}
