import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/playlist_provider.dart';

class BulkAddToPlaylistDialog extends StatefulWidget {
  final List<String> songPaths;

  const BulkAddToPlaylistDialog({Key? key, required this.songPaths})
    : super(key: key);

  @override
  State<BulkAddToPlaylistDialog> createState() =>
      _BulkAddToPlaylistDialogState();
}

class _BulkAddToPlaylistDialogState extends State<BulkAddToPlaylistDialog> {
  void _showCreatePlaylistDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Create Playlist', style: TextStyle()),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(),
          decoration: InputDecoration(
            hintText: 'Playlist name',
            hintStyle: TextStyle(
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withOpacity(0.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final playlistProvider = Provider.of<PlaylistProvider>(
                  context,
                  listen: false,
                );
                await playlistProvider.createPlaylist(controller.text.trim());

                final newPlaylist = playlistProvider.playlists.last;

                for (final songPath in widget.songPaths) {
                  await playlistProvider.addSongToPlaylist(
                    newPlaylist.id,
                    songPath,
                  );
                }

                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added ${widget.songPaths.length} songs to "${newPlaylist.name}"',
                      ),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Create & Add',
              style: TextStyle(color: Colors.deepPurpleAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);
    final playlists = playlistProvider.playlists;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Add ${widget.songPaths.length} Songs to Playlist',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 24,
              ),
            ),
            title: Text(
              'Create New Playlist',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _showCreatePlaylistDialog(context);
            },
          ),
          Divider(color: Theme.of(context).dividerColor, height: 1),
          if (playlists.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'No playlists yet.\\nCreate one to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];

                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.playlist_play_rounded,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 24,
                      ),
                    ),
                    title: Text(playlist.name, style: TextStyle()),
                    onTap: () async {
                      for (final songPath in widget.songPaths) {
                        await playlistProvider.addSongToPlaylist(
                          playlist.id,
                          songPath,
                        );
                      }

                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added ${widget.songPaths.length} songs to "${playlist.name}"',
                            ),
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
