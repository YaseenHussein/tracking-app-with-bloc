import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tracking_app_with_cubit/cubit/cubit/map_cubit.dart';
import 'package:tracking_app_with_cubit/utils/my_bloc_observer.dart';
import 'package:tracking_app_with_cubit/views/map_view.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit()..initialCubit(),
      child: const MaterialApp(
        home: MapView(),
      ),
    );
  }
}
