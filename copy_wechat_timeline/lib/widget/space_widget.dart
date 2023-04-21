import 'package:flutter/material.dart';

class SpaceVerticalWidget extends StatelessWidget {
  final double? space;
  const SpaceVerticalWidget({Key? key, this.space = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: this.space);
  }
}

class SpaceHorizontalWidget extends StatelessWidget {
  final double? space;
  const SpaceHorizontalWidget({Key? key, this.space = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: this.space);
  }
}
