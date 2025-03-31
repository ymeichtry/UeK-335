import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello HTTP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HelloHttpPage(),
    );
  }
}

class HelloHttpPage extends StatefulWidget {
  const HelloHttpPage({super.key});

  @override
  State<HelloHttpPage> createState() => _HelloHttpPageState();
}

class _HelloHttpPageState extends State<HelloHttpPage> {
  bool _isLoading = false;
  String _response = '';

  Future<void> _sendHttpRequest() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://httpbin.org/post'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'deviceTime': DateTime.now().toIso8601String(),
          'deviceInfo': 'Flutter OS'
        }),
      );
      
      setState(() {
        _response = response.statusCode == 200
            ? 'JSON: ${jsonDecode(response.body)['json']}'
            : 'Error: ${response.statusCode}';
      });
    } catch (e) {
      setState(() => _response = 'Network error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello HTTP')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _sendHttpRequest,
              child: const Text('Hello HTTP Service'),
            ),
            if (_isLoading) const CircularProgressIndicator(),
            if (_response.isNotEmpty) Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_response),
            ),
          ],
        ),
      ),
    );
  }
}