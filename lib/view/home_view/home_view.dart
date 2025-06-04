import 'package:chat_bot/view/home_view/widget/appbar_widget.dart';
import 'package:chat_bot/view/home_view/widget/message_list.dart';
import 'package:chat_bot/view_model/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_bot/view/home_view/widget/input_row_widget.dart';
import 'package:chat_bot/view/home_view/widget/mic_dialog_widget.dart';
import 'package:chat_bot/service/permission_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:chat_bot/view_model/chat_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    PermissionService.requestMicPermission();
  }

  void _startListening() async {
    final available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) => setState(() {
          _controller.text = result.recognizedWords;
        }),
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider);
    final chatController = ref.read(chatControllerProvider.notifier);
    final themeMode = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: buildAppBar(ref, themeMode, context),
      body: Column(
        children: [
          Expanded(child: buildMessageList(chatState, context)),
          buildInputRow(
            controller: _controller,
            isListening: _isListening,
            onMicPressed: () {
              if (!_isListening) _startListening();
              showMicDialog(context, _isListening, _stopListening);
            },
            chatController: chatController,
          ),
        ],
      ),
    );
  }
}
