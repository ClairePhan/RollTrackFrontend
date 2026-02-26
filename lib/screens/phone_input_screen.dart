import 'dart:async';
import 'package:flutter/material.dart';
import '../models/class_model.dart';
<<<<<<< HEAD
import '../models/student_model.dart';
=======
import '../services/api_service.dart';
import 'people_and_classes_screen.dart';
>>>>>>> 5798e9a4e0e7ce4a3a2536e3249a62e9aff1050a

class PhoneInputScreen extends StatefulWidget {
  final ClassModel? classModel;

  const PhoneInputScreen({
    super.key,
    this.classModel,
  });

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  final _api = ApiService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Timer? _inactivityTimer;

  // Temporary static student data. In a real app this would come from an API.
  final List<StudentModel> _allStudents = [
    StudentModel(
      name: 'Alex Kim',
      phoneNumber: '1234567890',
      classesAttended: 12,
      belt: 'White',
    ),
    StudentModel(
      name: 'Jordan Lee',
      phoneNumber: '1234567890',
      classesAttended: 25,
      belt: 'Blue',
    ),
    StudentModel(
      name: 'Taylor Smith',
      phoneNumber: '5551234567',
      classesAttended: 5,
      belt: 'White',
    ),
  ];

  List<StudentModel> _matchingStudents = [];
  StudentModel? _selectedStudent;
  bool _hasSearched = false;

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  void _handleSearch() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final input = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    setState(() {
      _hasSearched = true;
      _selectedStudent = null;
      _matchingStudents = _allStudents
          .where((s) => s.phoneNumber.replaceAll(RegExp(r'[^0-9]'), '') == input)
          .toList();
    });
  }

  void _handleSubmit() {
    if (_selectedStudent == null) {
=======
  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();
    _phoneController.addListener(_resetInactivityTimer);
  }

  Future<void> _handleSubmit() async {
    _resetInactivityTimer();
    final enteredPhone = _phoneController.text.trim();

    if (enteredPhone.isEmpty) {
      _showCenteredErrorDialog('Please enter a phone number');
      return;
    }
    if (enteredPhone.length < 10) {
      _showCenteredErrorDialog('Phone number is too short');
>>>>>>> 5798e9a4e0e7ce4a3a2536e3249a62e9aff1050a
      return;
    }

    setState(() {
      _isLoading = true;
    });

<<<<<<< HEAD
    // Simulate API call or processing
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Checked in ${_selectedStudent!.name} to ${widget.classModel.name}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate back to classes screen after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    });
=======
    try {
      final matchingPeople = await _api.getStudentsByPhone(enteredPhone);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (matchingPeople.isNotEmpty) {
        // Stop the inactivity timer once we move to the next screen
        _inactivityTimer?.cancel();
        _inactivityTimer = null;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PeopleAndClassesScreen(
              phoneNumber: enteredPhone,
              people: matchingPeople,
            ),
          ),
        );
      } else {
        _showCenteredErrorDialog(
          'Phone number not found. Please check your number and try again.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showCenteredErrorDialog(
        'Could not load students. Please check your connection and try again.',
      );
    }
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }


  Future<void> _showCenteredErrorDialog(String message) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE53935),
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
>>>>>>> 5798e9a4e0e7ce4a3a2536e3249a62e9aff1050a
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      iconSize: 32,
                    ),
                  ),

                const SizedBox(height: 32),

                // Title Header
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: const Text(
                    'Check In',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 48),

                // Phone Number Input + Student selection Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Your Phone Number',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF667eea),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your phone number will serve as your ID',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
<<<<<<< HEAD
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(15),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    hintText: '(123) 456-7890',
                                    prefixIcon: const Icon(Icons.phone),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    if (value.length < 10) {
                                      return 'Phone number must be at least 10 digits';
                                    }
                                    return null;
                                  },
                                  autofocus: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _handleSearch,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF667eea),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: const Text(
                                  'Search',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Student selection grid (inside the card)
                          if (_hasSearched)
                            _matchingStudents.isEmpty
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'No students found for that phone number.',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Select Your Profile',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF667eea),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 220,
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          childAspectRatio: 0.9,
                                        ),
                                        itemCount: _matchingStudents.length,
                                        itemBuilder: (context, index) {
                                          final student =
                                              _matchingStudents[index];
                                          final isSelected =
                                              _selectedStudent == student;
                                          return Center(
                                            child: SizedBox(
                                              width: 160,
                                              height: 180,
                                              child: _StudentCard(
                                                student: student,
                                                isSelected: isSelected,
                                                onTap: () {
                                                  setState(() {
                                                    _selectedStudent = student;
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (_isLoading || _selectedStudent == null)
                                  ? null
                                  : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF667eea),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: _isLoading
=======
                          
                          // Phone Number Display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: Color(0xFF667eea),
                                  size: 28,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _phoneController.text.isEmpty
                                        ? 'Enter your phone number'
                                        : _phoneController.text,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: _phoneController.text.isEmpty
                                          ? Colors.grey[400]
                                          : Colors.black87,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                if (_phoneController.text.isNotEmpty)
                                  IconButton(
                                    onPressed: () {
                                      _resetInactivityTimer();
                                      setState(() {
                                        _phoneController.clear();
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.grey,
                                      size: 28,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Search Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _handleSubmit,
                              icon: _isLoading
>>>>>>> 5798e9a4e0e7ce4a3a2536e3249a62e9aff1050a
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.search, size: 28),
                              label: Text(
                                _isLoading ? 'Searching...' : 'Search',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 32,
                                ),
                                backgroundColor: const Color(0xFF667eea),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Custom Number Pad
                          _buildNumberPad(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

<<<<<<< HEAD
class _StudentCard extends StatelessWidget {
  final StudentModel student;
  final bool isSelected;
  final VoidCallback onTap;

  const _StudentCard({
    required this.student,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF22C55E) : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFE0E0E0),
                  child: Icon(
                    Icons.person,
                    size: 28,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  student.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF667eea), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
=======
  Widget _buildNumberPad() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Number buttons 1-9
          for (int row = 0; row < 3; row++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int col = 0; col < 3; col++)
                    _buildNumberButton(
                      number: (row * 3 + col + 1).toString(),
                    ),
                ],
>>>>>>> 5798e9a4e0e7ce4a3a2536e3249a62e9aff1050a
              ),
            ),
          // Bottom row: 0, backspace
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 120, height: 120),
                _buildNumberButton(number: '0'),
                _buildBackspaceButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton({required String number}) {
    return SizedBox(
      width: 120,
      height: 120,
      child: ElevatedButton(
        onPressed: () {
          _resetInactivityTimer();
          if (_phoneController.text.length < 15) {
            setState(() {
              _phoneController.text += number;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF667eea),
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.grey[300]!,
              width: 2,
            ),
          ),
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return SizedBox(
      width: 120,
      height: 120,
      child: ElevatedButton(
        onPressed: () {
          _resetInactivityTimer();
          if (_phoneController.text.isNotEmpty) {
            setState(() {
              _phoneController.text = _phoneController.text
                  .substring(0, _phoneController.text.length - 1);
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF667eea),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Icon(
          Icons.backspace,
          size: 40,
        ),
      ),
    );
  }
}

