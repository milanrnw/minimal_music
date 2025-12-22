import 'package:flutter/material.dart';

class BulkActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onDelete;
  final VoidCallback onSelectAll;
  final VoidCallback onCancel;

  const BulkActionBar({
    Key? key,
    required this.selectedCount,
    required this.onAddToPlaylist,
    required this.onDelete,
    required this.onSelectAll,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
              onPressed: onCancel,
              tooltip: 'Cancel',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$selectedCount selected',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: onSelectAll,
              icon: Icon(
                Icons.select_all,
                color: Theme.of(context).iconTheme.color,
              ),
              tooltip: 'Select All',
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              onSelected: (value) {
                if (value == 'playlist') {
                  onAddToPlaylist();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'playlist',
                  child: Row(
                    children: [
                      Icon(Icons.playlist_add, color: Colors.deepPurpleAccent),
                      SizedBox(width: 12),
                      Text('Add to Playlist'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.redAccent),
                      SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
