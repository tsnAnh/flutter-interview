import 'package:flutter/cupertino.dart';

import '../models/users_response.dart';
import '../widgets/cached_network_image_widget.dart';
import '../widgets/user_item_widget.dart';

class UserCardWidget extends StatelessWidget {
  final UserData user;
  final VoidCallback? onTap;

  const UserCardWidget({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey
                  .resolveFrom(context)
                  .withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: UserItemWidget(
          leading: ClipOval(
            child: CachedNetworkImageWidget(
              imageUrl: user.avatar,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            '${user.firstName} ${user.lastName}',
            style: CupertinoTheme.of(
              context,
            ).textTheme.textStyle.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            user.email,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              fontSize: 14,
            ),
          ),
          trailing: const Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ),
    );
  }
}
