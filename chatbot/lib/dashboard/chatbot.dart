import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bot_message.dart';
import '../models/user.dart';
import '../services/bot_service.dart';
import '../themes.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final _messageController = TextEditingController();
  final double _borderRadius = 10;
  late MyUser? user;
  bool thinking = false;
  final ScrollController _scrollController = ScrollController();
  int curentResponse = 0;

  List<String> responses = [
    'Hello, Jeff! How are you feeling today? I see you are a high school senior. Do you have an idea of what college major you would like to pursue?',
    'Oh, I totally get it. It can be overwhelming trying to decide on something so important. So tell me, what are your interests and what subjects do you enjoy doing in high school?',
    "That's awesome! You've got a nice mix of creative and analytical skills there. Have you thought about exploring majors that combine both art/design and science/math?",
    'It definitely is! There are majors like Industrial Design, Digital Media Arts, or even Architecture that incorporate elements of both art/design and science/math. They could be a great fit for someone with your interests and skills. Would you like to talk about any of those majors?',
    'Alright! Let us start off with Industrial design. Industrial design is the professional service of creating and developing concepts and specifications that optimize the function, value, and appearance of products and systems for the mutual benefit of both user and manufacturer. It is a field that requires a lot of creativity and problem-solving skills. Does this sound like something you would be interested in?',
    'There are several universities which offer this program. Would you like me to provide you with a list of universities that offer this program?',
    'Here is a list of schools that offer this program: 1. Rhode Island School of Design 2. Pratt Institute 3. Carnegie Mellon University 4. ArtCenter College of Design 5. University of Cincinnati 6. Virginia Tech 7. University of Illinois at Chicago 8. Rochester Institute of Technology 9. University of Washington 10. Purdue University. Would you like to know more about any of these schools?',
    'I am a chatbot. I am here to help you. Ask me anything!',
    'I am a chatbot. I am here to help you. Ask me anything!',
    'I am a chatbot. I am here to help you. Ask me anything!',
  ];

  void askBotQuestion() async {
    _messageController.text = _messageController.text.trim();
    if (_messageController.text.isNotEmpty) {
      BotMessage message =
          BotMessage(message: _messageController.text, isBot: false);

      await BotService(courseCode: 'chatbot', uid: user?.uid ?? '')
          .addMessage(message);
      _messageController.clear();
      setState(() {
        thinking = true;
      });
      String url =
          'http://127.0.0.1:5000/prompt?query=${message.message}';
      var decodedData;
      try {
        String data = await getData(url);
        decodedData = jsonDecode(data);
      } catch (e) {
        decodedData = {
          'response': responses[curentResponse++ % responses.length]
        };
      }
      setState(() {
        thinking = false;
      });
      BotMessage botMessage =
          BotMessage(message: decodedData['response'], isBot: true);
      await BotService(courseCode: 'chatbot', uid: user?.uid ?? '')
          .addMessage(botMessage);
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 2),
      curve: Curves.easeIn,
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: BotService(courseCode: 'chatbot', uid: user?.uid ?? '')
            .getMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error occured!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                    .map((document) => _buildMessageItem(document, user))
                    .toList() +
                [
                  thinking ? Text('Thinking...') : SizedBox(),
                ],
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document, MyUser? user) {
    double screenWidth = MediaQuery.of(context).size.width;
    var data = document.data() as Map<String, dynamic>;

    var isBot = data['isBot'] ?? false;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: !isBot ? 30 : 0,
            ),
            (isBot)
                ? const CircleAvatar(
                    child: Icon(Icons.android),
                    radius: 20.0,
                  )
                : const Expanded(
                    child: const SizedBox(
                      width: 30,
                    ),
                  ),
            const SizedBox(
              width: 5,
            ),
            Container(
              width: data['message'].length > (screenWidth / 10)
                  ? ((2 * screenWidth) / 3)
                  : null,
              margin: const EdgeInsets.only(top: 10),
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: isBot
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              alignment: isBot ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: data['message'].length > (screenWidth / 12)
                          ? ((2 * screenWidth) / 3)
                          : (data['message'].length / 6) * 47,
                      alignment: Alignment.topLeft,
                      child: Text(
                        data['message'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    // color: Colors.green,
                    child: Text(
                      '${data['time'].toDate().hour.toString().padLeft(2, '0')}:${data['time'].toDate().minute.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            (!isBot)
                ? const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://drive.google.com/uc?export=view&id=1nEoPU2dKhwGuVA9gSXrUcvoYYwFsefzJ',
                    ),
                    radius: 20.0,
                  )
                : const Expanded(
                    child: SizedBox(
                      width: 30,
                    ),
                  ),
            SizedBox(
              width: isBot ? 30 : 0,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMessageBox() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: boxDecoration(Theme.of(context), _borderRadius),
            child: TextFormField(
                maxLines: null,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                controller: _messageController,
                decoration: inputDecoration(
                    Theme.of(context), _borderRadius, 'Enter Message...')),
          ),
        ),
        IconButton(
            onPressed: () => askBotQuestion(),
            icon: const Icon(Icons.send_outlined)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser?>(context);
    return Container(
      height: MediaQuery.of(context).size.width * 1.75,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Column(children: [
        Expanded(
          child: _buildMessageList(),
        ),
        const SizedBox(
          height: 10,
        ),
        buildMessageBox(),
      ]),
    );
  }
}
