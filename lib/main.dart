import 'dart:async';
// trigger rebuild

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart' as ble;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:opus_flutter/opus_flutter.dart' as opus_flutter;
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:openpocket/backend/http/shared.dart';
import 'package:openpocket/backend/preferences.dart';
import 'package:openpocket/core/app_shell.dart';
import 'package:openpocket/env/dev_env.dart';
import 'package:openpocket/env/env.dart';
import 'package:openpocket/env/prod_env.dart';
import 'package:openpocket/flavors.dart';
import 'package:openpocket/l10n/app_localizations.dart';
import 'package:openpocket/pages/apps/providers/add_app_provider.dart';
import 'package:openpocket/pages/conversation_detail/conversation_detail_provider.dart';
import 'package:openpocket/pages/persona/persona_provider.dart';
import 'package:openpocket/pages/settings/ai_app_generator_provider.dart';
import 'package:openpocket/providers/action_items_provider.dart';
import 'package:openpocket/providers/app_provider.dart';
import 'package:openpocket/providers/auth_provider.dart';
import 'package:openpocket/providers/capture_provider.dart';
import 'package:openpocket/providers/connectivity_provider.dart';
import 'package:openpocket/providers/conversation_provider.dart';
import 'package:openpocket/providers/developer_mode_provider.dart';
import 'package:openpocket/providers/device_provider.dart';
import 'package:openpocket/providers/folder_provider.dart';
import 'package:openpocket/providers/goals_provider.dart';
import 'package:openpocket/providers/home_provider.dart';
import 'package:openpocket/providers/locale_provider.dart';
import 'package:openpocket/providers/memories_provider.dart';
import 'package:openpocket/providers/message_provider.dart';
import 'package:openpocket/providers/onboarding_provider.dart';
import 'package:openpocket/providers/people_provider.dart';
import 'package:openpocket/providers/speech_profile_provider.dart';
import 'package:openpocket/providers/announcement_provider.dart';
import 'package:openpocket/providers/calendar_provider.dart';
import 'package:openpocket/providers/integration_provider.dart';
import 'package:openpocket/providers/sync_provider.dart';
import 'package:openpocket/providers/task_integration_provider.dart';
import 'package:openpocket/providers/usage_provider.dart';
import 'package:openpocket/providers/user_provider.dart';
import 'package:openpocket/providers/voice_recorder_provider.dart';
import 'package:openpocket/services/auth_service.dart';
import 'package:openpocket/services/local_storage_service.dart';
import 'package:openpocket/services/notifications.dart';
import 'package:openpocket/services/services.dart';
import 'package:openpocket/utils/debug_log_manager.dart';
import 'package:openpocket/utils/enums.dart';
import 'package:openpocket/utils/l10n_extensions.dart';
import 'package:openpocket/utils/environment_detector.dart';
import 'package:openpocket/pages/settings/developer.dart';
import 'package:openpocket/utils/logger.dart';
import 'package:openpocket/utils/platform/platform_manager.dart';
import 'package:openpocket/utils/platform/platform_service.dart';

Future _init() async {
  // Env
  if (PlatformService.isWindows) {
    // Windows does not support flavors`
    Env.init(ProdEnv());
  } else {
    if (F.env == Environment.prod) {
      Env.init(ProdEnv());
    } else {
      Env.init(DevEnv());
    }
  }

  // Local storage (Hive)
  await LocalStorageService.instance.init();

  FlutterForegroundTask.initCommunicationPort();

  // Service manager
  await ServiceManager.init();

  await PlatformManager.initializeServices();
  await NotificationService.instance.initialize();

  await SharedPreferencesUtil.init();

  // TestFlight environment detection — must be after SharedPreferencesUtil.init()
  if (F.env == Environment.prod) {
    final isTestFlight = await EnvironmentDetector.isTestFlight();
    if (isTestFlight) {
      Env.isTestFlight = true;
      if (SharedPreferencesUtil().testFlightUseStagingApi) {
        Env.overrideApiBaseUrl(Env.stagingApiUrl);
        debugPrint('TestFlight detected: using staging backend (${Env.stagingApiUrl})');
      } else {
        debugPrint('TestFlight detected: user chose production backend');
      }
    }
  }

  bool isAuth = (await AuthService.instance.getIdToken()) != null;
  if (isAuth) {
    PlatformManager.instance.mixpanel.identify();
    if (!SharedPreferencesUtil().onboardingCompleted) {
      await AuthService.instance.restoreOnboardingState();
    }
  }
  if (PlatformService.isMobile) initOpus(await opus_flutter.load());
  if (!PlatformService.isWindows) {
    ble.FlutterBluePlus.setOptions(restoreState: true);
    ble.FlutterBluePlus.setLogLevel(ble.LogLevel.info, color: true);
  }

  await ServiceManager.instance().start();
  return;
}

void main() {
  runZonedGuarded(
    () async {
      // Ensure
      if (kDebugMode) {
        MarionetteBinding.ensureInitialized();
      } else {
        WidgetsFlutterBinding.ensureInitialized();
      }
      await _init();
      runApp(const MyApp());
    },
    (error, stack) {
      debugPrint('Uncaught error: $error\n$stack');
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;

  // The navigator key is necessary to navigate using static methods
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    NotificationUtil.initializeNotificationsEventListeners();
    NotificationUtil.initializeIsolateReceivePort();
    WidgetsBinding.instance.addObserver(this);
    if (SharedPreferencesUtil().devLogsToFileEnabled) {
      DebugLogManager.setEnabled(true);
    }

    super.initState();
  }

  void _deinit() {
    Logger.debug("App > _deinit");
    ServiceManager.instance().deinit();
    ApiClient.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _onAppPaused();
    } else if (state == AppLifecycleState.detached) {
      _deinit();
    }
  }

  void _onAppPaused() {
    imageCache.clear();
    imageCache.clearLiveImages();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => ConversationProvider()),
        ListenableProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => PeopleProvider()),
        ChangeNotifierProvider(create: (context) => UsageProvider()),
        ChangeNotifierProxyProvider<AppProvider, MessageProvider>(
          create: (context) => MessageProvider(),
          update: (BuildContext context, value, MessageProvider? previous) =>
              (previous?..updateAppProvider(value)) ?? MessageProvider(),
        ),
        ChangeNotifierProxyProvider4<ConversationProvider, MessageProvider, PeopleProvider, UsageProvider,
            CaptureProvider>(
          create: (context) => CaptureProvider(),
          update: (BuildContext context, conversation, message, people, usage, CaptureProvider? previous) =>
              (previous?..updateProviderInstances(conversation, message, people, usage)) ?? CaptureProvider(),
        ),
        ChangeNotifierProxyProvider<CaptureProvider, DeviceProvider>(
          create: (context) => DeviceProvider(),
          update: (BuildContext context, captureProvider, DeviceProvider? previous) =>
              (previous?..setProviders(captureProvider)) ?? DeviceProvider(),
        ),
        ChangeNotifierProxyProvider<DeviceProvider, OnboardingProvider>(
          create: (context) => OnboardingProvider(),
          update: (BuildContext context, value, OnboardingProvider? previous) =>
              (previous?..setDeviceProvider(value)) ?? OnboardingProvider(),
        ),
        ListenableProvider(create: (context) => HomeProvider()),
        ChangeNotifierProxyProvider<DeviceProvider, SpeechProfileProvider>(
          create: (context) => SpeechProfileProvider(),
          update: (BuildContext context, device, SpeechProfileProvider? previous) =>
              (previous?..setProviders(device)) ?? SpeechProfileProvider(),
        ),
        ChangeNotifierProxyProvider2<AppProvider, ConversationProvider, ConversationDetailProvider>(
          create: (context) => ConversationDetailProvider(),
          update: (BuildContext context, app, conversation, ConversationDetailProvider? previous) =>
              (previous?..setProviders(app, conversation)) ?? ConversationDetailProvider(),
        ),
        ChangeNotifierProvider(create: (context) => DeveloperModeProvider()..initialize()),
        ChangeNotifierProxyProvider<AppProvider, AddAppProvider>(
          create: (context) => AddAppProvider(),
          update: (BuildContext context, value, AddAppProvider? previous) =>
              (previous?..setAppProvider(value)) ?? AddAppProvider(),
        ),
        ChangeNotifierProxyProvider<AppProvider, AiAppGeneratorProvider>(
          create: (context) => AiAppGeneratorProvider(),
          update: (BuildContext context, value, AiAppGeneratorProvider? previous) =>
              (previous?..setAppProvider(value)) ?? AiAppGeneratorProvider(),
        ),
        ChangeNotifierProvider(create: (context) => PersonaProvider()),
        ChangeNotifierProxyProvider<ConnectivityProvider, MemoriesProvider>(
          create: (context) => MemoriesProvider(),
          update: (context, connectivity, previous) =>
              (previous?..setConnectivityProvider(connectivity)) ?? MemoriesProvider(),
        ),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ActionItemsProvider()),
        ChangeNotifierProvider(create: (context) => GoalsProvider()..init()),
        ChangeNotifierProvider(create: (context) => TaskIntegrationProvider()),
        ChangeNotifierProvider(create: (context) => FolderProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => VoiceRecorderProvider()),
        ChangeNotifierProvider(create: (context) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (context) => SyncProvider()),
        ChangeNotifierProvider(create: (context) => IntegrationProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider(), lazy: false),
      ],
      builder: (context, child) {
        return WithForegroundTask(
          child: MaterialApp(
            debugShowCheckedModeBanner: F.env == Environment.dev,
            title: F.title,
            navigatorKey: MyApp.navigatorKey,
            locale: context.watch<LocaleProvider>().locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              useMaterial3: false,
              colorScheme: const ColorScheme.dark(
                primary: Colors.black,
                secondary: Colors.deepPurple,
                surface: Colors.black38,
              ),
              snackBarTheme: const SnackBarThemeData(
                backgroundColor: Color(0xFF1F1F25),
                contentTextStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              textTheme: TextTheme(
                titleLarge: const TextStyle(fontSize: 18, color: Colors.white),
                titleMedium: const TextStyle(fontSize: 16, color: Colors.white),
                bodyMedium: const TextStyle(fontSize: 14, color: Colors.white),
                labelMedium: TextStyle(fontSize: 12, color: Colors.grey.shade200),
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.white,
                selectionColor: Colors.deepPurple,
                selectionHandleColor: Colors.white,
              ),
              cupertinoOverrideTheme: const CupertinoThemeData(
                primaryColor: Colors.white, // Controls the selection handles on iOS
              ),
            ),
            themeMode: ThemeMode.dark,
            builder: (context, child) {
              FlutterError.onError = (FlutterErrorDetails details) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Logger.instance.talker.handle(details.exception, details.stack);
                  DebugLogManager.logError(details.exception, details.stack, 'FlutterError');
                });
              };
              ErrorWidget.builder = (errorDetails) {
                return CustomErrorWidget(errorMessage: errorDetails.exceptionAsString());
              };
              if (Env.isUsingStagingApi) {
                final topPadding = MediaQuery.of(context).padding.top;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        MyApp.navigatorKey.currentState?.push(
                          MaterialPageRoute(builder: (context) => const DeveloperSettingsPage()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: topPadding + 4, bottom: 4),
                        color: Colors.orange.shade800,
                        child: Text(
                          context.l10n.staging.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: child!,
                      ),
                    ),
                  ],
                );
              }
              return child!;
            },
            home: TalkerWrapper(
              talker: Logger.instance.talker,
              options: const TalkerWrapperOptions(enableErrorAlerts: false, enableExceptionAlerts: false),
              child: const AppShell(),
            ),
          ),
        );
      },
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;

  const CustomErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50.0),
            const SizedBox(height: 10.0),
            Text(
              context.l10n.somethingWentWrong,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 63, 63, 63),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(errorMessage, textAlign: TextAlign.start, style: const TextStyle(fontSize: 16.0)),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: 210,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: errorMessage));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.errorCopied)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(context.l10n.copyErrorMessage),
                    const SizedBox(width: 10),
                    const Icon(Icons.copy_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}