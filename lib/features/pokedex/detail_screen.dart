import 'package:flutter/material.dart';
import '../../core/type_colors.dart';
import 'pokemon_bloc.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final name = pokemon.species[0].toUpperCase() + pokemon.species.substring(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (pokemon.sprite.isNotEmpty)
              Image.network(
                pokemon.sprite,
                width: 150,
                height: 150,
                errorBuilder: (_, _, _) => const Icon(Icons.catching_pokemon, size: 120),
              ),
            const SizedBox(height: 12),
            Text(name, style: Theme.of(context).textTheme.headlineMedium),
            Text(
              '#${pokemon.dexNumber}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pokemon.types.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Chip(
                    label: Text(type, style: const TextStyle(color: Colors.white)),
                    backgroundColor: TypeColors.forType(type),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InfoCard(label: 'Height', value: '${pokemon.height} m'),
                _InfoCard(label: 'Weight', value: '${pokemon.weight} kg'),
                _InfoCard(label: 'Color', value: pokemon.color),
              ],
            ),
            const SizedBox(height: 20),
            Text('Base Stats', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _StatBar(label: 'HP', value: pokemon.baseStats.hp),
            _StatBar(label: 'Attack', value: pokemon.baseStats.attack),
            _StatBar(label: 'Defense', value: pokemon.baseStats.defense),
            _StatBar(label: 'Sp. Atk', value: pokemon.baseStats.specialAttack),
            _StatBar(label: 'Sp. Def', value: pokemon.baseStats.specialDefense),
            _StatBar(label: 'Speed', value: pokemon.baseStats.speed),
            const SizedBox(height: 8),
            Text(
              'Total: ${pokemon.baseStatsTotal}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;

  const _StatBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 13))),
          SizedBox(
            width: 35,
            child: Text('$value', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 255,
                minHeight: 14,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(value >= 100 ? Colors.green : Colors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
