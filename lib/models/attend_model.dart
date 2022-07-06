class AttendModel {
  String? id;
  String? attendType;
  String? date;
  String? sectionNumber;
  String? subjectId;
  String? subjectName;
  String? userId;
  String? userName;

  AttendModel(
      {this.id,
        this.attendType,
        this.date,
        this.sectionNumber,
        this.subjectId,
        this.subjectName,
        this.userId,
        this.userName});

  AttendModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attendType = json['attend_type'];
    date = json['date'];
    sectionNumber = json['section_number'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    userId = json['user_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['attend_type'] = this.attendType;
    data['date'] = this.date;
    data['section_number'] = this.sectionNumber;
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    return data;
  }
}