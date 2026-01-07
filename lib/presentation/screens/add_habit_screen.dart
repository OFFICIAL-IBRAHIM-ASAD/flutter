import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _titleController = TextEditingController();

  String _selectedCategory = "Health";
  bool _isReminderOn = true;

  final List<String> _categories = [
    "Health",
    "Workout",
    "Reading",
    "Meditate",
    "Productivity",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // --- REFINED INSTANT SAVE LOGIC ---
  void _saveHabit() {
    if (_titleController.text.isEmpty) return;

    final user = context.read<AuthProvider>().user;
    if (user != null) {
      // 1. Trigger the optimistic background save
      context.read<HabitProvider>().addHabit(
        _titleController.text.trim(),
        _selectedCategory,
        _isReminderOn,
        user.uid,
      );

      // 2. Pop immediately
      // To the user, it looks like it saved in 0ms.
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access theme for dynamic colors
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            "Add Habit",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color
            )
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("NAME", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: "e.g., Drink 8 glasses of water",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),
            const Text("CATEGORY", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) => setState(() => _selectedCategory = category),
                    selectedColor: const Color(0xFF4CAF50),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            const Text("Set a Reminder", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Daily Reminder", style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _isReminderOn,
                    activeColor: const Color(0xFF4CAF50),
                    onChanged: (val) => setState(() => _isReminderOn = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _saveHabit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
                "Save Habit",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ),
        ),
      ),
    );
  }
}