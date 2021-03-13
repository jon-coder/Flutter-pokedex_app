import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokedex_app/consts/consts_app.dart';
import 'package:pokedex_app/models/poke_api.dart';
import 'package:pokedex_app/pages/home_page/widgets/app_bar_home.dart';
import 'package:pokedex_app/pages/home_page/widgets/poke_item.dart';
import 'package:pokedex_app/stores/pokeapi_store.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PokeApiStore pokeApiStore = PokeApiStore();
    pokeApiStore.fetchPokemonList();

    double screenWidth = MediaQuery.of(context).size.width;
    double statusWidth = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
              top: -(350 / 4),
              left: screenWidth - (350 / 1.7),
              child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    ConstsApp.pokeball,
                    height: 350,
                    width: 350,
                  ))),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: statusWidth,
                ),
                AppBarHome(),
                Expanded(
                  child: Container(
                      child: Observer(
                          name: 'Lista Home Page',
                          builder: (BuildContext context) {
                            PokeApi _pokeApi = pokeApiStore.pokeApi;
                            return (_pokeApi != null)
                                ? AnimationLimiter(
                                    child: GridView.builder(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.all(12),
                                    addAutomaticKeepAlives: true,
                                    gridDelegate:
                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemCount:
                                        pokeApiStore.pokeApi.pokemon.length,
                                    itemBuilder: (contex, index) {
                                      Pokemon pokemon =
                                          pokeApiStore.getPokemon(index: index);
                                      return AnimationConfiguration
                                          .staggeredGrid(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 380),
                                              columnCount: 2,
                                              child: ScaleAnimation(
                                                child: GestureDetector(
                                                  child: PokeItem(
                                                    types: pokemon.type,
                                                    index: index,
                                                    nome: pokemon.name,
                                                    num: pokemon.num,
                                                  ),
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Container(),
                                                        fullscreenDialog: true,
                                                      )),
                                                ),
                                              ));
                                    },
                                  ))
                                : Center(child: CircularProgressIndicator());
                          })),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
