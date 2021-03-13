import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex_app/models/poke_api.dart';
import 'package:pokedex_app/consts/consts_api.dart';
import 'package:http/http.dart' as http;
part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {
  @observable
  PokeApi pokeApi;

  @action
  fetchPokemonList() {
    pokeApi = null;
    loadPokeApi().then((pokeList) => pokeApi = pokeList);
  }

  @action
  getPokemon({int index}) {
    return pokeApi.pokemon[index];
  }

  @action
  Widget getImage({String numero}) {
    return CachedNetworkImage(
      placeholder: (context, url) => new Container(
        color: Colors.transparent,
      ),
      imageUrl:
          'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$numero.png',
    );
  }

  Future<PokeApi> loadPokeApi() async {
    try {
      final response = await http.get(ConstApi.pokeApiUrl);
      var decodeJson = jsonDecode(response.body);
      return PokeApi.fromJson(decodeJson);
    } catch (error) {
      print('Erro ao carregar a pokedex');
      return null;
    }
  }
}
