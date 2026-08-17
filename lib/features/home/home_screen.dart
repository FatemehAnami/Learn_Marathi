import 'package:flutter/material.dart';

import '../../core/services/progress_service.dart';
import '../course/course_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int xp = 0;
  int hearts = 5;
  int streak = 0;
  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    xp = await ProgressService().getXP();
    hearts = await ProgressService().getHearts();
    streak = await ProgressService().getStreak();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> openCourse() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CourseScreen(),
      ),
    );

    // Refresh XP and Hearts after returning
    await loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn Marathi"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: [

                    Column(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 32,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$hearts",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 32,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$xp XP",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 32,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$streak",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Welcome!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Start learning Marathi one lesson at a time.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: openCourse,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                ),
              ),
              child: const Text(
                "Start Learning",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: () async {
                await ProgressService().resetHearts();
                await ProgressService().resetXP();

                await loadProgress();
              },
              child: const Text("Reset Progress"),
            ),
          ],
        ),
      ),
    );
  }
}