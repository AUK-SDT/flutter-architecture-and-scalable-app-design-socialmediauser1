# Pokédex

A Flutter app that displays data for the original 151 Pokémon using the Favware GraphQL API. Browse the full list, view detailed stats for any Pokémon, and compare two Pokémon side-by-side across all six base stats.

## How to Run

```bash
flutter pub get
flutter run
```

No API key required — the Favware API is public.

## API Used

**Favware GraphQL Pokémon API**
- URL: `https://graphqlpokemon.favware.tech/v8`
- Authentication: None (public endpoint)
- Query: `getPokemonByDexNumber(number: N)` called sequentially for dex numbers 1–151
- Fields used: `key`, `species`, `num`, `types { name }`, `baseStats { hp attack defense specialattack specialdefense speed }`, `baseStatsTotal`, `sprite`, `color`, `height`, `weight`

## Project Structure

```
lib/
├── core/
│   ├── network/
│   │   └── graphql_client.dart     # HTTP wrapper for GraphQL POST requests
│   └── theme/
│       └── type_colors.dart        # Centralised Pokémon type → Color map
├── features/
│   ├── pokedex/                    # Main Pokédex feature
│   │   ├── data/
│   │   │   ├── pokemon_dto.dart        # Raw API response shape (DTO)
│   │   │   └── pokemon_repository.dart # Fetches DTOs from the network
│   │   ├── domain/
│   │   │   ├── pokemon.dart            # Clean domain entity + BaseStats
│   │   │   └── pokemon_service.dart    # Maps DTOs → entities (business logic)
│   │   └── presentation/
│   │       ├── bloc/                   # BLoC events, states, and handler
│   │       ├── screens/                # List screen + Detail screen
│   │       └── widgets/                # PokemonListTile, StatBar, InfoCard
│   └── comparison/                 # Pokémon comparison feature (new)
│       ├── domain/
│       │   ├── comparison_result.dart  # StatWinner enum, result entities
│       │   └── comparison_service.dart # Stat-by-stat comparison logic
│       └── presentation/
│           ├── cubit/                  # ComparisonCubit + states
│           └── screens/                # ComparisonScreen
└── main.dart                       # Dependency injection wiring + app root
```

## Architecture

Layered architecture with **feature-first** folder organisation. Each feature contains three layers:

| Layer | Responsibility |
|---|---|
| **data** | Network access, JSON parsing, DTOs |
| **domain** | Business logic, entities, services |
| **presentation** | UI widgets, screens, state management |

**State management:**
- `PokemonBloc` (event-driven BLoC) for the Pokédex feature — suits the explicit load/retry event model.
- `ComparisonCubit` (simpler Cubit) for the comparison feature — suits the straightforward selection state.

All dependencies are injected via constructors and wired in `main.dart`. No class creates its own dependencies internally.

## Business Logic Location

| Location | What it does |
|---|---|
| `features/pokedex/domain/pokemon_service.dart` | Maps raw DTOs to entities; parses height/weight strings (e.g. `'0.7m'` → `0.7`); extracts type names from nested maps |
| `features/comparison/domain/comparison_service.dart` | Compares two Pokémon stat by stat; determines per-stat and overall winner by `baseStatsTotal` |

## Features

- **Pokédex list** — scrollable list of 151 Pokémon with sprite, name, dex number, and type badges
- **Detail view** — full stats, physical attributes, and stat progress bars
- **Comparison** — pick any two Pokémon from dropdowns to compare all six base stats side-by-side, with the winner highlighted and an overall result banner
