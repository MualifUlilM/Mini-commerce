import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());
  List<int> _productfavorites = [];
  Future<void> loadFavorites() async {
    final favIds = await _loadFavorites();
    _productfavorites = favIds;
    emit(FavoriteLoaded(favorites: _productfavorites));
  }

  Future<void> toggleFavorite(product) async {
    final favIds = await _loadFavorites();
    _productfavorites = favIds;
    if (_productfavorites.contains(product.id)) {
      _productfavorites.remove(product.id);
      devtools.log('berhasil hapus favorite');
    } else {
      _productfavorites.add(product.id);
      devtools.log('berhasil tambah favorite');
    }

    // save favorite ke local (shared prefs)
    await _saveFavorite();
    emit(FavoriteLoaded(favorites: _productfavorites));
  }

  Future<void> _saveFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favIds = _productfavorites;
    print(favIds);
    prefs.setStringList(
      'favorite_products',
      favIds.map((e) => e.toString()).toList(),
    );
  }

  Future<List<int>> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favStringList = prefs.getStringList('favorite_products') ?? [];
      return favStringList.map((e) => int.parse(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
