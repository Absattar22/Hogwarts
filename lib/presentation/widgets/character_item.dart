import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hogwarts/data/models/characters_model.dart';

class CharacterItem extends StatelessWidget {
   CharacterItem({super.key, required this.character});
  final CharactersModel character;

 
    final List<String> names = ['zeyad', 'ali', 'ahmed', 'mohammed', 'khalid'];
    List<String> filteredNames = [];


    void search(String value) {
      
      filteredNames = names.where((name) => name.toLowerCase().contains(value.toLowerCase()))
          .toList();
      print(filteredNames);
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 16, 123, 169),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GridTile(
          footer: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  const Color.fromARGB(0, 30, 43, 59),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: Text(
              character.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          child: Container(
            color: Colors.grey[200],
            child: character.image.isNotEmpty
                ? FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: character.image,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                  )
                : CachedNetworkImage(
                    imageUrl:
                        'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                    errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error, color: Colors.red)),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
