import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_project/cloudinary_service.dart';
import 'package:flutter_project/welcome_page.dart';
import 'package:flutter_project/task_data.dart';
import 'package:flutter_project/notification_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isUploading = false;

  Future<void> pickImage(String uid) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedImage == null) return;

    setState(() => isUploading = true);

    final imageUrl = await CloudinaryService.uploadImage(pickedImage);

    if (imageUrl != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profileImage': imageUrl,
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Profile image updated")));
      }
    }

    if (mounted) setState(() => isUploading = false);
  }

  Future<void> editProfile({
    required String uid,
    required String currentName,
    required String currentUsername,
    required String currentCourse,
    required String currentBio,
    required int currentDailyGoal,
    required String currentReminderTime,
    required bool currentNotificationsEnabled,
  }) async {
    final nameCtrl = TextEditingController(text: currentName);
    final usernameCtrl = TextEditingController(text: currentUsername);
    final courseCtrl = TextEditingController(text: currentCourse);
    final bioCtrl = TextEditingController(text: currentBio);
    final dailyGoalCtrl = TextEditingController(
      text: currentDailyGoal.toString(),
    );
    final reminderCtrl = TextEditingController(text: currentReminderTime);

    bool notificationsEnabled = currentNotificationsEnabled;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Profile Settings"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: "Full Name"),
                    ),
                    TextField(
                      controller: usernameCtrl,
                      decoration: const InputDecoration(labelText: "Username"),
                    ),
                    TextField(
                      controller: courseCtrl,
                      decoration: const InputDecoration(
                        labelText: "Course / Program",
                      ),
                    ),
                    TextField(
                      controller: bioCtrl,
                      decoration: const InputDecoration(
                        labelText: "Bio / Status",
                      ),
                    ),
                    TextField(
                      controller: dailyGoalCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Daily Goal",
                      ),
                    ),
                    TextField(
                      controller: reminderCtrl,
                      decoration: const InputDecoration(
                        labelText: "Preferred Reminder Time",
                        hintText: "Example: 8:00 PM",
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Enable Notifications"),
                      value: notificationsEnabled,
                      onChanged: (value) {
                        setDialogState(() {
                          notificationsEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update({
                          'name': nameCtrl.text.trim(),
                          'username': usernameCtrl.text.trim(),
                          'course': courseCtrl.text.trim(),
                          'bio': bioCtrl.text.trim(),
                          'dailyGoal':
                              int.tryParse(dailyGoalCtrl.text.trim()) ?? 0,
                          'reminderTime': reminderCtrl.text.trim(),
                          'notificationsEnabled': notificationsEnabled,
                          'updatedAt': FieldValue.serverTimestamp(),
                        });
                    await NotificationService.showNotification();

                    if (mounted) Navigator.pop(context);
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

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("No user logged in"));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

        final name = data['name'] ?? 'No Name';
        final username = data['username'] ?? '';
        final email = data['email'] ?? user.email ?? '';
        final course = data['course'] ?? 'BS Information Technology';
        final bio = data['bio'] ?? 'Focused on finishing tasks.';
        final dailyGoal = data['dailyGoal'] ?? 5;
        final reminderTime = data['reminderTime'] ?? '8:00 PM';
        final notificationsEnabled = data['notificationsEnabled'] ?? true;
        final profileImage = data['profileImage'];

        final completed = 0;
        final pending = allTasks.length;
        final projects = allTasks
            .where((task) => task.category == "Projects")
            .length;

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF3B0F9C), Color(0xFF240046)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.18),
                          Colors.white.withOpacity(0.08),
                        ],
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: isUploading ? null : () => pickImage(user.uid),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFF6FD8),
                                      Color(0xFFFF9068),
                                    ],
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      profileImage != null &&
                                          profileImage.toString().isNotEmpty
                                      ? NetworkImage(profileImage)
                                      : const AssetImage("assets/profile.png")
                                            as ImageProvider,
                                ),
                              ),
                              if (isUploading)
                                const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        ElevatedButton.icon(
                          onPressed: () {
                            editProfile(
                              uid: user.uid,
                              currentName: name,
                              currentUsername: username,
                              currentCourse: course,
                              currentBio: bio,
                              currentDailyGoal: dailyGoal is int
                                  ? dailyGoal
                                  : 5,
                              currentReminderTime: reminderTime,
                              currentNotificationsEnabled: notificationsEnabled,
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit Profile"),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          course,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),

                        if (username.toString().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            "@$username",
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        Text(
                          bio,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _statCard(
                              "$completed",
                              "Completed",
                              Icons.check_circle,
                            ),
                            _statCard("$pending", "Pending", Icons.access_time),
                            _statCard("$projects", "Projects", Icons.folder),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  _settingsCard(
                    icon: Icons.flag_rounded,
                    title: "Daily Goal",
                    value: "$dailyGoal tasks per day",
                  ),

                  const SizedBox(height: 12),

                  _settingsCard(
                    icon: Icons.notifications_active_rounded,
                    title: "Reminder Time",
                    value: reminderTime,
                  ),

                  const SizedBox(height: 12),

                  _settingsCard(
                    icon: Icons.notifications_rounded,
                    title: "Notifications",
                    value: notificationsEnabled ? "Enabled" : "Disabled",
                  ),

                  const SizedBox(height: 25),

                  GestureDetector(onTap: logout, child: _logoutButton()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _settingsCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.08),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String number, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _logoutButton() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF3D68)],
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.logout_rounded, color: Colors.white),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              "Log Out",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}
