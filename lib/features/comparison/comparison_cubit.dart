import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pokedex/pokemon_bloc.dart';

enum StatWinner { pokemon1, pokemon2, tie }

class StatComparison {
  final String statName;
  final int value1;
  final int value2;
  final StatWinner winner;

  const StatComparison({
    required this.statName,
    required this.value1,
    required this.value2,
    required this.winner,
  });
}

class ComparisonResult {
  final Pokemon pokemon1;
  final Pokemon pokemon2;

  /// Six entries in order: HP, Attack, Defense, Sp. Atk, Sp. Def, Speed.
  final List<StatComparison> statComparisons;
  final StatWinner overallWinner;

  const ComparisonResult({
    required this.pokemon1,
    required this.pokemon2,
    required this.statComparisons,
    required this.overallWinner,
  });
}

StatWinner _winner(int a, int b) =>
    a > b ? StatWinner.pokemon1 : b > a ? StatWinner.pokemon2 : StatWinner.tie;

ComparisonResult _compare(Pokemon p1, Pokemon p2) => ComparisonResult(
  pokemon1: p1,
  pokemon2: p2,
  statComparisons: [
    StatComparison(statName: 'HP', value1: p1.baseStats.hp, value2: p2.baseStats.hp, winner: _winner(p1.baseStats.hp, p2.baseStats.hp)),
    StatComparison(statName: 'Attack', value1: p1.baseStats.attack, value2: p2.baseStats.attack, winner: _winner(p1.baseStats.attack, p2.baseStats.attack)),
    StatComparison(statName: 'Defense', value1: p1.baseStats.defense, value2: p2.baseStats.defense, winner: _winner(p1.baseStats.defense, p2.baseStats.defense)),
    StatComparison(statName: 'Sp. Atk', value1: p1.baseStats.specialAttack, value2: p2.baseStats.specialAttack, winner: _winner(p1.baseStats.specialAttack, p2.baseStats.specialAttack)),
    StatComparison(statName: 'Sp. Def', value1: p1.baseStats.specialDefense, value2: p2.baseStats.specialDefense, winner: _winner(p1.baseStats.specialDefense, p2.baseStats.specialDefense)),
    StatComparison(statName: 'Speed', value1: p1.baseStats.speed, value2: p2.baseStats.speed, winner: _winner(p1.baseStats.speed, p2.baseStats.speed)),
  ],
  overallWinner: _winner(p1.baseStatsTotal, p2.baseStatsTotal),
);

abstract class ComparisonState extends Equatable {
  const ComparisonState();

  @override
  List<Object?> get props => [];
}

class ComparisonInitial extends ComparisonState {
  const ComparisonInitial();
}

class ComparisonSelecting extends ComparisonState {
  final Pokemon? selectedPokemon1;
  final Pokemon? selectedPokemon2;

  const ComparisonSelecting({this.selectedPokemon1, this.selectedPokemon2});

  @override
  List<Object?> get props => [selectedPokemon1, selectedPokemon2];
}

class ComparisonReady extends ComparisonState {
  final ComparisonResult result;

  const ComparisonReady(this.result);

  @override
  List<Object?> get props => [result];
}

class ComparisonCubit extends Cubit<ComparisonState> {
  ComparisonCubit() : super(const ComparisonInitial());

  void selectPokemon1(Pokemon pokemon) {
    final p2 = _currentPokemon2();
    emit(ComparisonSelecting(selectedPokemon1: pokemon, selectedPokemon2: p2));
    if (p2 != null) emit(ComparisonReady(_compare(pokemon, p2)));
  }

  void selectPokemon2(Pokemon pokemon) {
    final p1 = _currentPokemon1();
    emit(ComparisonSelecting(selectedPokemon1: p1, selectedPokemon2: pokemon));
    if (p1 != null) emit(ComparisonReady(_compare(p1, pokemon)));
  }

  void reset() => emit(const ComparisonInitial());

  Pokemon? _currentPokemon1() {
    final s = state;
    if (s is ComparisonSelecting) return s.selectedPokemon1;
    if (s is ComparisonReady) return s.result.pokemon1;
    return null;
  }

  Pokemon? _currentPokemon2() {
    final s = state;
    if (s is ComparisonSelecting) return s.selectedPokemon2;
    if (s is ComparisonReady) return s.result.pokemon2;
    return null;
  }
}
