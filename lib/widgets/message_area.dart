import 'package:ai_chat_client/cubit/chat/message_area/message_area_cubit.dart';
import 'package:ai_chat_client/cubit/chat/message_area/message_area_state.dart';
import 'package:ai_chat_client/cubit/chat/model_selection/model_selcetion_cubit.dart';
import 'package:ai_chat_client/cubit/chat/model_selection/model_selection_state.dart';
import 'package:ai_chat_client/services/dio.dart';
import 'package:ai_chat_client/vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageArea extends StatelessWidget {
  const MessageArea({super.key});

  @override
  Widget build(BuildContext context) {
    return MessageAreaContent();
  }
}

class MessageAreaContent extends StatelessWidget {
  final TextEditingController _message = TextEditingController();

  MessageAreaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ModelSelectionCubit([]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocListener<ModelSelectionCubit, ModelSelectionState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              child: Builder(
                builder: (innerContext) {
                  return IconButton(
                    onPressed: () async {
                      final RenderBox button =
                          innerContext.findRenderObject() as RenderBox;
                      final Offset buttonPosition = button.localToGlobal(
                        Offset.zero,
                      );
                      final Size buttonSize = button.size;
                      List<String> models = await DioService()
                          .getAvalibleModels();

                      final modelCubit = BlocProvider.of<ModelSelectionCubit>(
                        innerContext,
                        listen: false,
                      );

                      final value = await showMenu(
                        position: RelativeRect.fromLTRB(
                          buttonPosition.dx,
                          buttonPosition.dy + buttonSize.height,
                          buttonPosition.dx + buttonSize.width,
                          buttonPosition.dy + buttonSize.height,
                        ),
                        context: innerContext,
                        items: models
                            .map(
                              (model) => PopupMenuItem(
                                value: model,
                                child: Text(model),
                              ),
                            )
                            .toList(),
                      );

                      if (value != null) {
                        modelCubit.changeModel(value);
                        selectedModel = value;
                      }
                    },
                    icon: Row(
                      children: [
                        Icon(Icons.memory_rounded),
                        SizedBox(width: 5),
                        SizedBox(
                          width: MediaQuery.sizeOf(innerContext).width * .1,
                          child:
                              BlocBuilder<
                                ModelSelectionCubit,
                                ModelSelectionState
                              >(
                                builder: (context, state) {
                                  if (state is ChangeModelState) {
                                    selectedModel = state.model;
                                  }
                                  return Text(
                                    selectedModel.isEmpty
                                        ? "Select model"
                                        : selectedModel,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .075,
              width: MediaQuery.sizeOf(context).width * .5,
              child: TextField(
                maxLines: null,
                expands: true,
                controller: _message,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.message),
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            BlocBuilder<MessageAreaCubit, MessageAreaState>(
              builder: (context, state) {
                return state.isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.send),
                      )
                    : IconButton(
                        onPressed: () async {
                          String msg = _message.text;
                          _message.clear();
                          await context.read<MessageAreaCubit>().sendMessage(
                            msg,
                            true,
                          );
                        },
                        icon: Icon(Icons.send, color: Colors.blue),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
