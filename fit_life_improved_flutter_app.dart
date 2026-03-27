// IMPROVED FITLIFE APP (MODERN UI + ANIMATIONS + CLEAN DESIGN)

import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const FitLifeApp());
}

// ---------------- USER MODEL ----------------
class UserProfile {
  static final UserProfile _instance = UserProfile._internal();
  factory UserProfile() => _instance;
  UserProfile._internal();

  String username = "";
  String email = "";
  String age = "";
  String weight = "";

  double weeklyProgress = 0.75;
}

// ---------------- APP ----------------
class FitLifeApp extends StatelessWidget {
  const FitLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/': (_) => const LoginPage(),
        '/dashboard': (_) => const DashboardPage(),
      },
    );
  }
}

// ---------------- LOGIN PAGE (WITH ANIMATION) ----------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fitness_center,
                  size: 90, color: Colors.deepPurple),
              const SizedBox(height: 10),
              const Text("FitLife",
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              _inputField(_userController, "Username"),
              const SizedBox(height: 10),
              _inputField(_emailController, "Email"),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  UserProfile().username = _userController.text;
                  Navigator.pushNamed(context, '/dashboard');
                },
                child: const Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ---------------- DASHBOARD ----------------
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _seconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() => _seconds++);
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, ${UserProfile().username}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            // PROGRESS BAR
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Weekly Progress"),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: UserProfile().weeklyProgress,
                  color: Colors.deepPurple,
                  backgroundColor: Colors.deepPurple.shade100,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // CARDS WITH ANIMATION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _animatedCard("Yoga", Icons.self_improvement),
                _animatedCard("Workout", Icons.fitness_center),
              ],
            ),

            const SizedBox(height: 30),

            // TIMER UI
            Center(
              child: Column(
                children: [
                  const Text("Workout Timer"),
                  const SizedBox(height: 10),
                  Text("$_seconds s",
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    backgroundColor: Colors.deepPurple,
                    onPressed: _toggleTimer,
                    child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _animatedCard(String title, IconData icon) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
