class Pokemon {
  final String key;
  final String species;
  final int dexNumber;
  final List<String> types;
  final String sprite;
  final String color;
  final double height;
  final double weight;
  final BaseStats baseStats;
  final int baseStatsTotal;

  Pokemon({
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

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final typesList = (json['types'] as List)
        .map((t) => t['name'] as String)
        .toList();

    return Pokemon(
      key: json['key'] as String,
      species: json['species'] as String,
      dexNumber: json['num'] as int,
      types: typesList,
      sprite: json['sprite'] as String? ?? '',
      color: json['color'] as String? ?? 'Unknown',
      height: double.parse(json['height'].toString()),
      weight: double.parse(json['weight'].toString()),
      baseStats: BaseStats.fromJson(json['baseStats'] as Map<String, dynamic>),
      baseStatsTotal: json['baseStatsTotal'] as int,
    );
  }
}

class BaseStats {
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;

  BaseStats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  factory BaseStats.fromJson(Map<String, dynamic> json) {
    return BaseStats(
      hp: json['hp'] as int,
      attack: json['attack'] as int,
      defense: json['defense'] as int,
      specialAttack: json['specialattack'] as int,
      specialDefense: json['specialdefense'] as int,
      speed: json['speed'] as int,
    );
  }
}
