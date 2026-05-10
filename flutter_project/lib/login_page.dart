import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'signup_page.dart';
import 'welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMsg("Please enter email and password ❌", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login failed ❌";

      if (e.code == 'user-not-found') {
        message = "No user found with this email";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format";
      } else if (e.code == 'invalid-credential') {
        message = "Invalid email or password";
      }

      showMsg(message, Colors.red);
    } catch (e) {
      showMsg("Something went wrong: $e", Colors.red);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void showMsg(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2A0845)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 40,
              left: 15,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomePage(),
                    ),
                  );
                },
              ),
            ),

            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 70,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 15),

                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          "Login to continue",
                          style: TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 30),

                        _inputField(
                          controller: emailController,
                          hint: "Email",
                          icon: Icons.email,
                          obscure: false,
                        ),

                        const SizedBox(height: 15),

                        _inputField(
                          controller: passwordController,
                          hint: "Password",
                          icon: Icons.lock,
                          obscure: _obscurePassword,
                          isPassword: true,
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Don't have an account? Sign up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required bool obscure,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: hint == "Email"
          ? TextInputType.emailAddress
          : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
    );
  }
}
