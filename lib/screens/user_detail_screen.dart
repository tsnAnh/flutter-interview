import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_management_app/models/users_response.dart';
import 'package:user_management_app/widgets/cached_network_image_widget.dart';

class UserDetailScreen extends StatelessWidget {
  final UserData user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('${user.firstName} ${user.lastName}'),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              _buildProfileImage(),
              const SizedBox(height: 24),
              _buildUserInfo(context),
              const SizedBox(height: 32),
              _buildContactSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImageWidget(
          imageUrl: user.avatar,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      children: [
        Text(
          '${user.firstName} ${user.lastName}',
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
              .copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'User ID: ${user.id}',
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Contact Information',
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          _buildContactItem(
            context,
            icon: CupertinoIcons.mail,
            title: 'Email',
            value: user.email,
          ),
          const Divider(
            height: 1,
            indent: 56,
            color: CupertinoColors.separator,
          ),
          _buildContactItem(
            context,
            icon: CupertinoIcons.person_badge_plus,
            title: 'First Name',
            value: user.firstName,
          ),
          const Divider(
            height: 1,
            indent: 56,
            color: CupertinoColors.separator,
          ),
          _buildContactItem(
            context,
            icon: CupertinoIcons.person_badge_minus,
            title: 'Last Name',
            value: user.lastName,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: CupertinoColors.systemBlue.resolveFrom(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CupertinoTheme.of(
                    context,
                  ).textTheme.textStyle.copyWith(
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: CupertinoTheme.of(
                    context,
                  ).textTheme.textStyle.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
