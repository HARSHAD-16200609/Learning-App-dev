import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/friend.dart';

class ContactAvatar extends StatelessWidget {
  final Friend? friend;
  final Uint8List? photoBytes;
  final String? name;
  final String? avatarUrl;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  const ContactAvatar({
    super.key,
    this.friend,
    this.photoBytes,
    this.name,
    this.avatarUrl,
    this.size = 48,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = friend?.name ?? name ?? '?';
    final displayPhotoBytes = friend?.photoBytes ?? photoBytes;
    final displayAvatarUrl = friend?.avatarUrl ?? avatarUrl;
    final hasPhoto = displayPhotoBytes != null && displayPhotoBytes.isNotEmpty;
    final hasUrl = displayAvatarUrl != null && displayAvatarUrl.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        gradient: (!hasPhoto && !hasUrl)
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getGradientColors(displayName),
              )
            : null,
      ),
      child: ClipOval(
        child: _buildContent(isDark, displayName, displayPhotoBytes, displayAvatarUrl, hasPhoto, hasUrl),
      ),
    );
  }

  Widget _buildContent(bool isDark, String displayName, Uint8List? photoBytes, String? avatarUrl, bool hasPhoto, bool hasUrl) {
    if (hasPhoto) {
      return Image.memory(
        photoBytes!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, __, ___) => _buildInitials(displayName),
      );
    } else if (hasUrl) {
      return Image.network(
        avatarUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, __, ___) => _buildInitials(displayName),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildInitials(displayName);
        },
      );
    } else {
      return _buildInitials(displayName);
    }
  }

  Widget _buildInitials(String name) {
    final initials = _getInitials(name);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(name),
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  List<Color> _getGradientColors(String name) {
    final gradients = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
      [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      [const Color(0xFFFA709A), const Color(0xFFFEE140)],
      [const Color(0xFF30CEF2), const Color(0xFF575FCC)],
      [const Color(0xFFFC466B), const Color(0xFF3F5EFB)],
      [const Color(0xFF48C6EF), const Color(0xFF6F86D6)],
    ];

    final index = name.hashCode.abs() % gradients.length;
    return gradients[index];
  }
}
