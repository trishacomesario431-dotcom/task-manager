import 'package:flutter/material.dart';
import 'task_data.dart';

class CategoryScreen extends StatefulWidget {
  final String title;
  final Color color;
  final IconData icon;

  const CategoryScreen({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  State<CategoryScreen> createState() =>
      _CategoryScreenState();
}

class _CategoryScreenState
    extends State<CategoryScreen> {

  @override
  Widget build(BuildContext context) {

    final tasks = allTasks
        .where(
          (task) =>
              task.category == widget.title,
        )
        .toList();

    return Scaffold(
      backgroundColor: widget.color,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: tasks.isEmpty
            ? const Center(
                child: Text(
                  "No tasks yet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )

            : ListView.builder(
                itemCount: tasks.length,

                itemBuilder: (context, index) {

                  return Container(
                    margin:
                        const EdgeInsets.only(
                            bottom: 15),

                    padding:
                        const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(
                              0.2),

                      borderRadius:
                          BorderRadius.circular(
                              20),
                    ),

                    child: Row(
                      children: [

                        Icon(
                          widget.icon,
                          color: Colors.white,
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            tasks[index].title,

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}