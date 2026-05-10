import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF3B0F9C), Color(0xFF240046)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(22, 22, 22, 150),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _header(),

              const SizedBox(height: 30),

              _todayLabel(),

              const SizedBox(height: 25),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('uid', isEqualTo: user?.uid)
                    .orderBy('time', descending: true)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),

                        borderRadius: BorderRadius.circular(25),
                      ),

                      child: const Column(
                        children: [
                          Icon(
                            Icons.notifications_off_rounded,
                            color: Colors.white70,
                            size: 55,
                          ),

                          SizedBox(height: 15),

                          Text(
                            "No notifications yet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "Create a task to receive notifications ✨",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final notifications = snapshot.data!.docs;

                  return Column(
                    children: notifications.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      final Timestamp? timestamp = data['time'];

                      final DateTime? dateTime = timestamp?.toDate();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),

                        child: NotificationCard(
                          title: data['title'] ?? '',
                          message: data['message'] ?? '',
                          time: dateTime == null ? "Now" : _timeAgo(dateTime),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
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
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),

            borderRadius: BorderRadius.circular(18),
          ),

          child: const Icon(
            Icons.notifications_active_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _todayLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: const LinearGradient(
          colors: [Color(0xFFFF6FD8), Color(0xFFFF9068)],
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
    );
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} mins ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    }

    return "${difference.inDays} days ago";
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.35),

            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),

              borderRadius: BorderRadius.circular(20),
            ),

            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Text(
                      time,

                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),

                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  message,

                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),

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
