class PersonModel {
  final String name;
  final String phoneNumber;
  final int daysCheckedIn;

  PersonModel({
    required this.name,
    required this.phoneNumber,
    this.daysCheckedIn = 0,
  });
}
