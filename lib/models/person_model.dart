class PersonModel {
  final String? id;
  final String name;
  final String phoneNumber;
  final int? age;
  final int? classesAttended;
  final int daysCheckedIn;

  PersonModel({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.age,
    this.classesAttended,
    this.daysCheckedIn = 0,
  });

  static String? _idFromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map && value['\$oid'] != null) return value['\$oid'] as String?;
    return value.toString();
  }

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: _idFromJson(json['_id'] ?? json['id']),
      name: json['name'] as String? ?? '',
      phoneNumber: (json['phoneNumber'] ?? json['phone_number'] ?? '').toString(),
      age: json['age'] is int ? json['age'] as int : (json['age'] != null ? int.tryParse(json['age'].toString()) : null),
      classesAttended: json['classesAttended'] is int ? json['classesAttended'] as int : (json['classesAttended'] != null ? int.tryParse(json['classesAttended'].toString()) : null),
      daysCheckedIn: json['daysCheckedIn'] is int ? json['daysCheckedIn'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        if (age != null) 'age': age,
        if (classesAttended != null) 'classesAttended': classesAttended,
        'daysCheckedIn': daysCheckedIn,
      };
}
