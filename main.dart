// Importing async package for Timer functionality
import 'dart:async';

// Importing Flutter material design UI package
import 'package:flutter/material.dart';

// Entry point of the application
void main() {
  // runApp starts the Flutter app
  runApp(const FitLifeApp());
}

// ------------------ USER DATA MODEL ------------------
// Singleton class to store user data globally (data persistence during app session)
class UserProfile {
  // Creating a single instance (Singleton pattern)
  static final UserProfile _instance = UserProfile._internal();

  // Factory constructor returns same instance always
  factory UserProfile() => _instance;

  // Private constructor
  UserProfile._internal();

  // User details variables
  String username = "";
  String email = "";
  String age = "";
  String weight = "";

  // Default weekly progress (75%)
  double weeklyProgress = 0.75;
}

// ------------------ MAIN APP ------------------
class FitLifeApp extends StatelessWidget {
  const FitLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title
      title: 'FitLife',

      // Removes debug banner
      debugShowCheckedModeBanner: false,

      // App theme (Material 3 + purple color)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // Initial screen when app starts
      initialRoute: '/',

      // Named routes for navigation
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

// ------------------ 1. LOGIN PAGE ------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to get input from text fields
  final _userController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),

        // Column to arrange widgets vertically
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            const Icon(
              Icons.fitness_center,
              size: 80,
              color: Colors.deepPurple,
            ),

            // App Title
            const Text(
              "FitLife",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Username input
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Email input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Password input (hidden text)
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),

              // When button is pressed
              onPressed: () {
                // Save user input in global model
                UserProfile().username = _userController.text;
                UserProfile().email = _emailController.text;

                // Navigate to Welcome Page
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

// ------------------ 2. WELCOME PAGE ------------------
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allows background to extend under AppBar
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
              'assets/images/fit.jpg',
              fit: BoxFit.cover,

              // If image fails → fallback color
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.deepPurple),
            ),
          ),

          // Dark overlay for better text visibility
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),

          // Main content
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
                    "FitLife helps you track workouts...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),

                  const Spacer(),

                  // Button to go to details page
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),

                    onPressed: () =>
                        Navigator.pushNamed(context, '/details'),

                    child: const Text("Get Started"),
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

// ------------------ 3. USER DETAILS PAGE ------------------
class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  // Controllers for user inputs
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
            // Age input
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Age"),
            ),

            // Weight input
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: "Weight (kg)"),
            ),

            const SizedBox(height: 30),

            // Save button
            ElevatedButton(
              onPressed: () {
                // Store user data
                UserProfile().age = _ageController.text;
                UserProfile().weight = _weightController.text;

                // Navigate to dashboard
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

// ------------------ 4. DASHBOARD ------------------
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _seconds = 0; // Timer value
  Timer? _timer;   // Timer object
  bool _isRunning = false; // Track timer state

  // Function to start/pause timer
  void _toggleTimer() {
    if (_isRunning) {
      // Stop timer
      _timer?.cancel();
    } else {
      // Start timer (runs every second)
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _seconds++);
      });
    }

    // Update UI
    setState(() => _isRunning = !_isRunning);
  }

  // Clean up memory when widget is destroyed
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FitLife Dashboard")),

      // Drawer (side menu)
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text("Menu"),
            ),

            // Navigate to profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),

            // Navigate to progress
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
            // Greeting message
            Text(
              "Hello, ${UserProfile().username}!",
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 20),

            // Activity cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _activityCard("Yoga", Icons.self_improvement, Colors.green),
                _activityCard("Exercise", Icons.fitness_center, Colors.orange),
              ],
            ),

            const SizedBox(height: 30),

            // Timer section
            const Text("Workout Timer"),

            Container(
              padding: const EdgeInsets.all(30),
              child: Text("$_seconds s"),
            ),

            // Start/Pause button
            ElevatedButton.icon(
              onPressed: _toggleTimer,
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(_isRunning ? "Pause" : "Start"),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable card widget
  Widget _activityCard(String title, IconData icon, Color color) {
    return Card(
      child: Column(
        children: [
          Icon(icon, color: color),
          Text(title),
        ],
      ),
    );
  }
}
