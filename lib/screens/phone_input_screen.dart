import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/class_model.dart';
import '../models/student_model.dart';

class PhoneInputScreen extends StatefulWidget {
  final ClassModel classModel;

  const PhoneInputScreen({
    super.key,
    required this.classModel,
  });

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
    _phoneController.dispose();
    super.dispose();
  }

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
      return;
    }

    setState(() {
      _isLoading = true;
    });

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
  }

  @override
  Widget build(BuildContext context) {
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

                // Class Name Header
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
                  child: Text(
                    widget.classModel.name,
                    style: const TextStyle(
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

                const SizedBox(height: 16),

                // Class Details Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(
                          icon: Icons.person,
                          label: 'Instructor',
                          value: widget.classModel.instructor,
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.access_time,
                          label: 'Time',
                          value: widget.classModel.time,
                        ),
                        const SizedBox(height: 16),
                        _DetailRow(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: widget.classModel.location,
                        ),
                      ],
                    ),
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
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF667eea),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your phone number will serve as your ID',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
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
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Check In',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
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
    );
  }
}

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
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

