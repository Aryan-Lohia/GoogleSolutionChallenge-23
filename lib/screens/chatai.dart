import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

import '../utils/app_style.dart';

class ChatAI extends StatefulWidget {
  const ChatAI({Key? key}) : super(key: key);

  @override
  State<ChatAI> createState() => _ChatAIState();
}

class _ChatAIState extends State<ChatAI> {
  String name = "Chat AI";
  bool querySent = false;
  String query = "";
  String reply = "";
  bool replyTyping = false;
  bool queyReplied = false;
  TextEditingController _input = TextEditingController();
  late final openAI;

  Future<void> chatCompleteWithSSE() async{
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": query})
    ], maxToken: 200, model: kChatGptTurbo0301Model);
    openAI.onChatCompletionSSE(
        request: request,
        complete: (it) {
          it.map((data) => utf8.decode(data)).listen((data) {
            try {
              reply += data != " data: [DONE]"
                  ? jsonDecode((data as String).substring(6))['choices'][0]
                      ['delta']['content']
                  : ".";
              reply = reply.trim();
              queyReplied = true;
              if(mounted) {
                setState(() {});
              }
            } catch (e) {
              print(e);
            }
          }).onError((e) {
            reply =
                "We are currently experiencing some issues. Please try again later.";
            queyReplied = true;
            setState(() {});
          });
        });
  }

  void sendQuery() async {
    reply = "";
    setState(() {});
    if (_input.text.isNotEmpty) {
      query = _input.text;
      querySent = true;
      replyTyping=true;
      _input.clear();
      if(mounted) {
        setState(() {});
      }
      await chatCompleteWithSSE();
      setState(() {
        replyTyping=false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    openAI = OpenAI.instance.build(
        token: "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",
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
        isLog: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          title: Text(
            "Talk to Us",
            style: TextStyle(
                fontSize: 24,
                color: Colors.orange,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.42,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 50),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                            ),
                            ChatCard(
                                data: "Welcome to $name. How may I help you?",
                                sender: name),
                          ],
                        ),
                        querySent
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ChatCard(data: query, sender: "sender"),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        queyReplied
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                                  ChatCard(data: reply, sender: name),
                                ],
                              )
                            : Container(),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 50,
                        controller: _input,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orangeAccent)),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: sendQuery, icon: const Icon(Icons.send))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  String sender;
  String data;

  ChatCard({Key? key, required this.data, required this.sender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                offset: sender != "Chat AI" ? Offset(-5, 5) : Offset(5, 5))
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.fromBorderSide(BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 110,
              child: Text(
                textAlign:
                    sender != "Chat AI" ? TextAlign.right : TextAlign.left,
                sender,
                style: Styles.headlineStyle3.copyWith(color: Colors.orange),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                width: MediaQuery.of(context).size.width - 110,
                child: SelectableText(
                  data,
                  textAlign:
                      sender != "Chat AI" ? TextAlign.right : TextAlign.left,
                ))
          ],
        ),
      ),
    );
  }
}
