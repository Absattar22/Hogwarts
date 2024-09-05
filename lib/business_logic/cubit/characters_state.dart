part of 'characters_cubit.dart';

@immutable
sealed class CharactersState {}

final class CharactersInitial extends CharactersState {}

class CharactersIsLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<CharactersModel> characters;

  CharactersLoaded(this.characters);
}

class CharactersError extends CharactersState {
  final String message;

  CharactersError(this.message);
}
