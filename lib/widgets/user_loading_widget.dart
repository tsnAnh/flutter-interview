import 'package:flutter/cupertino.dart';

class UserLoadingWidget extends StatelessWidget {
  const UserLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CupertinoActivityIndicator(radius: 16));
  }
}
