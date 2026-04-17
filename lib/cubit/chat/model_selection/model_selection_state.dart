abstract class ModelSelectionState {}

class ModelSelectionInitial extends ModelSelectionState {
  final List<String> models;
  ModelSelectionInitial({required this.models});
}

class ChangeModelState extends ModelSelectionState {
  final String model;
  ChangeModelState({required this.model});
}

