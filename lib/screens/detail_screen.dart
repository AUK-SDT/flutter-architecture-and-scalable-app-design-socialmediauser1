import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final name =
        pokemon.species[0].toUpperCase() + pokemon.species.substring(1);

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
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.catching_pokemon, size: 120),
              ),
            const SizedBox(height: 12),

            Text(name, style: Theme.of(context).textTheme.headlineMedium),
            Text(
              '#${pokemon.dexNumber}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pokemon.types.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Chip(
                    label: Text(
                      type,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: typeColor(type),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(label: 'Height', value: '${pokemon.height} m'),
                InfoCard(label: 'Weight', value: '${pokemon.weight} kg'),
                InfoCard(label: 'Color', value: pokemon.color),
              ],
            ),
            const SizedBox(height: 20),

            Text('Base Stats', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            StatBar(label: 'HP', value: pokemon.baseStats.hp),
            StatBar(label: 'Attack', value: pokemon.baseStats.attack),
            StatBar(label: 'Defense', value: pokemon.baseStats.defense),
            StatBar(label: 'Sp. Atk', value: pokemon.baseStats.specialAttack),
            StatBar(label: 'Sp. Def', value: pokemon.baseStats.specialDefense),
            StatBar(label: 'Speed', value: pokemon.baseStats.speed),
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

class InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const InfoCard({super.key, required this.label, required this.value});

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

class StatBar extends StatelessWidget {
  final String label;
  final int value;

  const StatBar({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          SizedBox(
            width: 35,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 255,
                minHeight: 14,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  value >= 100 ? Colors.green : Colors.orange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
