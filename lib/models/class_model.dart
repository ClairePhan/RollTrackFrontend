class ClassModel {
  final String? id;
  final String? name;
  final String instructor;
  final String location;
  final List<String> days; // e.g. ["Mon", "Wed", "Fri"]
  final String? startTime;
  final String? endTime;
  final String time;
  final String? schedule;
  final String? timeRange;

  ClassModel({
    this.id,
    this.name,
    required this.instructor,
    required this.location,
    List<String>? days,
    this.startTime,
    this.endTime,
    String? time,
    this.schedule,
    this.timeRange,
  })  : days = days ?? [],
        time = time ?? _formatTimeRange(startTime, endTime);

  static String _formatTimeRange(String? start, String? end) {
    if (start != null && end != null) return '$start - $end';
    if (start != null) return start;
    if (end != null) return end;
    return '';
  }

  String get displayName => name ?? '$instructor - $location';
  String get scheduleDisplay => schedule ?? days.join('/');
  String get timeRangeDisplay => timeRange ?? time;

  static String? _idFromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map && value['\$oid'] != null) return value['\$oid'] as String?;
    return value.toString();
  }

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    final id = _idFromJson(json['_id'] ?? json['id']);
    final daysRaw = json['days'] ?? json['daysOfWeek'];
    final days = daysRaw is List
        ? daysRaw.map((e) => e.toString()).toList()
        : <String>[];
    final startTime = json['startTime']?.toString();
    final endTime = json['endTime']?.toString();
    return ClassModel(
      id: id?.toString(),
      name: json['name']?.toString(),
      instructor: json['instructor']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      days: days,
      startTime: startTime,
      endTime: endTime,
      time: json['time']?.toString() ?? _formatTimeRange(startTime, endTime),
      schedule: json['schedule']?.toString() ?? (days.isNotEmpty ? days.join('/') : null),
      timeRange: json['timeRange']?.toString() ?? (startTime != null && endTime != null ? '$startTime - $endTime' : null),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        'instructor': instructor,
        'location': location,
        'days': days,
        if (startTime != null) 'startTime': startTime,
        if (endTime != null) 'endTime': endTime,
      };
}
