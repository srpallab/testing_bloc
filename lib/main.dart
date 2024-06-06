import 'dart:math' as math show Random;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

var names = ['Foo', 'Bar', 'Baz', 'Li', 'Co', 'Hilda', 'Layla'];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NameCubit extends Cubit<String?> {
  NameCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NameCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NameCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: StreamBuilder<String?>(
          stream: cubit.stream,
          builder: (ctx, snapshot) {
            final btn = TextButton(
              onPressed: () => cubit.pickRandomName(),
              child: const Text("Pick a Random Name"),
            );
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return btn;
              case ConnectionState.active:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(snapshot.data ?? ""), btn],
                );
              case ConnectionState.done:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
