import 'package:flutter/material.dart';
import '../models/class_model.dart';


class StudentPopup extends StatelessWidget {
  const StudentPopup({super.key});

  @override 
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Student'),
      content: Text('Student'),
    );
  }
}