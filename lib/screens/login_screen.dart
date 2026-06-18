import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/theme.dart';
import '../widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isAuthenticated) {
        _redirect(userProvider);
      }
    });
  }

  void _redirect(UserProvider userProvider) {
    if (userProvider.user == null) {
      Navigator.pushReplacementNamed(context, '/register');
    } else {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top whitespace to push logo to ~40% down
              const Spacer(flex: 3),

              // Achievement Loop Ribbon Logo
              Center(
                child: CustomPaint(
                  size: const Size(96, 96),
                  painter: _AchievementLoopPainter(),
                ),
              ),
              const SizedBox(height: 28),

              // VerifyU wordmark
              RichText(
                text: TextSpan(
                  style: AppTheme.headingStyle(fontSize: 42, fontWeight: FontWeight.w700),
                  children: const [
                    TextSpan(text: "Verify"),
                    TextSpan(text: "U", style: TextStyle(color: AppColors.forest)),
                  ],
                ),
              ),

              // Tagline
              const SizedBox(height: 14),
              Text(
                "Verify achievements. Discover opportunities.",
                textAlign: TextAlign.center,
                style: AppTheme.bodyStyle(
                  fontSize: 15,
                  color: AppColors.tan,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(flex: 4),

              // Google Sign-In & Explainer
              userProvider.isLoading
                  ? const CircularProgressIndicator(color: AppColors.forest)
                  : Column(
                      children: [
                        AppButton(
                          text: "Continue with Google",
                          type: AppButtonType.filledForest,
                          icon: const Icon(Icons.login, color: Colors.white, size: 18),
                          onPressed: () async {
                            final success = await userProvider.signInWithGoogle();
                            if (success) {
                              await Future.delayed(const Duration(milliseconds: 300));
                              _redirect(userProvider);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "We verify your credentials against issuing sources so recruiters never have to ask twice.",
                          textAlign: TextAlign.center,
                          style: AppTheme.bodyStyle(
                            fontSize: 12.5,
                            color: AppColors.tan,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementLoopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.2, h * 0.5);
    path.cubicTo(w * 0.05, h * 0.2, w * 0.35, h * 0.05, w * 0.5, h * 0.5);
    path.cubicTo(w * 0.65, h * 0.95, w * 0.95, h * 0.8, w * 0.8, h * 0.5);
    path.cubicTo(w * 0.65, h * 0.2, w * 0.35, h * 0.95, w * 0.2, h * 0.5);

    paint.shader = const LinearGradient(
      colors: [AppColors.forest, AppColors.gold],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), 5.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
