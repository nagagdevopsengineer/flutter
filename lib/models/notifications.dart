class Notifications {
  int? id;
  String? memberId;
  String? clientName;
  String? notificationType;
  String? notificationContent;
  String? playerId;
  bool isRead;
  DateTime createdAt;

  Notifications(
      {this.id,
      this.memberId,
      this.clientName,
      this.notificationType,
      this.notificationContent,
      this.playerId,
      required this.createdAt,
      required this.isRead});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      clientName: json['membername'],
      createdAt: json['createdat'] != null
          ? DateTime.parse(json['createdat'])
          : DateTime.now(),
      id: json['id'],
      playerId: json['playerid'],
      memberId: json['memberid'],
      notificationContent: json['notificationcontent'],
      notificationType: json['notificationcontent'],
      isRead: json['isRead'] ?? false,
    );
  }

  //  Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['memberid'] = this.memberId;
  //   data['clientname'] = this.clientName;
  //   data['notificationtype'] = this.notificationType;
  //   data['notificationcontent'] = this.notificationContent;
  //   data['playerid'] = this.playerId;
  //   data['createdat'] = this.createdAt;
  //   return data;
  // }
}
