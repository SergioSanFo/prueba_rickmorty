import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:prueba_rickmorty/providers/api_provider.dart';
import 'package:prueba_rickmorty/screens/login_screen.dart';
import 'package:prueba_rickmorty/utils/colors_utils.dart';
import 'package:prueba_rickmorty/widgets/search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters(page);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await apiProvider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("0d0118"),
        automaticallyImplyLeading: false,
        title: const Text(
          'Rick y Morty',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Sesion Cerrada");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: 'Buscar personaje',
                prefixIcon: Icon(Icons.search),
                fillColor: hexStringToColor("6e5b7f"),
                filled: true),
            onTap: () {
              showSearch(context: context, delegate: SearchCharacter());
            },
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: apiProvider.characters.isNotEmpty
                  ? CharacterCarousel(
                      apiProvider: apiProvider,
                      scrollController: scrollController,
                      isLoading: isLoading)
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class CharacterCarousel extends StatelessWidget {
  const CharacterCarousel(
      {super.key,
      required this.apiProvider,
      required this.scrollController,
      required this.isLoading});

  final ApiProvider apiProvider;
  final ScrollController scrollController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hexStringToColor("0d0118"),
      ),
      child: CarouselSlider.builder(
        itemCount: apiProvider.characters.length,
        itemBuilder: (context, index, realIndex) {
          final character = apiProvider.characters[index];
          return GestureDetector(
            onTap: () {
              context.go('/character', extra: character);
            },
            child: Column(
              children: [
                Hero(
                  tag: character.id!,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: hexStringToColor("4c3261"),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0,
                              0), // Ajusta el valor del offset para controlar la sombra
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: FadeInImage(
                        width: double.infinity,
                        height: 300.0,
                        placeholder:
                            const AssetImage('assets/images/portal.gif'),
                        image: NetworkImage(character.image!),
                      ),
                    ),
                  ),
                ),
                Text(
                  character.name!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          aspectRatio: 0.87,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          initialPage: 0,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
