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
  late List<CharactersModel> filteredCharacters;
  bool isSearching = false;
  final searchController = TextEditingController();

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search for a character...',
          hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        onChanged: (value) {
          setState(() {
            filteredCharacters = allCharacters
                .where((CharactersModel) => CharactersModel.name
                    .toLowerCase()
                    .startsWith(value.toLowerCase()))
                .toList();
          });
        },
      ),
    );
  }

  List<Widget> buildAppBarActions() {
    return [
      isSearching
          ? IconButton(
              icon:
                  const Icon(Icons.clear, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  searchController.clear();
                  filteredCharacters = allCharacters;
                  if (searchController.text.isEmpty) {
                    setState(() {
                      filteredCharacters = allCharacters;
                    });
                  } else {
                    setState(() {
                      Image.asset('assets/images/not_found.jpg');
                    });
                  }
                });
              },
            )
          : IconButton(
              icon:
                  const Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
            ),
    ];
  }

  void startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(
      LocalHistoryEntry(onRemove: stopSearching),
    ); // make the app bar like a new page and when you press back it will remove the search bar
    setState(() {
      isSearching = true;
    });
  }

  void stopSearching() {
    searchController.clear();
    setState(() {
      isSearching = false;
    });
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 16, 123, 169),
      title: isSearching
          ? buildSearchBar()
          : const Text('Characters', style: TextStyle(color: Colors.white)),
      actions: buildAppBarActions(),
    );
  }

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
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 16, 123, 169),
            ),
          );
        } else if (state is CharactersLoaded) {
          allCharacters = state.characters;
          return buildLoadedWidget();
        } else if (state is CharactersError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
            color: Color.fromARGB(255, 16, 123, 169),
          ));
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
    if (searchController.text.isNotEmpty && filteredCharacters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/not_found.gif', 
            ),
            const Text(
              'No characters found!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: searchController.text.isNotEmpty
          ? filteredCharacters.length
          : allCharacters.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        return CharacterItem(
          character: searchController.text.isNotEmpty
              ? filteredCharacters[index]
              : allCharacters[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          charactersCubit, // Provide the cubit to the context here.
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 16, 123, 169),
          title: isSearching
              ? buildSearchBar()
              : const Text('Characters', style: TextStyle(color: Colors.white)),
          actions: buildAppBarActions(),
          leading: isSearching
              ? const BackButton(color: Color.fromARGB(255, 0, 0, 0))
              : Container(),
        ),
        body: buildBlocWidget(),
      ),
    );
  }



}
