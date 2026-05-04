import 'package:flutter/material.dart';

/// Provides the display [Color] for each Pokémon type badge.
/// Single source of truth — eliminates duplication across screens.
/// Falls back to [Colors.grey] for unknown or future types.
class TypeColors {
  TypeColors._();

  static const Map<String, Color> _colors = {
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

  /// Returns the badge color for the given Pokémon [type].
  /// Returns [Colors.grey] if the type is not recognised.
  static Color forType(String type) => _colors[type] ?? Colors.grey;
}
