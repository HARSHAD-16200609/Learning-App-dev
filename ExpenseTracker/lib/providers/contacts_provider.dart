import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/friend.dart';

class ContactsProvider extends ChangeNotifier {
  List<Contact> _deviceContacts = [];
  List<Friend> _contactsAsFriends = [];
  bool _isLoading = false;
  bool _hasPermission = false;
  String? _error;

  List<Contact> get deviceContacts => _deviceContacts;
  List<Friend> get contactsAsFriends => _contactsAsFriends;
  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;
  String? get error => _error;

  // Request permission and fetch contacts
  Future<void> fetchContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check and request permission
      final status = await Permission.contacts.request();
      _hasPermission = status.isGranted;

      if (!_hasPermission) {
        _error = 'Contacts permission denied';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch contacts with photos
      _deviceContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
        withThumbnail: true,
      );

      // Convert to Friend model
      _contactsAsFriends = _deviceContacts.asMap().entries.map((entry) {
        final index = entry.key;
        final contact = entry.value;
        return Friend(
          id: contact.id,
          name: contact.displayName.isNotEmpty 
              ? contact.displayName 
              : 'Unknown',
          avatarUrl: '', // Will use photo bytes instead
          balance: 0.0, // Default balance
          photoBytes: contact.thumbnail ?? contact.photo,
          phoneNumber: contact.phones.isNotEmpty 
              ? contact.phones.first.number 
              : null,
          email: contact.emails.isNotEmpty 
              ? contact.emails.first.address 
              : null,
        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch contacts: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search contacts
  List<Friend> searchContacts(String query) {
    if (query.isEmpty) return _contactsAsFriends;
    
    return _contactsAsFriends.where((friend) {
      return friend.name.toLowerCase().contains(query.toLowerCase()) ||
          (friend.phoneNumber?.contains(query) ?? false);
    }).toList();
  }

  // Get contact by ID
  Friend? getContactById(String id) {
    try {
      return _contactsAsFriends.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }
}
