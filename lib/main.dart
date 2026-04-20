import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/pokemon_bloc.dart';
import 'bloc/pokemon_event.dart';
import 'screens/list_screen.dart';
import 'services/pokemon_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) =>
            PokemonBloc(service: PokemonService())
              ..add(const PokemonListRequested()),
        child: const PokemonListScreen(),
      ),
    );
  }
}
