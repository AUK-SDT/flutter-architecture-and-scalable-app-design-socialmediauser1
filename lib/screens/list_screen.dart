import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_event.dart';
import '../bloc/pokemon_state.dart';
import '../models/pokemon.dart';
import 'detail_screen.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoading || state is PokemonInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PokemonError) {
            return _ErrorView(message: state.message);
          }

          if (state is PokemonLoaded) {
            return _LoadedView(pokemonList: state.pokemonList);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final List<Pokemon> pokemonList;

  const _LoadedView({required this.pokemonList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        final pokemon = pokemonList[index];
        return PokemonListTile(
          pokemon: pokemon,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PokemonDetailScreen(pokemon: pokemon),
              ),
            );
          },
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to load Pokémon',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context
                  .read<PokemonBloc>()
                  .add(const PokemonListRetryRequested()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class PokemonListTile extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;

  const PokemonListTile({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: pokemon.sprite.isNotEmpty
            ? Image.network(
                pokemon.sprite,
                width: 56,
                height: 56,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.catching_pokemon, size: 40),
              )
            : const Icon(Icons.catching_pokemon, size: 40),
        title: Text(
          pokemon.species[0].toUpperCase() + pokemon.species.substring(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: pokemon.types.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Chip(
                label: Text(type, style: const TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                backgroundColor: typeColor(type),
              ),
            );
          }).toList(),
        ),
        trailing: Text(
          '#${pokemon.dexNumber}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: onTap,
      ),
    );
  }

  Color typeColor(String type) {
    const colors = {
      'Normal': Color(0xFFA8A878),
      'Fire': Color(0xFFF08030),
      'Water': Color(0xFF6890F0),
      'Electric': Color(0xFFF8D030),
      'Grass': Color(0xFF78C850),
      'Ice': Color(0xFF98D8D8),
      'Fighting': Color(0xFFC03028),
      'Poison': Color(0xFFA040A0),
      'Ground': Color(0xFFE0C068),
      'Flying': Color(0xFFA890F0),
      'Psychic': Color(0xFFF85888),
      'Bug': Color(0xFFA8B820),
      'Rock': Color(0xFFB8A038),
      'Ghost': Color(0xFF705898),
      'Dragon': Color(0xFF7038F8),
      'Dark': Color(0xFF705848),
      'Steel': Color(0xFFB8B8D0),
      'Fairy': Color(0xFFEE99AC),
    };
    return colors[type] ?? Colors.grey;
  }
}
