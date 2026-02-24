import 'package:flutter/material.dart';
import '../models/person_model.dart';
import '../models/class_model.dart';
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
  // Track which people are checked into which classes
  final Map<String, List<PersonModel>> checkedInPeople = {};
  bool get _isSinglePerson => widget.people.length == 1;

  // Get today's classes based on current day
  List<ClassModel> getTodaysClasses() {
    // Sample classes data - in production this would come from an API
    final allClasses = [
      ClassModel(
        name: 'Judo',
        instructor: 'Sung Jin Woo',
        time: 'M/W/F',
        location: 'Dojo A',
        schedule: 'M/W/F',
        timeRange: '8:00 PM - 9:00',
      ),
      ClassModel(
        name: 'Kickboxing',
        instructor: 'Mike Tyson',
        time: 'M/W/F',
        location: 'Dojo B',
        schedule: 'M/W/F',
        timeRange: '8:00 PM - 9:00',
      ),
      ClassModel(
        name: 'Karate',
        instructor: 'Sensei Martinez',
        time: 'Mon/Wed',
        location: 'Dojo A',
        schedule: 'M/W',
        timeRange: '6:00 PM - 7:00',
      ),
      ClassModel(
        name: 'Brazilian Jiu-Jitsu',
        instructor: 'Professor Silva',
        time: 'Tue/Thu',
        location: 'Dojo B',
        schedule: 'T/Th',
        timeRange: '7:00 PM - 8:00',
      ),
    ];

    // Dummy data: always show all classes
    return allClasses;
  }

  void _handleDrop(PersonModel person, ClassModel classItem) {
    setState(() {
      final className = classItem.name;
      if (!checkedInPeople.containsKey(className)) {
        checkedInPeople[className] = [];
      }
      // Only add if not already checked in
      if (!checkedInPeople[className]!.contains(person)) {
        checkedInPeople[className]!.add(person);
      }
    });
    if (_isSinglePerson) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const GamificationScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todaysClasses = getTodaysClasses();

    return Scaffold(
      body: Container(
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
              Expanded(flex: 3, child: _buildClassesPanel(todaysClasses)),
            ],
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
              'Family',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                decoration: TextDecoration.none,
                decorationThickness: 3,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Instruction below People title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Drag the names into the classes to check in!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),

          const SizedBox(height: 24),

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

  Widget _buildClassesPanel(List<ClassModel> todaysClasses) {
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
              child: todaysClasses.isEmpty
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
                      itemCount: todaysClasses.length,
                      itemBuilder: (context, index) {
                        final classItem = todaysClasses[index];
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
                      final totalCheckedIn = checkedInPeople.values
                          .fold<int>(0, (sum, list) => sum + list.length);

                      if (totalCheckedIn > 0) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GamificationScreen(),
                          ),
                          (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
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
    final className = classItem.name;
    final checkedIn = checkedInPeople[className] ?? [];

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
                            classItem.name,
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
                                classItem.schedule ?? classItem.time,
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
                                classItem.timeRange ?? classItem.time,
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
                            _getClassIcon(classItem.name),
                            size: 48,
                            color: const Color(0xFF667eea),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            classItem.name.toUpperCase(),
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
                        onDeleted: () {
                          setState(() {
                            checkedInPeople[className]!.remove(person);
                            if (checkedInPeople[className]!.isEmpty) {
                              checkedInPeople.remove(className);
                            }
                          });
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

