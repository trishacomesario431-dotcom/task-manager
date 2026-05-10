import 'package:flutter/material.dart';

class TodayTaskScreen extends StatefulWidget {
  const TodayTaskScreen({super.key});

  @override
  State<TodayTaskScreen> createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {
  int selectedDateIndex = 0;
  int selectedStatus = 0;

  final List<String> statusList = [
    "To Do",
    "In Progress",
    "Completed",
  ];

  // ================= REAL DATE GENERATION =================
  List<DateTime> getWeekDays() {
    final today = DateTime.now();
    return List.generate(7, (index) {
      return today.add(Duration(days: index));
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = getWeekDays();

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF3B0F9C),
              Color(0xFF240046),
            ],
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

                // ================= HEADER =================
                const Text(
                  "Today's Tasks ✨",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                // ================= REAL DATE ROW =================
                SizedBox(
                  height: 95,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weekDays.length,

                    itemBuilder: (context, index) {
                      final date = weekDays[index];
                      final isSelected = selectedDateIndex == index;
                      final isToday = date.day == DateTime.now().day;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDateIndex = index;
                          });
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
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
                                    [date.weekday - 1],
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

                // ================= STATUS =================
                SizedBox(
                  height: 45,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: statusList.length,

                    itemBuilder: (context, index) {
                      final isSelected = selectedStatus == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedStatus = index;
                          });
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

                const SizedBox(height: 20),

                // ================= EMPTY STATE (REAL APP STYLE) =================
                const Expanded(
                  child: Center(
                    child: Text(
                      "No tasks yet for this day\nCreate your first task ✨",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}