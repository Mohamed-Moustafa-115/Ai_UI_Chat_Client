import 'package:ai_chat_client/cubit/chat/model_selection/model_selection_state.dart';
import 'package:ai_chat_client/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModelSelectionCubit extends Cubit<ModelSelectionState> {
  ModelSelectionCubit(List<String> models) : super(ModelSelectionInitial(models: models));

  List<String> models = [];

  void loadModels() async {
    try {
      models = await DioService().getAvalibleModels();
      emit(ModelSelectionInitial(models: models));
    } on DioException catch (e) {
      print("Error loading models: ${e.message}");
      emit(ModelSelectionInitial(models: []));
    }
  }

  void changeModel(String model) {
    emit(ChangeModelState(model: model));
  }
}