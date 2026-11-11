import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // 1. STATE VARIABLES
  List<String> notes = [];
  List<String> dates = [];
  String selectedDate = 'No date chosen';

  // 2. TEXT CONTROLLERS
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _editController = TextEditingController();

  // =========================================================
  // STORAGE & LIFECYCLE
  // =========================================================
  Future<void> saveToStorage() async {
    await StorageService.saveTaskData(
      notes: notes,
      dates: dates,
      draftNote: _noteController.text,
      draftDate: selectedDate,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadFromStorage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _noteController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      saveToStorage();
    }
  }

  Future<void> loadFromStorage() async {
    final data = await StorageService.loadTaskData();
    setState(() {
      notes = data['notes'] as List<String>;
      dates = data['dates'] as List<String>;
      _noteController.text = data['draftNote'] as String;
      selectedDate = data['draftDate'] as String;
    });
  }

  // =========================================================
  // DATE PICKER
  // =========================================================
  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('MMM dd, yyyy').format(pickedDate);
      });
      saveToStorage();
    }
  }

  // =========================================================
  // CRUD FUNCTIONS (CREATE, DELETE, UPDATE)
  // =========================================================
  void addTask() {
    if (_noteController.text.trim().isEmpty) return;
    setState(() {
      notes.add(_noteController.text.trim());
      dates.add(selectedDate);
      _noteController.clear();
      selectedDate = 'No date chosen';
    });
    saveToStorage();
  }

  void deleteTask(int index) {
    setState(() {
      notes.removeAt(index);
      dates.removeAt(index);
    });
    saveToStorage();
  }

  void editTask(int index) {
    _editController.text = notes[index];
    String tempEditedDate = dates[index];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _editController,
                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Due: $tempEditedDate',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setDialogState(() {
                              tempEditedDate =
                                  DateFormat('MMM dd, yyyy').format(pickedDate);
                            });
                          }
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_editController.text.trim().isNotEmpty) {
                      setState(() {
                        notes[index] = _editController.text.trim();
                        dates[index] = tempEditedDate;
                      });
                      saveToStorage();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // =========================================================
  // USER INTERFACE
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Smart Task Planner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black87,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () async {
              await StorageService.setLoggedIn(false);
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- TOP CARD: INPUT FORM ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _noteController,
                      onChanged: (val) => saveToStorage(),
                      decoration: const InputDecoration(
                        labelText: 'What do you need to do?',
                        hintText: 'e.g., Finish Flutter Project',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.task_alt, color: Colors.lightBlueAccent),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.lightBlueAccent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Due: $selectedDate',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                          onPressed: pickDate,
                          child: const Text('Pick Date', style: TextStyle(color: Colors.lightBlueAccent)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: addTask,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Task'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: notes.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks yet. Add your first task above!',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.lightBlue.shade100,
                              foregroundColor: Colors.lightBlueAccent,
                              child: Text('${index + 1}'),
                            ),
                            title: Text(
                              notes[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text('Due: ${dates[index]}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.yellow,
                                  ),
                                  onPressed: () => editTask(index),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.yellow,
                                  ),
                                  onPressed: () => deleteTask(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
