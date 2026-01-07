import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colours.dart'; // Import your colors
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    await context.read<AuthProvider>().signUp(email, password, name);

    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? "Signup failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight, // Use AppColors
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. LOGO
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primarySubtle.withValues(alpha:0.3), // primarySubtle with opacity
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.spa, color: AppColors.primary, size: 36),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Create Your Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain, // Use AppColors
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Join HealthyHabits today!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary, // Use AppColors
                  ),
                ),
                const SizedBox(height: 32),

                // 2. FORM FIELDS
                _buildLabel("Full Name"),
                TextField(
                  controller: _nameController,
                  decoration: _buildInputDecoration("Enter your full name", Icons.person),
                ),
                const SizedBox(height: 16),

                _buildLabel("Email Address"),
                TextField(
                  controller: _emailController,
                  decoration: _buildInputDecoration("Enter your email address", Icons.mail),
                ),
                const SizedBox(height: 16),

                _buildLabel("Password"),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _buildInputDecoration("Enter your password", Icons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 3. TERMS
                const Text.rich(
                  TextSpan(
                    text: "By signing up, you agree to our ",
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    children: [
                      TextSpan(
                        text: "Terms of Service",
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                      ),
                      TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                      ),
                      TextSpan(text: "."),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // 4. SIGN UP BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 4,
                      shadowColor: AppColors.primary.withValues(alpha:0.3),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                // 5. LOGIN LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ", style: TextStyle(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Log In", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textMain),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.placeholderLight),
      filled: true,
      fillColor: AppColors.inputBgLight,
      prefixIcon: Icon(icon, color: AppColors.placeholderLight),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
    );
  }
}