import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_router.dart';
import '../../widgets/gradient_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  String? _selectedGroup;
  String _errorMessage = '';

  final List<String> _tnpscGroups = [
    'TNPSC Group I',
    'TNPSC Group II / IIA',
    'TNPSC Group III',
    'TNPSC Group IV',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validatePassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  Future<void> _handleRegister() async {
    setState(() => _errorMessage = '');

    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter your name');
      return;
    }
    if (_selectedGroup == null) {
      setState(() => _errorMessage = 'Please select a TNPSC Group');
      return;
    }
    if (!_validatePassword(_passwordController.text)) {
      setState(() {
        _errorMessage = 'Password must be at least 8 characters, include an uppercase letter, and a special symbol.';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text.trim());
    await prefs.setString('user_group', _selectedGroup!);
    await prefs.setBool('is_logged_in', true);
    await prefs.setBool('onboarding_complete', true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D1117), const Color(0xFF161B22)]
                : [AppColors.primaryBlue, const Color(0xFF3949AB)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('🎓', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 16),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your TNPSC preparation journey',
                  style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
                ),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(_errorMessage, style: const TextStyle(color: AppColors.error, fontSize: 13)),
                        ),
                      _label('Full Name', isDark),
                      const SizedBox(height: 8),
                      TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'Enter your name', prefixIcon: Icon(Icons.person_outline))),
                      const SizedBox(height: 20),
                      
                      _label('Target Exam', isDark),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedGroup,
                        hint: const Text('Select TNPSC Group'),
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.school_outlined)),
                        items: _tnpscGroups.map((group) => DropdownMenuItem(value: group, child: Text(group))).toList(),
                        onChanged: (val) => setState(() => _selectedGroup = val),
                      ),
                      const SizedBox(height: 20),

                      _label('Email', isDark),
                      const SizedBox(height: 8),
                      TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Enter your email', prefixIcon: Icon(Icons.email_outlined))),
                      const SizedBox(height: 20),
                      _label('Password', isDark),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Create a password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      GradientButton(
                        text: 'Create Account',
                        icon: Icons.person_add_rounded,
                        gradient: AppColors.primaryGradient,
                        onPressed: _handleRegister,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Login', style: TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w600)),
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

  Widget _label(String text, bool isDark) {
    return Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : AppColors.textPrimary));
  }
}
