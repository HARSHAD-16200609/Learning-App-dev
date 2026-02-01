import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/group.dart';
import '../widgets/group_card.dart';
import '../widgets/contact_avatar.dart';
import '../models/friend.dart';
import 'contact_picker_screen.dart';
import 'group_detail_screen.dart';

class ActualGroupsScreen extends StatefulWidget {
  const ActualGroupsScreen({super.key});

  @override
  State<ActualGroupsScreen> createState() => _ActualGroupsScreenState();
}

class _ActualGroupsScreenState extends State<ActualGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.chevron_left_rounded,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            size: 32,
          ),
        ),
        title: Text(
          'Groups',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showCreateGroupDialog(context),
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
        ],
      ),
      body: expenseProvider.groups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    Icons.groups_rounded, 
                    size: 80, 
                    color: isDark ? Colors.grey[700] : Colors.grey[300]
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Create your first group',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Groups help you split bills with roommates, friends, or colleagues easily.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateGroupDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Group'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: expenseProvider.groups.length,
              itemBuilder: (context, index) {
                return GroupCard(
                  group: expenseProvider.groups[index],
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupDetailScreen(group: expenseProvider.groups[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    List<Friend> selectedMembers = [];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            title: Text(
              'New Group',
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E293B)),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Group Name',
                      hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[400]),
                      filled: true,
                      fillColor: isDark ? Colors.black26 : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Members',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (selectedMembers.isEmpty)
                    Text(
                      'No members added',
                      style: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[500], fontStyle: FontStyle.italic),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedMembers.map((friend) {
                        return Chip(
                          avatar: ContactAvatar(friend: friend, size: 24),
                          label: Text(friend.name),
                          backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                          labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black87),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                             setState(() {
                               selectedMembers.remove(friend);
                             });
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactPickerScreen(multiSelect: true),
                        ),
                      );
                      if (result != null && result is List<Friend>) {
                        setState(() {
                             // Merge lists unique by ID
                             for (var f in result) {
                               if (!selectedMembers.any((m) => m.id == f.id)) {
                                 selectedMembers.add(f);
                               }
                             }
                        });
                      }
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Members'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a group name')));
                     return;
                  }
                  
                  final memberIds = selectedMembers.map((e) => e.id).toList();
                  Provider.of<ExpenseProvider>(context, listen: false).createGroup(name, memberIds);
                  Navigator.pop(ctx);
                },
                child: const Text('Create'),
              ),
            ],
          );
        }
      ),
    );
  }
}
