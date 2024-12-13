import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_night_app/services/session_service.dart';
import 'package:movie_night_app/screens/movie_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the SharedPreferences package

class JoinSessionScreen extends StatefulWidget {
  const JoinSessionScreen({super.key});

  @override
  State<JoinSessionScreen> createState() => _JoinSessionScreenState();
}

class _JoinSessionScreenState extends State<JoinSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final SessionService _sessionService = SessionService();
  String _sessionCode = '';
  bool _isLoading = false;

  Future<void> _joinSession() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final deviceId = dotenv.env['DEVICE_ID'] ?? 'default_device_id';
      await _sessionService.joinSession(deviceId, _sessionCode);
      final sessionId = await _getSessionId();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MovieSelectionScreen(sessionId: sessionId),
        ),
      );
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id') ?? '';
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter Session Code',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a session code';
                        }
                        _sessionCode = value.trim();
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _joinSession();
                        }
                      },
                      child: const Text('Join Session'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
