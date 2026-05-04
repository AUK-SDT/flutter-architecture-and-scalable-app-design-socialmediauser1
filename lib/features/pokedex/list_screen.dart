import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../comparison/comparison_screen.dart';
import '../../core/type_colors.dart';
import 'pokemon_bloc.dart';
import 'detail_screen.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Compare Pokémon',
            onPressed: () {
              final state = context.read<PokemonBloc>().state;
              if (state is PokemonLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ComparisonScreen(pokemonList: state.pokemonList),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pokémon list is still loading')),
                );
              }
            },
          ),
        ],
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
        return _PokemonListTile(
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
            Text('Failed to load Pokémon', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<PokemonBloc>().add(const PokemonListRetryRequested()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PokemonListTile extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;

  const _PokemonListTile({required this.pokemon, required this.onTap});

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
                errorBuilder: (_, _, _) => const Icon(Icons.catching_pokemon, size: 40),
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
                backgroundColor: TypeColors.forType(type),
              ),
            );
          }).toList(),
        ),
        trailing: Text('#${pokemon.dexNumber}', style: Theme.of(context).textTheme.bodySmall),
        onTap: onTap,
      ),
    );
  }
}
