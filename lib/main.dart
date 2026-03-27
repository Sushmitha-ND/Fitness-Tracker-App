import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const FitLifeApp());
}

// Simple Data Model to persist info during the session
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

class FitLifeApp extends StatelessWidget {
  const FitLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLife',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/welcome': (context) => const WelcomePage(),
        '/details': (context) => const UserDetailsPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/progress': (context) => const ProgressPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

// --- 1. Login Page ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fitness_center,
              size: 80,
              color: Colors.deepPurple,
            ),
            const Text(
              "FitLife",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                UserProfile().username = _userController.text;
                UserProfile().email = _emailController.text;
                Navigator.pushNamed(context, '/welcome');
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. Welcome Page (Updated with Background Image & Fixes) ---
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Welcome", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/fit.jpg', // Ensure this matches your folder exactly
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.deepPurple),
            ),
          ),
          // Dark Overlay using updated API
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(
                alpha: 0.5,
              ), // FIXED: withValues replaces withOpacity
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    "Your Journey Starts Here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "FitLife helps you track workouts, yoga, and daily progress to reach your peak performance.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/details'),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. User Details Page ---
class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Details")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Age"),
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: "Weight (kg)"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                UserProfile().age = _ageController.text;
                UserProfile().weight = _weightController.text;
                Navigator.pushNamed(context, '/dashboard');
              },
              child: const Text("Save & Go to Dashboard"),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. Dashboard (with Timer) ---
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
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      appBar: AppBar(title: const Text("FitLife Dashboard")),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Progress"),
              onTap: () => Navigator.pushNamed(context, '/progress'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Hello, ${UserProfile().username}!",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _activityCard("Yoga", Icons.self_improvement, Colors.green),
                _activityCard("Exercise", Icons.fitness_center, Colors.orange),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Workout Timer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Text(
                "$_seconds s",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _toggleTimer,
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(_isRunning ? "Pause Workout" : "Start Workout"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/progress'),
              child: const Text("View Progress Report"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// --- 5. Progress Page ---
class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weekly Progress")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Performance Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text("Daily Goal: 80%"),
            LinearProgressIndicator(
              value: 0.8,
              minHeight: 10,
              color: Colors.green,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            const Text("Weekly Goal: 75%"),
            LinearProgressIndicator(
              value: UserProfile().weeklyProgress,
              minHeight: 10,
              color: Colors.deepPurple,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text("Keep it up! You are doing great this week."),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 6. Profile Page ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserProfile();
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text("Username"),
            subtitle: Text(user.username),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("Email"),
            subtitle: Text(user.email),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text("Age"),
            subtitle: Text("${user.age} years"),
          ),
          ListTile(
            leading: const Icon(Icons.monitor_weight),
            title: const Text("Weight"),
            subtitle: Text("${user.weight} kg"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Back to Dashboard"),
          ),
        ],
      ),
    );
  }
}
