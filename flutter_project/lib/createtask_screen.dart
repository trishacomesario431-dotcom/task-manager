import 'package:flutter/material.dart';
import 'task_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/notification_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  String selectedCategory = "Study";
  String selectedStatus = "To Do";
  String selectedPriority = "Medium";

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // ================= DATE PICKER =================
  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6FD8),
              surface: Color(0xFF2A0A4A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  // ================= TIME PICKER =================
  Future<void> pickTime(bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Color(0xFFFF6FD8)),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        if (isStart) {
          startTime = time;
        } else {
          endTime = time;
        }
      });
    }
  }

  // ================= SAVE TASK =================
  Future<void> saveTask() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter task title"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final taskId = FirebaseFirestore.instance.collection('tasks').doc().id;

      final task = TaskModel(
        status: selectedStatus,
        priority: selectedPriority,
        id: taskId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory,
        date: selectedDate == null
            ? "No Date"
            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
        uid: user.uid,
      );

      // SAVE TASK
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .set(task.toMap());

      // CREATE NOTIFICATION
      await FirebaseFirestore.instance.collection('notifications').add({
        "uid": user.uid,
        "title": "Task Created ✨",
        "message":
            "${titleController.text.trim()} has been added successfully.",
        "time": Timestamp.now(),
        "isRead": false,
      });

      // PHONE NOTIFICATION
      await NotificationService.showNotification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task Saved Successfully ✨"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  // ================= DELETE =================
  void deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A0A4A),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),

        title: const Text(
          "Delete Task?",
          style: TextStyle(color: Colors.white),
        ),

        content: const Text(
          "Clear all fields?",
          style: TextStyle(color: Colors.white70),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),

            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white70),
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
              clearFields();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fields Cleared 🗑️"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },

            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CLEAR =================
  void clearFields() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      selectedDate = null;
      startTime = null;
      endTime = null;
      selectedCategory = "Study";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF3B0F9C), Color(0xFF240046)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= HEADER =================
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),

                      child: Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),

                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),

                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Create Task ✨",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Stay organized and productive",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // ================= GLASS CARD =================
                Container(
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),

                    border: Border.all(color: Colors.white.withOpacity(0.08)),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Task Title", style: _labelStyle),

                      const SizedBox(height: 12),

                      _inputField(
                        "Enter your task title",
                        titleController,
                        Icons.edit_note_rounded,
                      ),

                      const SizedBox(height: 25),

                      const Text("Due Date", style: _labelStyle),

                      const SizedBox(height: 12),

                      _dateField(),

                      const SizedBox(height: 25),

                      Row(
                        children: [
                          Expanded(
                            child: _timeField(
                              "Start Time",
                              true,
                              Icons.access_time_filled_rounded,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: _timeField(
                              "End Time",
                              false,
                              Icons.timelapse_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text("Category", style: _labelStyle),

                      const SizedBox(height: 18),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _category("Study"),
                          _category("Projects"),
                          _category("Social Life"),
                          _category("Home"),
                        ],
                      ),
                      const SizedBox(height: 30),

                      const Text("Task Status", style: _labelStyle),

                      const SizedBox(height: 18),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _statusChip("To Do"),
                          _statusChip("In Progress"),
                          _statusChip("Completed"),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text("Priority", style: _labelStyle),

                      const SizedBox(height: 18),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _priorityChip("Low"),
                          _priorityChip("Medium"),
                          _priorityChip("High"),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text("Description", style: _labelStyle),

                      const SizedBox(height: 12),

                      _descriptionBox(),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // ================= BUTTONS =================
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,

                        child: OutlinedButton(
                          onPressed: deleteTask,

                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white38),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),

                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: SizedBox(
                        height: 60,

                        child: ElevatedButton(
                          onPressed: saveTask,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.zero,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),

                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6FD8), Color(0xFFFF9068)],
                              ),
                            ),

                            child: const Center(
                              child: Text(
                                "Save Task",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= LABEL STYLE =================
  static const TextStyle _labelStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // ================= INPUT FIELD =================
  Widget _inputField(
    String hint,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),

      child: TextField(
        controller: controller,

        style: const TextStyle(color: Colors.white),

        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          icon: Icon(icon, color: Colors.white70),
        ),
      ),
    );
  }

  // ================= DATE FIELD =================
  Widget _dateField() {
    return GestureDetector(
      onTap: pickDate,

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(22),

          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),

        child: Row(
          children: [
            const Icon(Icons.calendar_month_rounded, color: Colors.white),

            const SizedBox(width: 14),

            Text(
              selectedDate == null
                  ? "Select date"
                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",

              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TIME FIELD =================
  Widget _timeField(String label, bool isStart, IconData icon) {
    return GestureDetector(
      onTap: () => pickTime(isStart),

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(22),

          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),

            const SizedBox(height: 15),

            Text(
              label,

              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 5),

            Text(
              isStart
                  ? (startTime?.format(context) ?? "08:00 AM")
                  : (endTime?.format(context) ?? "10:00 AM"),

              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CATEGORY =================
  Widget _category(String label) {
    final isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFF6FD8), Color(0xFFFF9068)],
                )
              : null,

          color: isSelected ? null : Colors.white.withOpacity(0.10),
        ),

        child: Text(
          label,

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String label) {
    final isSelected = selectedStatus == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = label;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                )
              : null,

          color: isSelected ? null : Colors.white.withOpacity(0.10),
        ),

        child: Text(
          label,

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _priorityChip(String label) {
    final isSelected = selectedPriority == label;

    Color chipColor;

    switch (label) {
      case "Low":
        chipColor = Colors.green;
        break;

      case "High":
        chipColor = Colors.red;
        break;

      default:
        chipColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPriority = label;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          color: isSelected ? chipColor : Colors.white.withOpacity(0.10),
        ),

        child: Text(
          label,

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ================= DESCRIPTION =================
  Widget _descriptionBox() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(25),

        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),

      child: TextField(
        controller: descriptionController,
        maxLines: null,
        expands: true,

        style: const TextStyle(color: Colors.white),

        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Write task details here...",
          hintStyle: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}
