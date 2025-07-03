import 'package:flutter/material.dart';

class MovieLoadingWidget extends StatelessWidget {
  const MovieLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.orange,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading movies...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
