import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'todaytask_screen.dart';
import 'profile_screen.dart';
import 'createtask_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  final List<Map<String, dynamic>> notifications = [
    {
      "title": "Task Completed 🎉",
      "message":
          "Congrats! Your house cleaning task is now complete.",
      "time": "2 mins ago",
      "icon": Icons.check_circle_rounded,
      "color1": const Color(0xFF00C9FF),
      "color2": const Color(0xFF92FE9D),
    },
    {
      "title": "Class Reminder 📚",
      "message":
          "Your Intermediate Programming online class should start now.",
      "time": "10 mins ago",
      "icon": Icons.menu_book_rounded,
      "color1": const Color(0xFF8E2DE2),
      "color2": const Color(0xFF4A00E0),
    },
    {
      "title": "Travel Schedule ✈️",
      "message":
          "Your friend is scheduled to go to Baguio today.",
      "time": "1 hour ago",
      "icon": Icons.flight_takeoff_rounded,
      "color1": const Color(0xFFFF6FD8),
      "color2": const Color(0xFFFF9068),
    },
    {
      "title": "Workout Reminder 💪",
      "message":
          "Don't forget your evening workout routine.",
      "time": "3 hours ago",
      "icon": Icons.fitness_center_rounded,
      "color1": const Color(0xFFFF9966),
      "color2": const Color(0xFFFF5E62),
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // ================= HEADER =================
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: const [

                        Text(
                          "Notifications 🔔",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Stay updated with your tasks",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.12),

                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ================= TODAY LABEL =================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(18),

                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF6FD8),
                        Color(0xFFFF9068),
                      ],
                    ),
                  ),

                  child: const Text(
                    "Today",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ================= NOTIFICATIONS =================
                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,

                    itemBuilder: (context, index) {

                      final item =
                          notifications[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 20,
                        ),

                        child: NotificationCard(
                          title: item["title"],
                          message: item["message"],
                          time: item["time"],
                          icon: item["icon"],
                          color1: item["color1"],
                          color2: item["color2"],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ================= FAB =================
      floatingActionButton: Container(
        height: 72,
        width: 72,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          gradient: const LinearGradient(
            colors: [
              Color(0xFF9B5CFF),
              Color(0xFF6A3DE8),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.purple
                  .withOpacity(0.35),

              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const CreateTaskScreen(),
              ),
            );
          },

          child: const Icon(
            Icons.add_rounded,
            size: 34,
            color: Colors.white,
          ),
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // ================= BOTTOM NAV =================
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),

          gradient: const LinearGradient(
            colors: [
              Color(0xFF7C4DFF),
              Color(0xFF5E35B1),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.18),

              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          shape: const CircularNotchedRectangle(),

          child: SizedBox(
            height: 70,

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,

              children: [

                // HOME
                IconButton(
                  icon: const Icon(
                    Icons.home_rounded,
                    color: Colors.white54,
                  ),

                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const HomeScreen(),
                      ),
                    );
                  },
                ),

                // TASKS
                IconButton(
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white54,
                  ),

                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const TodayTaskScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 40),

                // NOTIFICATIONS
                const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                  size: 28,
                ),

                // PROFILE
                IconButton(
                  icon: const Icon(
                    Icons.person_rounded,
                    color: Colors.white54,
                  ),

                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= NOTIFICATION CARD =================
class NotificationCard extends StatelessWidget {

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color1;
  final Color color2;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color1.withOpacity(0.9),
            color2.withOpacity(0.9),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.35),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(0.18),

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [

                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(0.75),

                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  message,
                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(0.85),

                    height: 1.4,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}