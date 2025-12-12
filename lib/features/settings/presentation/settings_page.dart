import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/config/theme/theme.dart';
import 'package:pokedex_app/config/theme/theme_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),

        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de Tema
              _buildSectionHeader(
                icon: Icons.palette_outlined,
                title: 'Settings',
                theme: theme,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildThemeOption(
                        context: context,
                        title: 'System',
                        subtitle: 'Use device settings',
                        value: ThemeMode.system,
                        groupValue: themeMode.toThemeMode,
                        icon: Icons.phone_iphone_outlined,
                        onChanged: () => ref
                            .read(themeControllerProvider.notifier)
                            .setTheme(AppThemeMode.system),
                      ),
                      const Divider(height: 1, indent: 16),
                      _buildThemeOption(
                        context: context,
                        title: 'Light',
                        subtitle: 'Light theme',
                        value: ThemeMode.light,
                        groupValue: themeMode.toThemeMode,
                        icon: Icons.light_mode_outlined,
                        onChanged: () => ref
                            .read(themeControllerProvider.notifier)
                            .setTheme(AppThemeMode.light),
                      ),
                      const Divider(height: 1, indent: 16),
                      _buildThemeOption(
                        context: context,
                        title: 'Dark',
                        subtitle: 'Dark theme',
                        value: ThemeMode.dark,
                        groupValue: themeMode.toThemeMode,
                        icon: Icons.dark_mode_outlined,
                        onChanged: () => ref
                            .read(themeControllerProvider.notifier)
                            .setTheme(AppThemeMode.dark),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required ThemeMode value,
    required ThemeMode groupValue,
    required IconData icon,
    required VoidCallback onChanged,
  }) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Radio<ThemeMode>(
        value: value,
        groupValue: groupValue,
        onChanged: (_) => onChanged(),
        activeColor: theme.colorScheme.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onChanged,
    );
  }
}
