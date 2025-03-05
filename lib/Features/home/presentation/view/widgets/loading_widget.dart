import 'package:flutter/material.dart';
import '../../../../../Core/resources/color_manager.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: ColorManager.blue),
    );
  }
}
