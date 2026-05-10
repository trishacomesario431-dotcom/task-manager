import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ================= HEADER =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    const Text(
                      "My Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // ================= PROFILE CARD =================
                Container(
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.18),
                        Colors.white.withOpacity(0.08),
                      ],
                    ),

                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [

                      // PROFILE IMAGE
                      Container(
                        padding: const EdgeInsets.all(4),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF6FD8),
                              Color(0xFFFF9068),
                            ],
                          ),
                        ),

                        child: const CircleAvatar(
                          radius: 48,
                          backgroundImage:
                              AssetImage("assets/shang.png"),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Trisha Comesario",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "BS Information Technology",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // STATS
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,

                        children: [

                          _statCard(
                            "28",
                            "Completed",
                            Icons.check_circle,
                          ),

                          _statCard(
                            "12",
                            "Pending",
                            Icons.access_time,
                          ),

                          _statCard(
                            "8",
                            "Projects",
                            Icons.folder,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  "Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _profileButton(
                  Icons.person_outline_rounded,
                  "Account Information",
                  "Update your personal details",
                ),

                const SizedBox(height: 16),

                _profileButton(
                  Icons.settings_rounded,
                  "Settings",
                  "Customize your preferences",
                ),

                const SizedBox(height: 16),

                _profileButton(
                  Icons.notifications_active_rounded,
                  "Notifications",
                  "Manage reminder settings",
                ),

                const SizedBox(height: 16),

                _profileButton(
                  Icons.lock_outline_rounded,
                  "Privacy & Security",
                  "Protect your account",
                ),

                const SizedBox(height: 16),

                _logoutButton(),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),

      // ================= FAB =================
      floatingActionButton: Container(
        height: 70,
        width: 70,

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
              color: Colors.purple.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {},

          child: const Icon(
            Icons.add,
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
              color: Colors.black.withOpacity(0.15),
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

                const Icon(
                  Icons.home_rounded,
                  color: Colors.white70,
                  size: 28,
                ),

                const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white70,
                  size: 28,
                ),

                const SizedBox(width: 40),

                const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white70,
                  size: 28,
                ),

                Container(
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= PROFILE BUTTON =================
  Widget _profileButton(
    IconData icon,
    String title,
    String subtitle,
  ) {
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

        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(
              icon,
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
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white54,
            size: 18,
          ),
        ],
      ),
    );
  }

  // ================= STATS CARD =================
  Widget _statCard(
    String number,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [

        Container(
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
          ),

          child: Icon(
            icon,
            color: Colors.white,
          ),
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
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ================= LOGOUT BUTTON =================
  Widget _logoutButton() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF6B6B),
            Color(0xFFFF3D68),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: const [

          Icon(
            Icons.logout_rounded,
            color: Colors.white,
          ),

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

          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 18,
          ),
        ],
      ),
    );
  }
}