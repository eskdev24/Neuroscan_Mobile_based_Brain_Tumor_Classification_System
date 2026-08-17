import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/scan_item.dart';
import '../application/history_controller.dart';
import 'history_item_card.dart';
import 'history_detail_dialog.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  void _onItemTap(ScanItem item) {
    showDialog(
      context: context,
      builder: (_) => HistoryDetailDialog(
        item: item,
        onDismiss: () => Navigator.of(context).pop(),
        onDelete: () {
          Navigator.of(context).pop();
          ref.read(historyControllerProvider.notifier).deleteItem(item);
        },
      ),
    );
  }

  void _onItemSwipeDelete(ScanItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text(
          'Are you sure you want to delete this scan result? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(historyControllerProvider.notifier).deleteItem(item);
            },
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    ref.read(historyControllerProvider.notifier).clearHistory();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final historyAsync = ref.watch(historyControllerProvider);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Review past predictions.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    historyAsync.when(
                      data: (history) => history.isNotEmpty
                          ? TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Clear All History?'),
                                    content: const Text(
                                      'This will permanently delete all your scan history. This action cannot be undone.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          _confirmClearAll();
                                        },
                                        child: Text('Delete All', style: TextStyle(color: cs.error)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text('Clear All', style: TextStyle(color: cs.error)),
                            )
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
                Expanded(
                  child: historyAsync.when(
                    data: (history) {
                      if (history.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history, size: 64, color: cs.outlineVariant),
                              const SizedBox(height: 16),
                              Text(
                                'No history available.',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Dismissible(
                              key: ValueKey(item.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (_) async {
                                _onItemSwipeDelete(item);
                                return false;
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: cs.errorContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.delete, color: cs.onErrorContainer),
                              ),
                              child: HistoryItemCard(
                                item: item,
                                onClick: () => _onItemTap(item),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
