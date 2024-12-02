import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/features/auth/screens/login_screen.dart';
import 'package:kyn_2/core/common/error_text.dart';
import 'package:kyn_2/core/common/loader.dart';
import 'package:kyn_2/core/navigation/navigation.dart';
import 'package:kyn_2/core/theme/theme.dart';
import 'package:kyn_2/firebase_options.dart';
import 'package:kyn_2/models/user_model.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  Future<void> getData(WidgetRef ref, User data) async {
    userModel = await ref
        .read(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KYN',
      theme: ref.watch(themeNotifierProvider),
      home: ref.watch(authStateChangeProvider).when(
            data: (user) {
              if (user != null) {
                if (userModel == null) {
                  getData(ref, user);
                }
                return const Navigation();
              }
              return const LoginPage();
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => Loader(
              color: Colors.red,
            ),
          ),
    );
  }
}
