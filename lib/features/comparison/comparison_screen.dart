import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pokedex/pokemon_bloc.dart';
import 'comparison_cubit.dart';

class ComparisonScreen extends StatelessWidget {
  final List<Pokemon> pokemonList;

  const ComparisonScreen({super.key, required this.pokemonList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComparisonCubit(),
      child: _ComparisonView(pokemonList: pokemonList),
    );
  }
}

class _ComparisonView extends StatelessWidget {
  final List<Pokemon> pokemonList;

  const _ComparisonView({required this.pokemonList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Pokémon'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<ComparisonCubit, ComparisonState>(
        builder: (context, state) {
          final p1 = _selectedPokemon1(state);
          final p2 = _selectedPokemon2(state);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SelectorRow(pokemonList: pokemonList, selected1: p1, selected2: p2),
                const SizedBox(height: 24),
                if (state is ComparisonReady) ...[
                  _ComparisonTable(result: state.result),
                  const SizedBox(height: 16),
                  _OverallWinnerBanner(result: state.result),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => context.read<ComparisonCubit>().reset(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ),
                ] else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Text(
                        'Select two Pokémon to compare',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Pokemon? _selectedPokemon1(ComparisonState state) {
    if (state is ComparisonSelecting) return state.selectedPokemon1;
    if (state is ComparisonReady) return state.result.pokemon1;
    return null;
  }

  Pokemon? _selectedPokemon2(ComparisonState state) {
    if (state is ComparisonSelecting) return state.selectedPokemon2;
    if (state is ComparisonReady) return state.result.pokemon2;
    return null;
  }
}

class _SelectorRow extends StatelessWidget {
  final List<Pokemon> pokemonList;
  final Pokemon? selected1;
  final Pokemon? selected2;

  const _SelectorRow({
    required this.pokemonList,
    required this.selected1,
    required this.selected2,
  });

  String _label(Pokemon p) => p.species[0].toUpperCase() + p.species.substring(1);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PokemonDropdown(
            pokemonList: pokemonList,
            selected: selected1,
            hint: 'Pokémon 1',
            onChanged: (p) => context.read<ComparisonCubit>().selectPokemon1(p),
            labelBuilder: _label,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('vs', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: _PokemonDropdown(
            pokemonList: pokemonList,
            selected: selected2,
            hint: 'Pokémon 2',
            onChanged: (p) => context.read<ComparisonCubit>().selectPokemon2(p),
            labelBuilder: _label,
          ),
        ),
      ],
    );
  }
}

class _PokemonDropdown extends StatelessWidget {
  final List<Pokemon> pokemonList;
  final Pokemon? selected;
  final String hint;
  final ValueChanged<Pokemon> onChanged;
  final String Function(Pokemon) labelBuilder;

  const _PokemonDropdown({
    required this.pokemonList,
    required this.selected,
    required this.hint,
    required this.onChanged,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButton<Pokemon>(
        value: selected,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(hint),
        items: pokemonList
            .map((p) => DropdownMenuItem<Pokemon>(
                  value: p,
                  child: Text(labelBuilder(p), overflow: TextOverflow.ellipsis),
                ))
            .toList(),
        onChanged: (p) {
          if (p != null) onChanged(p);
        },
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  final ComparisonResult result;

  const _ComparisonTable({required this.result});

  @override
  Widget build(BuildContext context) {
    final name1 = result.pokemon1.species[0].toUpperCase() + result.pokemon1.species.substring(1);
    final name2 = result.pokemon2.species[0].toUpperCase() + result.pokemon2.species.substring(1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(flex: 2, child: Text('Stat', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                  flex: 2,
                  child: Text(name1, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  flex: 2,
                  child: Text(name2, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const Divider(),
            ...result.statComparisons.map((stat) => _StatRow(stat: stat)),
            const Divider(),
            Row(
              children: [
                const Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${result.pokemon1.baseStatsTotal}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: result.overallWinner == StatWinner.pokemon1 ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${result.pokemon2.baseStatsTotal}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: result.overallWinner == StatWinner.pokemon2 ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final StatComparison stat;

  const _StatRow({required this.stat});

  @override
  Widget build(BuildContext context) {
    final isTie = stat.winner == StatWinner.tie;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(stat.statName)),
          Expanded(
            flex: 2,
            child: Text(
              isTie ? '${stat.value1} TIE' : '${stat.value1}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: stat.winner == StatWinner.pokemon1 ? FontWeight.bold : FontWeight.normal,
                color: stat.winner == StatWinner.pokemon1 ? Colors.green : Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              isTie ? '${stat.value2} TIE' : '${stat.value2}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: stat.winner == StatWinner.pokemon2 ? FontWeight.bold : FontWeight.normal,
                color: stat.winner == StatWinner.pokemon2 ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverallWinnerBanner extends StatelessWidget {
  final ComparisonResult result;

  const _OverallWinnerBanner({required this.result});

  @override
  Widget build(BuildContext context) {
    final String text;
    final Color color;

    switch (result.overallWinner) {
      case StatWinner.pokemon1:
        text = '${result.pokemon1.species[0].toUpperCase()}${result.pokemon1.species.substring(1)} wins overall!';
        color = Colors.green;
      case StatWinner.pokemon2:
        text = '${result.pokemon2.species[0].toUpperCase()}${result.pokemon2.species.substring(1)} wins overall!';
        color = Colors.green;
      case StatWinner.tie:
        text = "It's a tie!";
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
