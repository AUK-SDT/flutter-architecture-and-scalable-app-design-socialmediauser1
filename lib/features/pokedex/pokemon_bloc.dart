import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/graphql_client.dart';

class _BaseStatsDto {
  final int hp, attack, defense, specialAttack, specialDefense, speed;

  const _BaseStatsDto({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  factory _BaseStatsDto.fromJson(Map<String, dynamic> json) => _BaseStatsDto(
    hp: json['hp'] as int,
    attack: json['attack'] as int,
    defense: json['defense'] as int,
    specialAttack: json['specialattack'] as int,
    specialDefense: json['specialdefense'] as int,
    speed: json['speed'] as int,
  );
}

class _PokemonDto {
  final String key, species, sprite, color, height, weight;
  final int num, baseStatsTotal;
  final List<Map<String, dynamic>> types;
  final _BaseStatsDto baseStats;

  const _PokemonDto({
    required this.key,
    required this.species,
    required this.num,
    required this.types,
    required this.sprite,
    required this.color,
    required this.height,
    required this.weight,
    required this.baseStats,
    required this.baseStatsTotal,
  });

  factory _PokemonDto.fromJson(Map<String, dynamic> json) => _PokemonDto(
    key: json['key'] as String,
    species: json['species'] as String,
    num: json['num'] as int,
    types: (json['types'] as List).cast<Map<String, dynamic>>(),
    sprite: json['sprite'] as String? ?? '',
    color: json['color'] as String? ?? 'Unknown',
    height: json['height'].toString(),
    weight: json['weight'].toString(),
    baseStats: _BaseStatsDto.fromJson(json['baseStats'] as Map<String, dynamic>),
    baseStatsTotal: json['baseStatsTotal'] as int,
  );
}

class BaseStats extends Equatable {
  final int hp, attack, defense, specialAttack, specialDefense, speed;

  const BaseStats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  @override
  List<Object?> get props => [hp, attack, defense, specialAttack, specialDefense, speed];
}

class Pokemon extends Equatable {
  final String key, species, sprite, color;
  final int dexNumber, baseStatsTotal;
  final List<String> types;

  /// Height in metres, parsed from the raw API string (e.g. '0.7m').
  final double height;

  /// Weight in kilograms, parsed from the raw API string (e.g. '6.9kg').
  final double weight;

  final BaseStats baseStats;

  const Pokemon({
    required this.key,
    required this.species,
    required this.dexNumber,
    required this.types,
    required this.sprite,
    required this.color,
    required this.height,
    required this.weight,
    required this.baseStats,
    required this.baseStatsTotal,
  });

  @override
  List<Object?> get props => [key, species, dexNumber, types, sprite, color, height, weight, baseStats, baseStatsTotal];
}

Future<List<Pokemon>> _fetchPokemonList(GraphqlClient client, {int count = 151}) async {
  final results = <Pokemon>[];
  for (var dex = 1; dex <= count; dex++) {
    results.add(await _fetchByDexNumber(client, dex));
  }
  return results;
}

Future<Pokemon> _fetchByDexNumber(GraphqlClient client, int number) async {
  final query = '''
    {
      getPokemonByDexNumber(number: $number) {
        key species num
        types { name }
        baseStats { hp attack defense specialattack specialdefense speed }
        baseStatsTotal sprite color height weight
      }
    }
  ''';
  final result = await client.query(query);
  final data = result['data']['getPokemonByDexNumber'] as Map<String, dynamic>;
  return _mapToEntity(_PokemonDto.fromJson(data));
}

Pokemon _mapToEntity(_PokemonDto dto) => Pokemon(
  key: dto.key,
  species: dto.species,
  dexNumber: dto.num,
  types: dto.types.map((t) => t['name'] as String).toList(),
  sprite: dto.sprite,
  color: dto.color,
  height: double.tryParse(dto.height.replaceAll('m', '').trim()) ?? 0.0,
  weight: double.tryParse(dto.weight.replaceAll('kg', '').trim()) ?? 0.0,
  baseStats: BaseStats(
    hp: dto.baseStats.hp,
    attack: dto.baseStats.attack,
    defense: dto.baseStats.defense,
    specialAttack: dto.baseStats.specialAttack,
    specialDefense: dto.baseStats.specialDefense,
    speed: dto.baseStats.speed,
  ),
  baseStatsTotal: dto.baseStatsTotal,
);

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

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GraphqlClient _client;

  PokemonBloc({required GraphqlClient client})
    : _client = client,
      super(const PokemonInitial()) {
    on<PokemonListRequested>(_onListRequested);
    on<PokemonListRetryRequested>(_onListRequested);
  }

  Future<void> _onListRequested(PokemonEvent event, Emitter<PokemonState> emit) async {
    emit(const PokemonLoading());
    try {
      emit(PokemonLoaded(await _fetchPokemonList(_client)));
    } catch (e) {
      emit(PokemonError(e.toString()));
    }
  }
}
