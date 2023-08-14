import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_rickmorty/models/character_model.dart';
import 'package:prueba_rickmorty/providers/api_provider.dart';
import 'package:prueba_rickmorty/utils/colors_utils.dart';

class CharacterScreen extends StatelessWidget {
  final Character character;
  const CharacterScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("0d0118"),
        centerTitle: true,
        title: Text(character.name!),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.40,
              width: double.infinity,
              child: Hero(
                tag: character.id!,
                child: Image.network(
                  character.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: hexStringToColor("0d0118"),
              height: size.height * 0.10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cardData("Status:", character.status!),
                  cardData("Specie:", character.species!),
                  cardData("Origin:", character.origin!.name!)
                ],
              ),
            ),
            Container(
              color: hexStringToColor("0d0118"),
              padding: const EdgeInsets.symmetric(vertical: 10),
              // child: const Text(
              //   'Episodes',
              //   style: TextStyle(fontSize: 17, color: Colors.white),
              // ),
            ),
            EpisodeList(size: size, character: character)
          ],
        ),
      ),
    );
  }

  Widget cardData(String text1, String text2) {
    return Expanded(
      child: Container(
        color: hexStringToColor("0d0118"),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(text1),
              Text(
                text2,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EpisodeList extends StatefulWidget {
  const EpisodeList({super.key, required this.size, required this.character});

  final Size size;
  final Character character;

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getEpisodes(widget.character);
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Container(
      color: hexStringToColor("0d0118"),
      child: SizedBox(
        height: widget.size.height * 0.35,
        child: ListView.builder(
          itemCount: apiProvider.episodes.length,
          itemBuilder: (context, index) {
            final episode = apiProvider.episodes[index];
            return ListTile(
              leading: Text(
                episode.episode!,
                style: TextStyle(color: Colors.white),
              ),
              title: Text(
                episode.name!,
                style: TextStyle(color: Colors.white),
              ),
              trailing: Text(
                episode.airDate!,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
