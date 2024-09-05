import 'package:hogwarts/data/api/characters_api.dart';
import 'package:hogwarts/data/models/characters_model.dart';

class CharactersRepo {
  final CharactersApi api;

  CharactersRepo(this.api);

  Future<List<CharactersModel>> getAllCharacters() async {
    final characters = await api.getAllCharacters();
    return characters.map((character) => CharactersModel.fromJson(character)).toList();
  }
}