import 'package:allegro_pdf/l10n/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final orderByColumnProvider = StateProvider<String>((ref) => 'lastOpenedDate');
final orderByDirectionProvider = StateProvider<String>((ref) => "DESC");

class OrderByDialog extends ConsumerWidget {
  const OrderByDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final orderByColumn = ref.watch(orderByColumnProvider);
    final orderByDirection = ref.watch(orderByDirectionProvider);

    return AlertDialog(
      title: Text(context.localization.sortBy),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: Text(context.localization.title),
            value: 'title',
            groupValue: orderByColumn,
            onChanged: (value) {
              ref.read(orderByColumnProvider.notifier).state = value!;
            },
          ),
          RadioListTile<String>(
            title: Text(context.localization.lastOpenedDate),
            value: 'lastOpenedDate',
            groupValue: orderByColumn,
            onChanged: (value) {
              ref.read(orderByColumnProvider.notifier).state = value!;
            },
          ),
          const Divider(),
          RadioListTile<String>(
            title: Text(context.localization.ascending),
            value: "ASC",
            groupValue: orderByDirection,
            onChanged: (value) {
              ref.read(orderByDirectionProvider.notifier).state = value!;
            },
          ),
          RadioListTile<String>(
            title: Text(context.localization.descending),
            value: "DESC",
            groupValue: orderByDirection,
            onChanged: (value) {
              ref.read(orderByDirectionProvider.notifier).state = value!;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(context.localization.close))
      ],
    );
  }
}
