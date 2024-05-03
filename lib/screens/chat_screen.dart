import 'package:bluetooth_chat/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_chat/main.dart';
import 'package:bluetooth_chat/models.dart/message_model.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final messages = <MessageModel>[];
  final FocusNode focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus ? true : false;
      });
    });
    allBluetooth.listenForData.listen((event) {
      messages.add(MessageModel(
        message: event.toString(),
        isMe: false,
      ));
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
              onPressed: () {
                allBluetooth.closeConnection();
              },
              child: const Text("CLOSE"),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChatBubble(
                      clipper: ChatBubbleClipper4(
                        type: message.isMe!
                            ? BubbleType.sendBubble
                            : BubbleType.receiverBubble,
                      ),
                      alignment: message.isMe!
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Text(
                        message.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.orange),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final message = messageController.text;
                      allBluetooth.sendMessage(message);
                      messageController.clear();
                      messages.add(
                        MessageModel(
                          message: message,
                          isMe: true,
                        ),
                      );
                      setState(() {});
                    },
                    icon: Icon(Icons.send,
                        color: isFocused ? Colors.orange : Colors.black54),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
