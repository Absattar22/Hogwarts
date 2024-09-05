import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hogwarts/business_logic/cubit/characters_cubit.dart';
import 'package:hogwarts/data/api/characters_api.dart';
import 'package:hogwarts/data/models/characters_model.dart';
import 'package:hogwarts/data/repository/characters_repo.dart';

class CharactersView extends StatefulWidget {
  const CharactersView({super.key});

  static const String id = 'Characters';

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  late CharactersCubit charactersCubit = CharactersCubit(charactersRepo);

  late CharactersRepo charactersRepo = CharactersRepo(CharactersApi());
  late List<CharactersModel> characters;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => charactersCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Characters'),
        ),
        body: const Center(
          child: Text('Characters View'),
        ),
      ),
    );
  }
}
