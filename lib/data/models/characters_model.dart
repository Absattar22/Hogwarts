// ignore_for_file: public_member_api_docs, sort_constructors_first
class CharactersModel {
  int charId;
  String name;
  List<dynamic> alternateNames; // List<String> but i used dynamic to avoid error in the API
  String house;
  String ancestry;
  String actor;
  String image;

  CharactersModel({
    required this.charId,
    required this.name,
    required this.alternateNames,
    required this.house,
    required this.ancestry,
    required this.actor,
    required this.image,
  });

  factory CharactersModel.fromJson(Map<String, dynamic> json) {
    return CharactersModel(
      charId: json['id'],
      name: json['name'],
      alternateNames: json['alternate_names'],
      house: json['house'],
      ancestry: json['ancestry'],
      actor: json['actor'],
      image: json['image'],
    );
  }
}

 
