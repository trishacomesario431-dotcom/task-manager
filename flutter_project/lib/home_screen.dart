import 'package:flutter/material.dart';
import 'createtask_screen.dart';
import 'todaytask_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'category_screen.dart';
import 'task_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Widget buildHomeContent() {
    final studyCount =
        allTasks.where((task) => task.category == "Study").length;

    final projectCount =
        allTasks.where((task) => task.category == "Projects").length;

    final socialCount =
        allTasks.where((task) => task.category == "Social Life").length;

    final homeCount =
        allTasks.where((task) => task.category == "Home").length;

    return Container(
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },

                    child: Container(
                      padding: const EdgeInsets.all(3),

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white24,
                          width: 2,
                        ),
                      ),

                      child: const CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            AssetImage("assets/profile.png"),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Hello 👋",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Trisha Comesario",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius:
                          BorderRadius.circular(15),
                    ),

                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ================= PROGRESS CARD =================
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
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Today's Progress",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${allTasks.length} Total Tasks",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20),

                      child: LinearProgressIndicator(
                        value:
                            allTasks.isEmpty ? 0 : 0.7,
                        minHeight: 10,
                        backgroundColor:
                            Colors.white24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= TITLE =================
              const Text(
                "Task Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ================= CONTENT =================
              Expanded(
                child: Column(
                  children: [

                    // ================= GRID =================
                    Expanded(
                      flex: 2,

                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.88,

                        children: [

                          // STUDY
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CategoryScreen(
                                    title: "Study",
                                    color:
                                        Color(0xFF8E2DE2),
                                    icon:
                                        Icons.menu_book,
                                  ),
                                ),
                              );

                              setState(() {});
                            },

                            child: TaskCard(
                              title: "Study",
                              subtitle:
                                  "$studyCount Tasks",
                              icon: Icons
                                  .menu_book_rounded,
                              color1:
                                  const Color(0xFF8E2DE2),
                              color2:
                                  const Color(0xFF4A00E0),
                            ),
                          ),

                          // PROJECTS
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CategoryScreen(
                                    title: "Projects",
                                    color:
                                        Color(0xFFFF6FD8),
                                    icon: Icons.folder,
                                  ),
                                ),
                              );

                              setState(() {});
                            },

                            child: TaskCard(
                              title: "Projects",
                              subtitle:
                                  "$projectCount Tasks",
                              icon:
                                  Icons.folder_rounded,
                              color1:
                                  const Color(0xFFFF6FD8),
                              color2:
                                  const Color(0xFFFF9068),
                            ),
                          ),

                          // SOCIAL LIFE
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CategoryScreen(
                                    title:
                                        "Social Life",
                                    color:
                                        Color(0xFF00C9FF),
                                    icon: Icons.chat,
                                  ),
                                ),
                              );

                              setState(() {});
                            },

                            child: TaskCard(
                              title: "Social Life",
                              subtitle:
                                  "$socialCount Tasks",
                              icon: Icons
                                  .chat_bubble_rounded,
                              color1:
                                  const Color(0xFF00C9FF),
                              color2:
                                  const Color(0xFF92FE9D),
                            ),
                          ),

                          // HOME
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CategoryScreen(
                                    title: "Home",
                                    color:
                                        Color(0xFFFF9966),
                                    icon: Icons.home,
                                  ),
                                ),
                              );

                              setState(() {});
                            },

                            child: TaskCard(
                              title: "Home",
                              subtitle:
                                  "$homeCount Tasks",
                              icon: Icons.home_rounded,
                              color1:
                                  const Color(0xFFFF9966),
                              color2:
                                  const Color(0xFFFF5E62),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= TASK LIST TITLE =================
                    const Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        "Your Tasks",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ================= TASK LIST =================
                    Expanded(
                      flex: 1,

                      child: allTasks.isEmpty
                          ? const Center(
                              child: Text(
                                "No Tasks Yet",
                                style: TextStyle(
                                  color:
                                      Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            )

                          : ListView.builder(
                              itemCount:
                                  allTasks.length,

                              itemBuilder:
                                  (context, index) {
                                final task =
                                    allTasks[index];

                                return Dismissible(
                                  key: Key(
                                    task.title +
                                        index.toString(),
                                  ),

                                  direction:
                                      DismissDirection
                                          .endToStart,

                                  onDismissed: (_) {
                                    setState(() {
                                      allTasks.removeAt(
                                          index);
                                    });

                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Task Deleted",
                                        ),
                                      ),
                                    );
                                  },

                                  background: Container(
                                    margin:
                                        const EdgeInsets
                                            .only(
                                      bottom: 12,
                                    ),

                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 20,
                                    ),

                                    alignment:
                                        Alignment
                                            .centerRight,

                                    decoration:
                                        BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  20),
                                    ),

                                    child: const Icon(
                                      Icons.delete,
                                      color:
                                          Colors.white,
                                    ),
                                  ),

                                  child: Container(
                                    margin:
                                        const EdgeInsets
                                            .only(
                                      bottom: 12,
                                    ),

                                    padding:
                                        const EdgeInsets
                                            .all(18),

                                    decoration:
                                        BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(
                                              0.12),

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  20),

                                      border: Border.all(
                                        color:
                                            Colors.white24,
                                      ),
                                    ),

                                    child: Row(
                                      children: [

                                        const Icon(
                                          Icons.task_alt,
                                          color:
                                              Colors.white,
                                        ),

                                        const SizedBox(
                                            width: 15),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,

                                            children: [
                                              Text(
                                                task
                                                    .title,

                                                style:
                                                    const TextStyle(
                                                  color:
                                                      Colors.white,
                                                  fontSize:
                                                      18,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),

                                              const SizedBox(
                                                  height:
                                                      5),

                                              Text(
                                                task
                                                    .category,

                                                style:
                                                    const TextStyle(
                                                  color: Colors
                                                      .white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        IconButton(
                                          icon:
                                              const Icon(
                                            Icons
                                                .delete_outline,
                                            color: Colors
                                                .white,
                                          ),

                                          onPressed:
                                              () {
                                            setState(() {
                                              allTasks
                                                  .removeAt(
                                                      index);
                                            });
                                          },
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
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get pages => [
      buildHomeContent(),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: const TodayTaskScreen(),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: const NotificationsScreen(),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: const ProfileScreen(),
      ),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,

      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),

      // ================= FLOATING BUTTON =================
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            const Color(0xFF7C4DFF),
        elevation: 8,

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateTaskScreen(),
            ),
          );

          setState(() {});
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerDocked,

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(30),

          gradient: const LinearGradient(
            colors: [
              Color(0xFF7C4DFF),
              Color(0xFF5E35B1),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),

        child: BottomAppBar(
          shape:
              const CircularNotchedRectangle(),
          notchMargin: 10,
          color: Colors.transparent,
          elevation: 0,

          child: SizedBox(
            height: 70,

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,

              children: [

                // HOME
                IconButton(
                  icon: Icon(
                    Icons.home_rounded,
                    color: _selectedIndex == 0
                        ? Colors.white
                        : Colors.white70,
                    size: 30,
                  ),

                  onPressed: () {
                    setState(
                        () => _selectedIndex = 0);
                  },
                ),

                // TODAY TASK
                IconButton(
                  icon: Icon(
                    Icons.calendar_today_rounded,
                    color: _selectedIndex == 1
                        ? Colors.white
                        : Colors.white70,
                    size: 28,
                  ),

                  onPressed: () {
                    setState(
                        () => _selectedIndex = 1);
                  },
                ),

                // SPACE FOR FAB
                const SizedBox(width: 45),

                // NOTIFICATIONS
                IconButton(
                  icon: Icon(
                    Icons.notifications_rounded,
                    color: _selectedIndex == 2
                        ? Colors.white
                        : Colors.white70,
                    size: 30,
                  ),

                  onPressed: () {
                    setState(
                        () => _selectedIndex = 2);
                  },
                ),

                // PROFILE
                IconButton(
                  icon: Icon(
                    Icons.person_rounded,
                    color: _selectedIndex == 3
                        ? Colors.white
                        : Colors.white70,
                    size: 30,
                  ),

                  onPressed: () {
                    setState(
                        () => _selectedIndex = 3);
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

// ================= TASK CARD =================
class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color1;
  final Color color2;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(28),

        gradient: LinearGradient(
          colors: [
            color1.withOpacity(0.9),
            color2.withOpacity(0.9),
          ],
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            style: TextStyle(
              color:
                  Colors.white.withOpacity(0.8),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}