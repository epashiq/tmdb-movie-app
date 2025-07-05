
import 'package:flutter/material.dart';

class MovieLoadingWidget extends StatelessWidget {
  final String message;
  
  const MovieLoadingWidget({
    super.key,
    this.message = 'Loading movies...',
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.orange,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
