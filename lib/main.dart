import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Core/di/service_locator.dart';
import 'Core/routes/route_generator.dart';
import 'Core/routes/routes.dart';
import 'Core/utils/bloc_observer.dart';
import 'Features/auth/presentation/view_model/cubit/auth_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: MaterialApp(
        onGenerateRoute: RouteGenerator.getRoute,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splash,
      ),
    );
  }
}
