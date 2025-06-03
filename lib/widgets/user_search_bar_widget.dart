import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_list_bloc.dart';

class UserSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;

  const UserSearchBarWidget({
    super.key,
    required this.controller,
    this.onClear,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.transparent,
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 0.5,
          ),
        ),
      ),
      child: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          return CupertinoSearchTextField(
            controller: controller,
            placeholder: 'Search users...',
            onChanged: onChanged,
            onSuffixTap: () {
              controller.clear();
              onClear?.call();
            },
          );
        },
      ),
    );
  }
}
