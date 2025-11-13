part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {}

class FavoriteLoaded extends FavoritesState {
  final List<int> favorites;

  FavoriteLoaded({required this.favorites});

  @override
  // TODO: implement props
  List<Object> get props => [favorites];
}
