import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/habit_entity.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../data/datasources/habit_remote_datasource.dart';

class HabitProvider with ChangeNotifier {
  final HabitRepositoryImpl _repository = HabitRepositoryImpl(
    remoteDataSource: HabitRemoteDataSource(),
  );

  // --- NEW: Local list to share data between tabs ---
  List<HabitEntity> _habits = [];
  List<HabitEntity> get habits => _habits;

  // --- STREAK LOGIC HELPER ---
  bool _isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final compareDate = DateTime(date.year, date.month, date.day);
    return compareDate.isAtSameMomentAs(yesterday);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Future<void> toggleHabit(HabitEntity habit) async {
    // 1. Prepare the updated habit data
    bool newStatus = !habit.isCompleted;
    int newStreak = habit.streakCount;
    DateTime? newLastDate = habit.lastCompletedDate;

    if (newStatus) {
      if (habit.lastCompletedDate == null) {
        newStreak = 1;
      } else if (_isYesterday(habit.lastCompletedDate!)) {
        newStreak = habit.streakCount + 1;
      } else if (!_isToday(habit.lastCompletedDate!)) {
        newStreak = 1;
      }
      newLastDate = DateTime.now();
    }

    final updatedHabit = habit.copyWith(
      isCompleted: newStatus,
      streakCount: newStreak,
      lastCompletedDate: newLastDate,
    );

    // 2. OPTIMISTIC UPDATE: Update the local list and UI immediately
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      notifyListeners(); // This makes the checkmark toggle INSTANTLY
    }

    try {
      // 3. Sync with Firebase in the background
      await _repository.updateHabit(updatedHabit);
    } catch (e) {
      debugPrint("Error toggling: $e");
      // Optional: If it fails, revert the change locally
      if (index != -1) {
        _habits[index] = habit;
        notifyListeners();
      }
    }
  }

  Future<void> addHabit(String title, String category, bool isReminderOn, String userId) async {
    final newHabit = HabitEntity(
      id: const Uuid().v1(),
      userId: userId,
      title: title,
      category: category,
      icon: "water_drop",
      isReminderOn: isReminderOn,
      createdAt: DateTime.now(),
      isCompleted: false,
      streakCount: 0,
    );

    // 1. Update UI immediately
    _habits.insert(0, newHabit);
    notifyListeners();

    // 2. Fire and Forget (Don't 'await' the repository)
    _repository.addHabit(newHabit).catchError((e) {
      // Revert if it fails eventually
      _habits.removeWhere((h) => h.id == newHabit.id);
      notifyListeners();
      debugPrint("Background save failed: $e");
    });
  }

  // --- UPDATED: Captures the stream data into our local list ---
  Stream<List<HabitEntity>> getHabitsForUser(String userId) {
    return _repository.getHabitsForUser(userId).map((habitList) {
      _habits = habitList; // Saves data so Trophy/Stats screens can see it
      return habitList;
    });
  }

  Future<void> deleteHabit(String habitId) async {
    await _repository.deleteHabit(habitId);
  }
}