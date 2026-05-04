import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/graphql_client.dart';
import 'features/pokedex/pokemon_bloc.dart';
import 'features/pokedex/list_screen.dart';

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
        create: (_) => PokemonBloc(client: GraphqlClient())..add(const PokemonListRequested()),
        child: const PokemonListScreen(),
      ),
    );
  }
}
