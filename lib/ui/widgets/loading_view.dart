import 'package:flutter/material.dart';

import 'app_colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Memuat data gempa dari BMKG...',
            style: TextStyle(color: AppColors.teksRedup),
          ),
        ],
      ),
    );
  }
}
