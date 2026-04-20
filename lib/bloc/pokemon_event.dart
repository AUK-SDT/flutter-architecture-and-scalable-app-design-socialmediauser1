import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object?> get props => [];
}

class PokemonListRequested extends PokemonEvent {
  const PokemonListRequested();
}

class PokemonListRetryRequested extends PokemonEvent {
  const PokemonListRetryRequested();
}
