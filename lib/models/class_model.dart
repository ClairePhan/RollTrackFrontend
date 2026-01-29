class ClassModel {
  final String name;
  final String instructor;
  final String time;
  final String location;
  final String? schedule; // e.g., "M/W/F"
  final String? timeRange; // e.g., "8:00 PM - 9:00"

  ClassModel({
    required this.name,
    required this.instructor,
    required this.time,
    required this.location,
    this.schedule,
    this.timeRange,
  });
}

