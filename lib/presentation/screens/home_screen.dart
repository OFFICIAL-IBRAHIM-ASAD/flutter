import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// Use the path that cleared your previous 5 errors
import '../../l10n/app_localizations.dart';

import 'package:flutter_projects/presentation/providers/auth_provider.dart';
import 'package:flutter_projects/presentation/providers/habit_provider.dart';
import '../../domain/entities/habit_entity.dart';
import 'add_habit_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

// --- STATS PAGE ---
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();
    final habits = habitProvider.habits;
    final loc = AppLocalizations.of(context)!;

    int totalHabitsCount = habits.length;
    int completedToday = habits.where((h) => h.isCompleted).length;
    int bestStreak = habits.isEmpty ? 0 : habits.map((h) => h.streakCount).reduce((a, b) => a > b ? a : b);
    int lifetimeCompletions = habits.isEmpty ? 0 : habits.fold(0, (sum, item) => sum + item.streakCount);
    double successRate = totalHabitsCount == 0 ? 0.0 : (completedToday / totalHabitsCount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.statistics, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(height: 24),
          _buildWeeklyActivityCard(context, successRate),
          const SizedBox(height: 24),
          const Text("Detailed Insights", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildStatCard(context, loc.bestStreak, "$bestStreak Days", Icons.local_fire_department, Colors.orange),
              _buildStatCard(context, loc.completed, "$lifetimeCompletions", Icons.check_circle, Colors.green),
              _buildStatCard(context, loc.successRate, "${(successRate * 100).toInt()}%", Icons.speed, Colors.blue),
              _buildStatCard(context, loc.activeHabits, "$totalHabitsCount", Icons.list_alt, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityCard(BuildContext context, double rate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Performance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["M", "T", "W", "T", "F", "S", "S"].map((day) {
              bool isToday = day == "T";
              return _buildBar(day, isToday ? rate : 0.4, isToday);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double heightPercent, bool isHighlight) {
    return Column(children: [
      Container(
        height: 80, width: 14,
        decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(7)),
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 80 * heightPercent, width: 14,
          decoration: BoxDecoration(color: isHighlight ? Colors.green : Colors.green.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(7)),
        ),
      ),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ]);
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

// --- ACHIEVEMENTS PAGE ---
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitProvider>().habits;
    final loc = AppLocalizations.of(context)!;

    bool hasSevenDayStreak = habits.any((h) => h.streakCount >= 7);
    bool isConsistentToday = habits.any((h) => h.isCompleted);
    bool isEarlyBird = habits.any((h) => h.isCompleted && h.lastCompletedDate != null && h.lastCompletedDate!.hour < 9);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(loc.trophy, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
        const SizedBox(height: 24),
        _buildTrophy(context, "Early Bird", "Finish a habit before 9 AM", Icons.wb_sunny, Colors.amber, isEarlyBird),
        _buildTrophy(context, "7 Day Streak", "Maintain a week-long chain", Icons.bolt, Colors.blue, hasSevenDayStreak),
        _buildTrophy(context, "Daily Winner", "Complete all of today's habits", Icons.star, Colors.purple, isConsistentToday),
      ]),
    );
  }

  Widget _buildTrophy(BuildContext context, String title, String desc, IconData icon, Color color, bool unlocked) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.3,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: unlocked ? Border.all(color: color.withValues(alpha: 0.5), width: 2) : null),
        child: Row(children: [
          CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ])),
          if (unlocked) const Icon(Icons.check_circle, color: Colors.green, size: 24),
        ]),
      ),
    );
  }
}

// --- ADDED THIS MISSING CLASS ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const LoginScreen();

    final List<Widget> pages = [
      _buildDashboard(user.fullName ?? 'User', user.uid),
      const StatsScreen(),
      const AchievementsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: pages[_selectedIndex]),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddHabitScreen())),
        backgroundColor: const Color(0xFF4CAF50),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      )
          : null,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildDashboard(String userName, String userId) {
    return StreamBuilder<List<HabitEntity>>(
      stream: context.read<HabitProvider>().getHabitsForUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final habits = snapshot.data ?? [];
        final total = habits.length;
        final completed = habits.where((h) => h.isCompleted).length;
        final percent = total == 0 ? 0.0 : (completed / total);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildTopAppBar(userName),
            const SizedBox(height: 20),
            _buildProgressCard(completed, total, percent),
            const SizedBox(height: 24),
            Text("Today's Habits", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (habits.isEmpty) const Center(child: Text("No habits yet. Add one!", style: TextStyle(color: Colors.grey)))
            else ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: habits.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Dismissible(
                  key: Key(habit.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => context.read<HabitProvider>().deleteHabit(habit.id),
                  background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), color: Colors.red[400], child: const Icon(Icons.delete, color: Colors.white)),
                  child: _buildHabitRow(habit),
                );
              },
            ),
          ]),
        );
      },
    );
  }

  Widget _buildTopAppBar(String userName) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.arrow_back_ios_new, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
        const SizedBox(width: 8),
        Text(DateFormat('EEEE, MMM d').format(DateTime.now()), style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Icon(Icons.arrow_forward_ios, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
      ]),
      const SizedBox(height: 8),
      Text("Good Morning, $userName", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 28, fontWeight: FontWeight.bold, height: 1.2)),
    ]);
  }

  Widget _buildProgressCard(int completed, int total, double percent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Today's Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("$completed/$total Completed", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text("${(percent * 100).toInt()}%", style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ]),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: percent, minHeight: 8, backgroundColor: Colors.green.withValues(alpha: 0.2), valueColor: const AlwaysStoppedAnimation<Color>(Colors.green)),
      ]),
    );
  }

  Widget _buildHabitRow(HabitEntity habit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.star, color: Colors.blue, size: 24)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(habit.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, decoration: habit.isCompleted ? TextDecoration.lineThrough : null)),
            Text("🔥 ${habit.streakCount} days", style: const TextStyle(color: Colors.green, fontSize: 14)),
          ]),
        ]),
        InkWell(
          onTap: () => context.read<HabitProvider>().toggleHabit(habit),
          child: Container(
            height: 32, width: 32,
            decoration: BoxDecoration(shape: BoxShape.circle, color: habit.isCompleted ? Colors.green : Colors.transparent, border: Border.all(color: habit.isCompleted ? Colors.green : Colors.grey, width: 2)),
            child: habit.isCompleted ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
          ),
        ),
      ]),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      height: 80,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 1.0))),
      child: SafeArea(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _buildNavItem(context, 0, Icons.dashboard, loc.dashboard),
        _buildNavItem(context, 1, Icons.bar_chart, loc.statistics),
        _buildNavItem(context, 2, Icons.emoji_events, loc.trophy),
        _buildNavItem(context, 3, Icons.settings, loc.settings),
      ])),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final bool isSelected = selectedIndex == index;
    final Color currentColor = isSelected ? const Color(0xFF4CAF50) : Colors.grey;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: currentColor, size: 24), Text(label, style: TextStyle(fontSize: 12, color: currentColor))]),
    );
  }
}