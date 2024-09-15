import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hogwarts/business_logic/cubit/characters_cubit.dart';
import 'package:hogwarts/data/api/characters_api.dart';
import 'package:hogwarts/data/models/characters_model.dart';
import 'package:hogwarts/data/repository/characters_repo.dart';
import 'package:hogwarts/presentation/widgets/character_item.dart';

class CharactersView extends StatefulWidget {
  const CharactersView({super.key});

  static const String id = 'Characters';

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  late CharactersRepo charactersRepo = CharactersRepo(CharactersApi());
  late CharactersCubit charactersCubit = CharactersCubit(charactersRepo);
  late List<CharactersModel> allCharacters;

  @override
  void initState() {
    super.initState();
    charactersCubit.getAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersIsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CharactersLoaded) {
          allCharacters = state.characters;
          return buildLoadedWidget();
        } else if (state is CharactersError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildLoadedWidget() {
    return SingleChildScrollView(
      child: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: allCharacters.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        return CharacterItem(character: allCharacters[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          charactersCubit, // Provide the cubit to the context here.
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 16, 123, 169),
          title:
              const Text('Characters', style: TextStyle(color: Colors.white)),
        ),
        body: buildBlocWidget(),
      ),
    );
  }
}
