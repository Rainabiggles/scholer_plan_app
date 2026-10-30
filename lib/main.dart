import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override














































@override
Widget build(BuildContext context) {
return Scaffold(
// sign up screen
appBar: AppBar(
title: const Text('Welcome'),
backgroundColor: Colors.teal,
foregroundColor: Colors.white,
),
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [

// Section Title
const Text(
'Sign up for Scholarplan:',
style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
),

const SizedBox(height: 24),


const Text(
'ID +62 Phone number',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
),

const SizedBox(height: 16),


const Text(
'Continue with Email',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
),


const SizedBox(height: 16),

const Text(
'Continue with Google',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
),

const SizedBox(height: 40),
