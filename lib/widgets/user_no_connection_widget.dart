import 'package:flutter/cupertino.dart';

class UserNoConnectionWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onTryAgain;

  const UserNoConnectionWidget({
    super.key,
    required this.message,
    this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.wifi_slash,
            size: 64,
            color: CupertinoColors.systemOrange.resolveFrom(context),
          ),
          const SizedBox(height: 16),
          Text(
            'No Connection',
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ),
          const SizedBox(height: 24),
          CupertinoButton.filled(
            onPressed: onTryAgain,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
