import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_list_bloc.dart';

class UserEmptyStateWidget extends StatelessWidget {
  final VoidCallback? onClearSearch;
  final VoidCallback? onRefresh;

  const UserEmptyStateWidget({super.key, this.onClearSearch, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserListBloc, UserListState>(
      builder: (context, state) {
        // Determine the appropriate message and icon based on context
        String title;
        String subtitle;
        IconData icon;
        Color iconColor;
        List<Widget> actionButtons = [];

        if (state.isSearching &&
            state.searchQuery != null &&
            state.searchQuery!.isNotEmpty) {
          // Search-specific empty state
          title = 'No Results Found';
          subtitle =
              'No users found matching "${state.searchQuery}".\nTry adjusting your search criteria or check the spelling.';
          icon = CupertinoIcons.search;
          iconColor = CupertinoColors.systemBlue.resolveFrom(context);

          // Add action button to clear search
          actionButtons.add(
            CupertinoButton(
              onPressed: onClearSearch,
              child: const Text('Clear Search'),
            ),
          );
        } else {
          // General empty state
          title = 'No Users Available';
          subtitle =
              'No users are available at the moment.\nPlease check back later or try refreshing.';
          icon = CupertinoIcons.person_3;
          iconColor = CupertinoColors.systemGrey.resolveFrom(context);

          // Add action button to refresh
          actionButtons.add(
            CupertinoButton.filled(
              onPressed: onRefresh,
              child: const Text('Refresh'),
            ),
          );
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with subtle animation-ready container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 48, color: iconColor),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  title,
                  style: CupertinoTheme.of(
                    context,
                  ).textTheme.navLargeTitleTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subtitle with custom message or from state
                Text(
                  state.errorMessage?.isNotEmpty == true
                      ? state.errorMessage!
                      : subtitle,
                  style: CupertinoTheme.of(
                    context,
                  ).textTheme.textStyle.copyWith(
                    fontSize: 16,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Action buttons
                if (actionButtons.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  ...actionButtons,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
