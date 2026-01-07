import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 1. Corrected relative path to localization
import '../../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // Pre-fill the controller with the current user's name
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- PROFILE SECTION ---
          _buildSectionHeader("Profile"),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // 2. Updated to call updateProfile instead of updateDisplayName
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                        await authProvider.updateProfile(_nameController.text);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Profile Updated Successfully!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Update Name", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // --- LANGUAGE SECTION ---
          // 3. This key must exist in your .arb files
          _buildSectionHeader(loc.changeLanguage),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: Text(Localizations.localeOf(context).languageCode == 'en' ? "English" : "Français"),
              trailing: const Icon(Icons.swap_horiz),
              onTap: () => _showLanguagePicker(context),
            ),
          ),

          const SizedBox(height: 24),

          // --- APPEARANCE SECTION ---
          _buildSectionHeader("Appearance"),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode, color: Colors.purple),
              title: const Text("Dark Mode"),
              value: themeProvider.isDarkMode,
              onChanged: (val) => themeProvider.toggleTheme(),
            ),
          ),

          const SizedBox(height: 32),

          // --- LOGOUT ---
          ElevatedButton(
            onPressed: () => authProvider.signOut(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)),
                title: const Text("English"),
                onTap: () {
                  context.read<LocaleProvider>().setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text("🇫🇷", style: TextStyle(fontSize: 24)),
                title: const Text("Français"),
                onTap: () {
                  context.read<LocaleProvider>().setLocale(const Locale('fr'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}