import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  const LoadingWidget({
    this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 40,
        height: size ?? 40,
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
