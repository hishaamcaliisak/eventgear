import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme/tokens.dart';
import 'screens/welcome_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/onboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/list_screen.dart';
import 'screens/item_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/request_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/confirmed_screen.dart';
import 'screens/checklist_screen.dart';
import 'screens/history_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/inbox_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/owner_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/payment_methods_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/help_screen.dart';
import 'widgets/floating_tab_bar.dart';
import 'widgets/toast_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const EventGearApp(),
    ),
  );
}

class EventGearApp extends StatelessWidget {
  const EventGearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventGear',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTokens.brand),
        scaffoldBackgroundColor: AppTokens.bg,
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _mainScreens = {'home', 'list', 'favorites', 'history', 'inbox', 'profile', 'owner', 'map', 'rewards'};
  // Tab order for directional swipe
  static const _tabOrder = ['home', 'browse', 'bookings', 'inbox', 'profile'];
  // Map tab → screen for direction lookup
  static const _tabScreens = {'home': 'home', 'browse': 'list', 'bookings': 'history', 'inbox': 'inbox', 'profile': 'profile'};

  String _prevTab = 'home';
  String _prevScreen = 'welcome';

  static Widget _buildScreen(String screen) {
    switch (screen) {
      case 'welcome':         return const WelcomeScreen();
      case 'signin':          return const SignInScreen();
      case 'onboard':         return const OnboardScreen();
      case 'home':            return const HomeScreen();
      case 'list':            return const ListScreen();
      case 'item':            return const ItemScreen();
      case 'reviews':         return const ReviewsScreen();
      case 'calendar':        return const CalendarScreen();
      case 'request':         return const RequestScreen();
      case 'payment':         return const PaymentScreen();
      case 'confirmed':       return const ConfirmedScreen();
      case 'checklist':       return const ChecklistScreen();
      case 'history':         return const HistoryScreen();
      case 'rewards':         return const RewardsScreen();
      case 'inbox':           return const InboxScreen();
      case 'chat':            return const ChatScreen();
      case 'ai_chat':         return const AiChatScreen();
      case 'payment_methods': return const PaymentMethodsScreen();
      case 'notifications':   return const NotificationsScreen();
      case 'help':            return const HelpScreen();
      case 'favorites':       return const FavoritesScreen();
      case 'map':             return const MapScreen();
      case 'profile':         return const ProfileScreen();
      case 'owner':           return const OwnerScreen();
      default:                return const WelcomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final screen = state.screen;
    final tab    = state.tab;
    final showTabBar = _mainScreens.contains(screen);

    // Determine slide direction: positive = slide in from right, negative = from left
    final prevIdx = _tabOrder.indexOf(_prevTab);
    final currIdx = _tabOrder.indexOf(tab);
    final isTabSwitch = _tabScreens.values.contains(screen) && _tabScreens.values.contains(_prevScreen);
    final slideDir = (isTabSwitch && prevIdx >= 0 && currIdx >= 0)
        ? (currIdx > prevIdx ? 1.0 : -1.0)
        : 0.0; // push/pop: slide up from bottom

    // Track for next transition
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prevTab    = tab;
      _prevScreen = screen;
    });

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 380),
            transitionBuilder: (child, anim) {
              // Incoming screen
              final isIncoming = child.key == ValueKey(screen);

              final spring = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
              final fade   = CurvedAnimation(parent: anim, curve: const Interval(0.0, 0.55, curve: Curves.easeOut));

              if (slideDir != 0.0) {
                // Horizontal tab switch
                final inOffset  = isIncoming ? Offset(slideDir * 0.22, 0) : Offset(-slideDir * 0.22, 0);
                final slide = Tween<Offset>(begin: inOffset, end: Offset.zero).animate(spring);
                return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
              } else {
                // Push/pop: scale + fade + tiny rise
                final scale = Tween<double>(begin: isIncoming ? 0.94 : 1.0, end: 1.0).animate(spring);
                final rise  = Tween<Offset>(begin: isIncoming ? const Offset(0, 0.025) : Offset.zero, end: Offset.zero).animate(spring);
                return FadeTransition(
                  opacity: fade,
                  child: ScaleTransition(scale: scale, child: SlideTransition(position: rise, child: child)));
              }
            },
            child: KeyedSubtree(
              key: ValueKey(screen),
              child: _buildScreen(screen),
            ),
          ),
          if (showTabBar) const FloatingTabBar(),
          if (state.toast.isNotEmpty) ToastOverlay(key: ValueKey(state.toast), message: state.toast),
        ],
      ),
    );
  }
}
