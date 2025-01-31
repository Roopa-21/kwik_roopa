import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/constants/textstyle.dart';
import 'package:kwik/firebase_options.dart';
import 'package:kwik/repositories/home_Ui_repository.dart';
import 'package:kwik/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoRouter _router = router;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeUiBloc>(
            create: (_) => HomeUiBloc(uiRepository: HomeUiRepository()))
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Kwik',
        theme: appTheme(context),
        debugShowCheckedModeBanner: false,
        //  home:
      ),
    );
  }
}
