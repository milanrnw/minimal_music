import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../providers/song_provider.dart';
import '../../providers/theme_provider.dart';
import 'folder_management_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const SettingsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Library",
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!songProvider.hasPermission)
            ListTile(
              title: const Text(
                "Storage Permission Needed",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Required to scan and play songs. Tap to open settings.",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 12,
                ),
              ),
              leading: const Icon(Icons.error_outline, color: Colors.redAccent),
              onTap: () {
                openAppSettings();
              },
            ),
          ListTile(
            title: const Text("Manage Library Folders", style: TextStyle()),
            subtitle: Text(
              "Show/hide specific folders",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).textTheme.bodySmall?.color,
              size: 16,
            ),
            onTap: () {
              Navigator.push(context, FolderManagementScreen.route());
            },
          ),
          SwitchListTile(
            title: const Text("Hide Short Audio", style: TextStyle()),
            subtitle: Text(
              "Exclude files shorter than 60 seconds (e.g. WhatsApp audio)",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
            value: songProvider.filterShortSongs,
            onChanged: (value) {
              songProvider.toggleFilterShortSongs();
            },
            activeColor: Colors.deepPurpleAccent,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Divider(color: Theme.of(context).dividerColor),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Appearance",
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text("System Default", style: TextStyle()),
                    subtitle: Text(
                      "Follow device theme",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                    value: ThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (mode) {
                      if (mode != null) themeProvider.setThemeMode(mode);
                    },
                    activeColor: Colors.deepPurpleAccent,
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text("Light", style: TextStyle()),
                    value: ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (mode) {
                      if (mode != null) themeProvider.setThemeMode(mode);
                    },
                    activeColor: Colors.deepPurpleAccent,
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text("Dark", style: TextStyle()),
                    value: ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (mode) {
                      if (mode != null) themeProvider.setThemeMode(mode);
                    },
                    activeColor: Colors.deepPurpleAccent,
                  ),
                ],
              );
            },
          ),
          Divider(color: Theme.of(context).dividerColor),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "About",
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text("Minimal Music Player", style: TextStyle()),
            subtitle: Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
