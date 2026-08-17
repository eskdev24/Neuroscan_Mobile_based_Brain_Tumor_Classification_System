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
  ScanItem? _selectedItem;
  ScanItem? _itemToDelete;
  bool _showClearAllDialog = false;

  void _onItemTap(ScanItem item) {
    setState(() => _selectedItem = item);
  }

  void _onItemSwipeDelete(ScanItem item) {
    setState(() => _itemToDelete = item);
  }

  void _confirmDelete() {
    if (_itemToDelete != null) {
      ref.read(historyControllerProvider.notifier).deleteItem(_itemToDelete!);
      setState(() {
        if (_selectedItem?.id == _itemToDelete?.id) _selectedItem = null;
        _itemToDelete = null;
      });
    }
  }

  void _cancelDelete() {
    setState(() => _itemToDelete = null);
  }

  void _confirmClearAll() {
    ref.read(historyControllerProvider.notifier).clearHistory();
    setState(() {
      _showClearAllDialog = false;
      _selectedItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final historyAsync = ref.watch(historyControllerProvider);

    return Column(
      children: [
        if (_showClearAllDialog)
          _buildClearAllDialog(cs),
        if (_itemToDelete != null)
          _buildDeleteItemDialog(cs),
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
                              onPressed: () => setState(() => _showClearAllDialog = true),
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
        if (_selectedItem != null)
          HistoryDetailDialog(
            item: _selectedItem!,
            onDismiss: () => setState(() => _selectedItem = null),
            onDelete: () {
              setState(() {
                _itemToDelete = _selectedItem;
                _selectedItem = null;
              });
            },
          ),
      ],
    );
  }

  Widget _buildClearAllDialog(ColorScheme cs) {
    return AlertDialog(
      title: const Text('Clear All History?'),
      content: const Text(
        'This will permanently delete all your scan history. This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => setState(() => _showClearAllDialog = false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _confirmClearAll,
          child: Text('Delete All', style: TextStyle(color: cs.error)),
        ),
      ],
    );
  }

  Widget _buildDeleteItemDialog(ColorScheme cs) {
    return AlertDialog(
      title: const Text('Delete Item?'),
      content: const Text(
        'Are you sure you want to delete this scan result? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: _cancelDelete,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _confirmDelete,
          child: Text('Delete', style: TextStyle(color: cs.error)),
        ),
      ],
    );
  }
}
