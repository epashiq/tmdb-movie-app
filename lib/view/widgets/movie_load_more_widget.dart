import 'package:flutter/material.dart';

class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
          strokeWidth: 2,
        ),
      ),
    );
  }
}