import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => {Navigator.of(context).pop()},
        ),
         title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Removed custom "Settings" title since we added AppBar
              // const SizedBox(height: 32), 
              
              // Profile Section
              _buildSection(
                context,
                'Profile',
                [
                  _buildProfileItem(context, isDark),
                ],
                isDark,
              ),
            const SizedBox(height: 24),

            // Appearance Section
            _buildSection(
              context,
              'Appearance',
              [
                _buildSettingItem(
                  context,
                  Icons.dark_mode_rounded,
                  'Dark Mode',
                  isDark,
                  trailing: Switch.adaptive(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
              isDark,
            ),
            const SizedBox(height: 24),

            // Notifications Section
            _buildSection(
              context,
              'Notifications',
              [
                _buildSettingItem(
                  context,
                  Icons.notifications_rounded,
                  'Push Notifications',
                  isDark,
                  trailing: Switch.adaptive(
                    value: true,
                    onChanged: (value) {},
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                _buildSettingItem(
                  context,
                  Icons.email_rounded,
                  'Email Notifications',
                  isDark,
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
              isDark,
            ),
            const SizedBox(height: 24),

            // General Section
            _buildSection(
              context,
              'General',
              [
                  _buildSettingItem(
                  context,
                  Icons.attach_money_rounded,
                  'Currency',
                  isDark,
                  subtitle: 'INR (₹)',
                  onTap: () {},
                ),
                _buildSettingItem(
                  context,
                  Icons.language_rounded,
                  'Language',
                  isDark,
                  subtitle: 'English',
                  onTap: () {},
                ),
                _buildSettingItem(
                  context,
                  Icons.security_rounded,
                  'Privacy & Security',
                  isDark,
                  onTap: () {},
                ),
              ],
              isDark,
            ),
            const SizedBox(height: 24),

            // Support Section
            _buildSection(
              context,
              'Support',
              [
                _buildSettingItem(
                  context,
                  Icons.help_rounded,
                  'Help Center',
                  isDark,
                  onTap: () {},
                ),
                _buildSettingItem(
                  context,
                  Icons.info_rounded,
                  'About',
                  isDark,
                  subtitle: 'Version 1.0.0',
                  onTap: () {},
                ),
              ],
              isDark,
            ),
            const SizedBox(height: 32),

            // Logout Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEF4444),
                  width: 2,
                ),
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    ));
  }

  Widget _buildSection(BuildContext context, String title,
      List<Widget> children, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
            border: isDark
                ? null
                : Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildProfileItem(BuildContext context, bool isDark) {
    final provider = Provider.of<ExpenseProvider>(context);

    // Helper to determine image provider
    ImageProvider getImageProvider() {
      if (provider.userAvatar.startsWith('http')) {
        return NetworkImage(provider.userAvatar);
      } else {
        return FileImage(File(provider.userAvatar));
      }
    }

    return InkWell(
      onTap: () => _editProfileDialog(context, provider),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
                image: DecorationImage(
                  image: getImageProvider(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.userName,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to edit username',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.edit_rounded,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _editProfileDialog(BuildContext context, ExpenseProvider provider) {
    final nameController = TextEditingController(text: provider.userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                provider.updateUserProfile(newName, null);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    bool isDark, {
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                ),
          ],
        ),
      ),
    );
  }
}
