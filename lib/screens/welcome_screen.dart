import 'package:flutter/material.dart';
import 'start_session_screen.dart';
import 'join_session_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Night')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShareCodeScreen()),
              ),
              child: const Text('Start Session'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JoinSessionScreen()),
              ),
              child: const Text('Join Session'),
            ),
          ],
        ),
      ),
    );
  }
}
