import 'package:equatable/equatable.dart';
import '../models/pokemon.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object?> get props => [];
}

class PokemonInitial extends PokemonState {
  const PokemonInitial();
}

class PokemonLoading extends PokemonState {
  const PokemonLoading();
}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemonList;

  const PokemonLoaded(this.pokemonList);

  @override
  List<Object?> get props => [pokemonList];
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError(this.message);

  @override
  List<Object?> get props => [message];
}
