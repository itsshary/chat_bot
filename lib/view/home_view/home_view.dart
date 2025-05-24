import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_bot/view_model/chat_riverpod.dart';
import 'package:chat_bot/view_model/theme_provider.dart';
import 'package:chat_bot/utill/app_constants.dart';
import 'package:chat_bot/utill/dimensions.dart';
import 'package:chat_bot/utill/extension.dart';
import 'package:chat_bot/utill/images.dart';
import 'package:chat_bot/utill/styles.dart';
import 'package:chat_bot/utill/toast_message.dart';
import 'package:chat_bot/view/home_view/widget/message_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'widget/show_firebase_details.dart';

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
    requestMicPermission();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => ShowMessae().showToast(status.toString()),
      onError: (error) => ShowMessae().showToast(error.toString()),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        },
      );
    } else {
      print('Speech recognition not available');
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
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          ),
        ],
        title: Row(
          children: [
            Image.asset(AppImages.logo,
                height: Dimensions.smallImageSizs,
                width: Dimensions.smallImageSizs),
            Dimensions.mediumSizedBox.sW,
            Text(AppConstants.appName, style: appbarTextStyle),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            showUserDataDialog(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.messages.isEmpty && chatState.isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 4,
                    itemBuilder: (_, __) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: chatState.messages.length +
                        (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < chatState.messages.length) {
                        return buildMessage(chatState.messages[index], context);
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                'Typing...',
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            repeatForever: true,
                            isRepeatingAnimation: true,
                          ),
                        );
                      }
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical: Dimensions.paddingSizeSmall,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: AppConstants.askSomething,
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault),
                          borderSide: BorderSide.none),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                IconButton(
                  icon: _isListening
                      ? const Icon(Icons.stop, color: Colors.red)
                      : const Icon(Icons.mic, color: Colors.black),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        if (!_isListening) {
                          _startListening();
                        }

                        return AlertDialog(
                          title: const Text('Voice Input'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _isListening
                                  ? Lottie.asset(JsonFiles.micJson,
                                      height: 80, width: 80)
                                  : const Icon(Icons.mic_none, size: 60),
                              const SizedBox(height: 12),
                              Text(
                                _isListening
                                    ? 'Listening...'
                                    : 'Tap OK when done',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _stopListening(); // stop mic
                                Navigator.of(context).pop(); // close dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_controller.text.trim().isNotEmpty) {
                      final String message = _controller.text.trim();
                      final user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        await chatController.sendMessage(message);
                      }

                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> requestMicPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }
}
