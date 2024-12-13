import 'package:flutter/material.dart';
import 'package:movie_night_app/services/session_service.dart';
import 'package:movie_night_app/screens/movie_selection_screen.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String? code;
  bool isLoading = true;
  final _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    try {
      String deviceId = "YOUR_DEVICE_ID"; 
      final sessionCode = await _sessionService.startSession(deviceId);

      setState(() {
        code = sessionCode;
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog("Error starting session: $e");
    }
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
        title: const Text('Share Code'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your Code:", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text(code ?? "Loading...", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieSelectionScreen(sessionId: code ?? ''),
                        ),
                      );
                    },
                    child: const Text('Proceed to Movie Selection'),
                  ),
                ],
              ),
      ),
    );
  }
}
