import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/pokemon_service.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService service;

  PokemonBloc({required this.service}) : super(const PokemonInitial()) {
    on<PokemonListRequested>(_onListRequested);
    on<PokemonListRetryRequested>(_onListRequested);
  }

  Future<void> _onListRequested(
    PokemonEvent event,
    Emitter<PokemonState> emit,
  ) async {
    emit(const PokemonLoading());
    try {
      final list = await service.fetchPokemonList();
      emit(PokemonLoaded(list));
    } catch (e) {
      emit(PokemonError(e.toString()));
    }
  }
}
