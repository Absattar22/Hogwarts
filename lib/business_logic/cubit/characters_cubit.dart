import 'package:bloc/bloc.dart';
import 'package:hogwarts/data/models/characters_model.dart';
import 'package:hogwarts/data/repository/characters_repo.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepo charactersRepo;
  List<CharactersModel> characters = [];
  CharactersCubit(this.charactersRepo) : super(CharactersInitial());

  List<CharactersModel> getAllCharacters() {
    emit(CharactersIsLoading());
    try {
      charactersRepo.getAllCharacters().then((characters) {
        emit(CharactersLoaded(characters));
        this.characters = characters;
      });
    } catch (e) {
      emit(CharactersError(e.toString()));
    }

    return characters;
  }
}
