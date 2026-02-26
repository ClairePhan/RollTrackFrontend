import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person_model.dart';
import '../models/class_model.dart';

/// Base URL for the RollTrack API. Use 10.0.2.2:8080 for Android emulator.
const String _baseUrl = 'http://localhost:8080';

class ApiService {
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  ApiService._();

  String get baseUrl => _baseUrl;

  Future<List<PersonModel>> getStudentsByPhone(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('$_baseUrl/api/students').replace(
      queryParameters: {'phoneNumber': cleanPhone},
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to fetch students',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => PersonModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ClassModel>> getClasses() async {
    final uri = Uri.parse('$_baseUrl/api/classes');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to fetch classes',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => ClassModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> checkIn({
    required String? studentId,
    required String? classId,
    String? studentName,
    String? className,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/checkin');
    final body = <String, dynamic>{
      if (studentId != null && studentId.isNotEmpty) 'studentId': studentId,
      if (classId != null && classId.isNotEmpty) 'classId': classId,
      if (studentName != null && studentName.isNotEmpty) 'studentName': studentName,
      if (className != null && className.isNotEmpty) 'className': className,
    };
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 409) {
      throw ApiException('Already checked in today', statusCode: 409, body: response.body);
    }
    if (response.statusCode != 201) {
      throw ApiException(
        'Check-in failed',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  Future<void> undoCheckIn({
    required String? studentId,
    required String? classId,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/checkin/undo');
    final body = <String, dynamic>{
      if (studentId != null && studentId.isNotEmpty) 'studentId': studentId,
      if (classId != null && classId.isNotEmpty) 'classId': classId,
    };
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to undo check-in',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String body;

  ApiException(this.message, {required this.statusCode, required this.body});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}
