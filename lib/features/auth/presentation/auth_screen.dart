import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../application/auth_controller.dart';
import '../application/auth_state.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  int _signUpStep = 0;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _hospitalCtrl = TextEditingController();
  final _regionCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  String? _selectedRole;
  bool _obscurePassword = true;

  static const _roles = [
    'Doctor',
    'Nurse',
    'Health Assistant',
    'Other',
  ];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _hospitalCtrl.dispose();
    _regionCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _signUpStep = 0;
      _obscurePassword = true;
    });
    ref.read(authControllerProvider.notifier).reset();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ctrl = ref.read(authControllerProvider.notifier);

    if (_isSignUp) {
      if (_signUpStep == 0) {
        setState(() => _signUpStep = 1);
        return;
      }
      await ctrl.signUp(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        name: _nameCtrl.text.trim(),
        role: _selectedRole!,
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        hospital:
            _hospitalCtrl.text.trim().isEmpty ? null : _hospitalCtrl.text.trim(),
        region:
            _regionCtrl.text.trim().isEmpty ? null : _regionCtrl.text.trim(),
        country:
            _countryCtrl.text.trim().isEmpty ? null : _countryCtrl.text.trim(),
      );
    } else {
      await ctrl.signIn(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final cs = Theme.of(context).colorScheme;

    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      if (next is AuthSuccess) {
        if (context.mounted) context.go('/${Routes.home}');
      } else if (next is AuthSignUpSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created! Please verify your email.'),
          ),
        );
        setState(() {
          _isSignUp = false;
          _signUpStep = 0;
        });
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: _isSignUp ? _buildSignUpBody(authState) : _buildSignInBody(authState),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required String title,
    required String subtitle,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/images/img_splash.png',
            height: 64,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInBody(AuthState authState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(
          title: 'Welcome Back',
          subtitle: 'Sign in to continue to Neuroscan',
        ),
        const SizedBox(height: 32),
        _buildTextField(
          controller: _emailCtrl,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Email is required';
            if (!v.contains('@')) return 'Enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _passwordCtrl,
          label: 'Password',
          icon: Icons.lock_outlined,
          obscure: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Password is required';
            if (v.length < 6) return 'At least 6 characters';
            return null;
          },
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Sign In',
          isLoading: authState is AuthLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              if (_emailCtrl.text.isNotEmpty) {
                ref
                    .read(authControllerProvider.notifier)
                    .resetPassword(_emailCtrl.text.trim());
              }
            },
            child: const Text('Forgot password?'),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: _toggleMode,
            child: const Text("Don't have an account? Sign Up"),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBody(AuthState authState) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_signUpStep == 0) ...[
          _buildHeader(
            title: 'Create Account',
            subtitle: 'Step 1 of 2: Set credentials',
          ),
          const SizedBox(height: 32),
          _buildTextField(
            controller: _emailCtrl,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordCtrl,
            label: 'Password',
            icon: Icons.lock_outlined,
            obscure: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'At least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Role',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              labelStyle: TextStyle(
                color: cs.onSurfaceVariant,
                textBaseline: TextBaseline.alphabetic,
              ),
              prefixIcon: Icon(Icons.work_outline, color: cs.onSurfaceVariant),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: cs.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: cs.primary, width: 2),
              ),
              filled: true,
              fillColor: cs.surface,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedRole ?? _roles.first,
                isDense: true,
                items: _roles
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedRole = v),
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Continue to Step 2',
            isLoading: authState is AuthLoading,
            onPressed: _submit,
          ),
        ] else ...[
          _buildHeader(
            title: 'Additional Info',
            subtitle: 'Step 2 of 2: Profile details',
          ),
          const SizedBox(height: 32),
          _buildTextField(
            controller: _nameCtrl,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (v) =>
                v == null || v.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _hospitalCtrl,
            label: 'Hospital',
            icon: Icons.local_hospital_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneCtrl,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _regionCtrl,
            label: 'Region',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _countryCtrl,
            label: 'Country',
            icon: Icons.public_outlined,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _signUpStep = 0),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: BorderSide(color: cs.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: TextStyle(color: cs.onSurface),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  label: 'Sign Up',
                  isLoading: authState is AuthLoading,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _toggleMode,
            child: const Text('Already have an account? Sign In'),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: cs.onSurfaceVariant, textBaseline: TextBaseline.alphabetic),
        prefixIcon: Icon(icon, color: cs.onSurfaceVariant),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        filled: true,
        fillColor: cs.surface,
      ),
    );
  }
}
