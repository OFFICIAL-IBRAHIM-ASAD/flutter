import 'package:flutter/material.dart';
import '../../core/theme/app_colours.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. TOP NAV BAR
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textMain,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Habit Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. HEADER (Icon & Title)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        // FIX: Changed .withOpacity to .withValues
                        color: AppColors.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Drink 2L Water",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. STATS GRID
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard("Current Streak", "14 Days"),
                    const SizedBox(width: 12),
                    _buildStatCard("Best Streak", "32 Days"),
                    const SizedBox(width: 12),
                    _buildStatCard("Completion", "88%"),
                  ],
                ),
              ),

              // 4. CALENDAR (Visual Representation)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      // Calendar Header
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.chevron_left, color: AppColors.textMain),
                          Text(
                            "October 2024",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.chevron_right, color: AppColors.textMain),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Days Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                        ),
                        itemCount: 31 + 2,
                        // 31 days + 2 empty slots for alignment
                        itemBuilder: (context, index) {
                          if (index < 2) return const SizedBox(); // Empty slots
                          int day = index - 1;
                          // Dummy logic to color some days green to match your design
                          bool isSelected = [
                            2,
                            3,
                            5,
                            7,
                            8,
                            9,
                            12,
                          ].contains(day);
                          bool isToday = day == 16;

                          return Container(
                            margin: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isToday
                                  ? Colors.transparent
                                  : Colors.transparent),
                              shape: BoxShape.circle,
                              border: isToday
                                  ? Border.all(
                                color: AppColors.primary,
                                width: 2,
                              )
                                  : null,
                            ),
                            child: Text(
                              "$day",
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 5. SETTINGS LIST
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      Icons.event_repeat,
                      "Frequency",
                      "Daily",
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      Icons.notifications,
                      "Reminder",
                      "8:00 AM",
                    ),
                  ],
                ),
              ),

              // 6. ACTION BUTTONS
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildActionButton("Archive Habit", AppColors.primary),
                    const SizedBox(height: 12),
                    _buildActionButton("Delete Habit", AppColors.destructive),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(value, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}