import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'task_data.dart';

class TodayTaskScreen extends StatefulWidget {
  const TodayTaskScreen({super.key});

  @override
  State<TodayTaskScreen> createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {
  int selectedDateIndex = 0;
  int selectedStatus = 0;

  final List<String> statusList = ["To Do", "In Progress", "Completed"];

  List<DateTime> getWeekDays() {
    final today = DateTime.now();
    return List.generate(7, (index) => today.add(Duration(days: index)));
  }

  String get currentStatus => statusList[selectedStatus];

  Color priorityColor(String priority) {
    if (priority == "High") return Colors.redAccent;
    if (priority == "Low") return Colors.greenAccent;
    return Colors.orangeAccent;
  }

  Future<void> editTask(TaskModel task) async {
    final titleCtrl = TextEditingController(text: task.title);

    final descCtrl = TextEditingController(text: task.description);

    String category = task.category;

    String priority = task.priority;

    String status = task.status;

    await showDialog(
      context: context,

      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Task"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    TextField(
                      controller: titleCtrl,

                      decoration: const InputDecoration(
                        labelText: "Task Title",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: descCtrl,

                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField(
                      value: category,

                      items: ["Study", "Projects", "Social Life", "Home"].map((
                        e,
                      ) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),

                      onChanged: (value) {
                        setDialogState(() {
                          category = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField(
                      value: priority,

                      items: ["Low", "Medium", "High"].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),

                      onChanged: (value) {
                        setDialogState(() {
                          priority = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField(
                      value: status,

                      items: ["To Do", "In Progress", "Completed"].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),

                      onChanged: (value) {
                        setDialogState(() {
                          status = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(task.id)
                        .update({
                          "title": titleCtrl.text,

                          "description": descCtrl.text,

                          "category": category,

                          "priority": priority,

                          "status": status,
                        });

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },

                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = getWeekDays();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Tasks ✨",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 95,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weekDays.length,
                    itemBuilder: (context, index) {
                      final date = weekDays[index];
                      final isSelected = selectedDateIndex == index;
                      final isToday =
                          date.day == DateTime.now().day &&
                          date.month == DateTime.now().month &&
                          date.year == DateTime.now().year;

                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedDateIndex = index);
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF9B5CFF),
                                      Color(0xFF6A3DE8),
                                    ],
                                  )
                                : null,
                            color: isSelected
                                ? null
                                : Colors.white.withOpacity(0.12),
                            border: isToday
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${date.month}/${date.day}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                [
                                  "Mon",
                                  "Tue",
                                  "Wed",
                                  "Thu",
                                  "Fri",
                                  "Sat",
                                  "Sun",
                                ][date.weekday - 1],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: statusList.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedStatus == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedStatus = index);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),

                            color: isSelected
                                ? Colors.pink
                                : Colors.white.withOpacity(0.12),
                          ),

                          child: Text(
                            statusList[index],

                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tasks')
                        .where('uid', isEqualTo: user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      final docs = snapshot.data?.docs ?? [];

                      List<TaskModel> tasks = docs.map((doc) {
                        return TaskModel.fromMap(
                          doc.data() as Map<String, dynamic>,
                        );
                      }).toList();

                      final selectedDate = weekDays[selectedDateIndex];

                      final selectedDateString =
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";

                      tasks = tasks.where((task) {
                        return task.status == currentStatus &&
                            task.date == selectedDateString;
                      }).toList();

                      if (tasks.isEmpty) {
                        return Center(
                          child: Text(
                            "No $currentStatus tasks yet ✨",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return Dismissible(
                            key: Key(task.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(task.id)
                                  .delete();
                            },
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                editTask(task);
                              },

                              child: Container(
                                margin: const EdgeInsets.only(bottom: 15),

                                padding: const EdgeInsets.all(20),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: Colors.white.withOpacity(0.10),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(14),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFFF6FD8),
                                                Color(0xFFFF9068),
                                              ],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.task_alt,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task.title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                task.description.isEmpty
                                                    ? task.category
                                                    : task.description,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),

                                    Row(
                                      children: [
                                        _miniChip(task.category, Colors.purple),
                                        const SizedBox(width: 8),
                                        _miniChip(
                                          task.priority,
                                          priorityColor(task.priority),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            task.date,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),

                                    Row(
                                      children: [
                                        if (task.status == "To Do")
                                          Expanded(
                                            child: _actionButton(
                                              text: "Start",
                                              icon: Icons.play_arrow_rounded,
                                              onTap: () {
                                                updateTaskStatus(
                                                  task.id,
                                                  "In Progress",
                                                );
                                              },
                                            ),
                                          ),

                                        if (task.status == "In Progress")
                                          Expanded(
                                            child: _actionButton(
                                              text: "Complete",
                                              icon: Icons.check_rounded,
                                              onTap: () {
                                                updateTaskStatus(
                                                  task.id,
                                                  "Completed",
                                                );
                                              },
                                            ),
                                          ),

                                        if (task.status == "Completed")
                                          Expanded(
                                            child: _actionButton(
                                              text: "Reset",
                                              icon: Icons.refresh_rounded,
                                              onTap: () {
                                                updateTaskStatus(
                                                  task.id,
                                                  "To Do",
                                                );
                                              },
                                            ),
                                          ),

                                        const SizedBox(width: 10),

                                        IconButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('tasks')
                                                .doc(task.id)
                                                .delete();
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.25),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
