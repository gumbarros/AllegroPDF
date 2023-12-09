import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final orderByColumnProvider = StateProvider<String>((ref) => 'lastOpenedDate');
final orderByDirectionProvider = StateProvider<String>((ref) => "ASC");

class OrderByDialog extends ConsumerWidget {
  const OrderByDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final orderByColumn = ref.watch(orderByColumnProvider);
    final orderByDirection = ref.watch(orderByDirectionProvider);

    return AlertDialog(
      title: const Text('Order By'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('Title'),
            value: 'title',
            groupValue: orderByColumn,
            onChanged: (value) {
              ref.read(orderByColumnProvider.notifier).state = value!;
            },
          ),
          RadioListTile<String>(
            title: const Text('Last Opened Date'),
            value: 'lastOpenedDate',
            groupValue: orderByColumn,
            onChanged: (value) {
              ref.read(orderByColumnProvider.notifier).state = value!;
            },
          ),
          const Divider(),
          RadioListTile<String>(
            title: const Text('Ascending'),
            value: "ASC",
            groupValue: orderByDirection,
            onChanged: (value) {
              ref.read(orderByDirectionProvider.notifier).state = value!;
            },
          ),
          RadioListTile<String>(
            title: const Text('Descending'),
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
            child: const Text("Close"))
      ],
    );
  }
}
