import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas/features/products/data/datasources/api_service.dart';
import 'package:tugas/features/products/data/models/detail_product_model.dart';

part 'detail_product_event.dart';
part 'detail_product_state.dart';

class DetailProductBloc extends Bloc<DetailProductEvent, DetailProductState> {
  final ApiService apiService;
  DetailProductBloc(this.apiService) : super(DetailProductInitial()) {
    on<GetDetailProduct>((event, emit) async {
      emit(DetailProductLoading());

      final result = await apiService.getProduct(event.idProduct);
      result.fold(
        (error) => emit(DetailProductError(message: error)),
        (data) => emit(DetailProductLoaded(detailProduct: data)),
      );
    });
  }
}
