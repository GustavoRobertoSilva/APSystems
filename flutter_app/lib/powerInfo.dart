class PowerInfo {
  Data data;
  String code;

  PowerInfo({this.data, this.code});

  PowerInfo.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Data {
  String time;
  String power;

  Data({this.time, this.power});

  Data.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    power = json['power'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['power'] = this.power;
    return data;
  }
}
