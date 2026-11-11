import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyNotes = 'notes';
  static const String _keyDates = 'dates';
  static const String _keyDraftNote = 'draft_note';
  static const String _keyDraftDate = 'draft_date';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // --- LOGIN SESSION ---
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  // --- SAVE TASKS & DRAFTS ---
  static Future<void> saveTaskData({
    required List<String> notes,
    required List<String> dates,
    required String draftNote,
    required String draftDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyNotes, notes);
    await prefs.setStringList(_keyDates, dates);
    await prefs.setString(_keyDraftNote, draftNote);
    await prefs.setString(_keyDraftDate, draftDate);
  }

  // --- LOAD TASKS & DRAFTS ---
  static Future<Map<String, dynamic>> loadTaskData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'notes': prefs.getStringList(_keyNotes) ?? <String>[],
      'dates': prefs.getStringList(_keyDates) ?? <String>[],
      'draftNote': prefs.getString(_keyDraftNote) ?? '',
      'draftDate': prefs.getString(_keyDraftDate) ?? 'No date chosen',
    };
  }
}
