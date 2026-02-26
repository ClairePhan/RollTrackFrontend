import 'dart:async';
import 'package:flutter/material.dart';
import '../models/person_model.dart';
import '../models/class_model.dart';
import '../services/api_service.dart';
import 'gamification_screen.dart';

class PeopleAndClassesScreen extends StatefulWidget {
  final String phoneNumber;
  final List<PersonModel> people;

  const PeopleAndClassesScreen({
    super.key,
    required this.phoneNumber,
    required this.people,
  });

  @override
  State<PeopleAndClassesScreen> createState() => _PeopleAndClassesScreenState();
}

class _PeopleAndClassesScreenState extends State<PeopleAndClassesScreen> {
  final Map<String, List<PersonModel>> checkedInPeople = {};
  List<ClassModel> _todaysClasses = [];
  bool _classesLoading = true;
  String? _classesError;
  final _api = ApiService();
  Timer? _inactivityTimer;

  bool get _isSinglePerson => widget.people.length == 1;

  static const List<String> _weekdayNames = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];
  static const List<String> _weekdayNamesLong = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _loadClasses();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _classesLoading = true;
      _classesError = null;
    });
    try {
      final allClasses = await _api.getClasses();
      if (!mounted) return;
      final now = DateTime.now();
      final todayIndex = now.weekday - 1; // Monday = 0
      final todayShort = _weekdayNames[todayIndex];
      final todayLong = _weekdayNamesLong[todayIndex];
      final filtered = allClasses.where((c) {
        for (final d in c.days) {
          final normalized = d.toString().toLowerCase();
          if (normalized == todayShort.toLowerCase() ||
              normalized == todayLong.toLowerCase() ||
              normalized.startsWith(todayShort.toLowerCase().substring(0, 2))) {
            return true;
          }
        }
        return false;
      }).toList();
      setState(() {
        _todaysClasses = filtered;
        _classesLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _classesError = 'Could not load classes';
        _classesLoading = false;
      });
    }
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 20), () {
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  String _classKey(ClassModel c) => c.id ?? c.displayName;

  Future<void> _handleDrop(PersonModel person, ClassModel classItem) async {
    final key = _classKey(classItem);
    if (checkedInPeople[key]?.contains(person) ?? false) return;

    try {
      await _api.checkIn(
        studentId: person.id,
        classId: classItem.id,
        studentName: person.name,
        className: classItem.displayName,
      );
      if (!mounted) return;
      final attendedCount = (person.classesAttended ?? 0) + 1;
      setState(() {
        checkedInPeople[key] ??= [];
        checkedInPeople[key]!.add(person);
      });
      if (!_isSinglePerson) {
        _showCongratsPopup(person, attendedCount);
      }
      if (_isSinglePerson) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const GamificationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      final isDuplicate = e is ApiException && e.statusCode == 409;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isDuplicate
                ? '${person.name} already checked into ${classItem.displayName} today.'
                : e.toString().replaceFirst('ApiException: ', ''),
          ),
          backgroundColor: isDuplicate ? Colors.orange : Colors.red,
        ),
      );
    }
  }

  void _showCongratsPopup(PersonModel person, int attendedCount) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (dialogContext) {
        // Auto-close after 4 seconds
        Future.delayed(const Duration(seconds: 4), () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Color(0xFFFFC107),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Congrats!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have attended $attendedCount ${attendedCount == 1 ? 'class' : 'classes'}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (_) => _resetInactivityTimer(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
              ],
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildPeoplePanel()),
                Expanded(flex: 3, child: _buildClassesPanel()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeoplePanel() {
    return Container(
      color: Colors.white.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              iconSize: 32,
            ),
          ),

          const SizedBox(height: 16),

          // People Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'People',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                decoration: TextDecoration.none,
                decorationThickness: 3,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // People List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView.builder(
                itemCount: widget.people.length,
                itemBuilder: (context, index) {
                  final person = widget.people[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Draggable<PersonModel>(
                      data: person,
                      feedback: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667eea),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            person.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667eea),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            person.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GamificationScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667eea),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          person.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesPanel() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Today's Classes Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Todays classes',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                decoration: TextDecoration.none,
                decorationThickness: 3,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Classes List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _classesLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                      ),
                    )
                  : _classesError != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _classesError!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _loadClasses,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _todaysClasses.isEmpty
                          ? const Center(
                              child: Text(
                                'No classes scheduled for today',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _todaysClasses.length,
                              itemBuilder: (context, index) {
                                final classItem = _todaysClasses[index];
                                return _buildClassCard(classItem, index);
                              },
                            ),
            ),
          ),
          if (!_isSinglePerson)
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: const Color(0xFF667eea),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Finish',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClassCard(ClassModel classItem, int index) {
    final classKey = _classKey(classItem);
    final checkedIn = checkedInPeople[classKey] ?? [];

    return DragTarget<PersonModel>(
      onAcceptWithDetails: (DragTargetDetails<PersonModel> details) {
        _handleDrop(details.data, classItem);
      },
      builder: (context, candidateData, rejectedData) {
        final isDraggingOver = candidateData.isNotEmpty;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDraggingOver
                ? Colors.green.shade50
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDraggingOver
                  ? Colors.green
                  : Colors.blue.shade200,
              width: isDraggingOver ? 3 : 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Class Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Class Name
                          Text(
                            classItem.displayName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Schedule
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                classItem.scheduleDisplay,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Time
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                classItem.timeRangeDisplay,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Instructor
                          Row(
                            children: [
                              const Icon(Icons.person, size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Instructor: ${classItem.instructor}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Class Image Placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF667eea).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getClassIcon(classItem.displayName),
                            size: 48,
                            color: const Color(0xFF667eea),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            classItem.displayName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF667eea),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Checked-in people list
                if (checkedIn.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Checked In:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: checkedIn.map((person) {
                      return Chip(
                        label: Text(
                          person.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: const Color(0xFF667eea).withValues(alpha: 0.2),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () async {
                          // Undo: remove attendance doc, decrement classesAttended, then update UI
                          try {
                            await _api.undoCheckIn(
                              studentId: person.id,
                              classId: classItem.id,
                            );
                            if (!mounted) return;
                            setState(() {
                              checkedInPeople[classKey]!.remove(person);
                              if (checkedInPeople[classKey]!.isEmpty) {
                                checkedInPeople.remove(classKey);
                              }
                            });
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString().replaceFirst('ApiException: ', ''),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
                if (isDraggingOver) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_circle, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Drop here to check in',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getClassIcon(String className) {
    switch (className.toLowerCase()) {
      case 'judo':
        return Icons.sports_martial_arts;
      case 'kickboxing':
        return Icons.sports_mma;
      case 'karate':
        return Icons.sports_kabaddi;
      case 'brazilian jiu-jitsu':
      case 'jiu-jitsu':
        return Icons.sports_handball;
      default:
        return Icons.fitness_center;
    }
  }
}

