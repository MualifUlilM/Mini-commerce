part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {}

class FavoriteLoaded extends FavoritesState {
  final List favorites;

  FavoriteLoaded({required this.favorites});
}
