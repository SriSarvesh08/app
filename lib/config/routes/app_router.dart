import 'package:flutter/material.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/aptitude/aptitude_screen.dart';
import '../../features/aptitude/topic_detail_screen.dart';
import '../../features/reasoning/reasoning_screen.dart';
import '../../features/verbal/verbal_screen.dart';
import '../../features/current_affairs/current_affairs_screen.dart';
import '../../features/mock_test/mock_test_screen.dart';
import '../../features/mock_test/test_result_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/pdf_assistant/pdf_assistant_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/bookmarks/bookmarks_screen.dart';
import '../../features/general_studies/general_studies_screen.dart';
import '../../features/achievements/achievements_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String chat = '/chat';
  static const String aptitude = '/aptitude';
  static const String topicDetail = '/topic-detail';
  static const String reasoning = '/reasoning';
  static const String verbal = '/verbal';
  static const String currentAffairs = '/current-affairs';
  static const String mockTest = '/mock-test';
  static const String testResult = '/test-result';
  static const String progress = '/progress';
  static const String pdfAssistant = '/pdf-assistant';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';
  static const String bookmarks = '/bookmarks';
  static const String generalStudies = '/general-studies';
  static const String achievements = '/achievements';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), routeSettings);
      case login:
        return _buildRoute(const LoginScreen(), routeSettings);
      case register:
        return _buildRoute(const RegisterScreen(), routeSettings);
      case dashboard:
        return _buildRoute(const DashboardScreen(), routeSettings);
      case chat:
        return _buildRoute(const ChatScreen(), routeSettings);
      case aptitude:
        return _buildRoute(const AptitudeScreen(), routeSettings);
      case topicDetail:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return _buildRoute(
          TopicDetailScreen(
            category: args['category'] as String,
            topic: args['topic'] as String,
            color: args['color'] as Color,
          ),
          routeSettings,
        );
      case reasoning:
        return _buildRoute(const ReasoningScreen(), routeSettings);
      case verbal:
        return _buildRoute(const VerbalScreen(), routeSettings);
      case currentAffairs:
        return _buildRoute(const CurrentAffairsScreen(), routeSettings);
      case mockTest:
        return _buildRoute(const MockTestScreen(), routeSettings);
      case testResult:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return _buildRoute(
          TestResultScreen(results: args),
          routeSettings,
        );
      case progress:
        return _buildRoute(const ProgressScreen(), routeSettings);
      case pdfAssistant:
        return _buildRoute(const PdfAssistantScreen(), routeSettings);
      case settings:
        return _buildRoute(const SettingsScreen(), routeSettings);
      case onboarding:
        return _buildRoute(const OnboardingScreen(), routeSettings);
      case bookmarks:
        return _buildRoute(const BookmarksScreen(), routeSettings);
      case generalStudies:
        return _buildRoute(const GeneralStudiesScreen(), routeSettings);
      case achievements:
        return _buildRoute(const AchievementsScreen(), routeSettings);
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
          routeSettings,
        );
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
