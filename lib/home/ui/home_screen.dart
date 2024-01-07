import 'dart:async';
import 'dart:math';

import 'package:bulle/components/bubble/bubble_animation.dart';
import 'package:bulle/components/inputs/primary_button.dart';
import 'package:bulle/core/network/http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  late Room _room;
  String? _name;
  Participant? _participant;

  final List _participants = [];

  GlobalKey<BubbleAnimationState> mainBubbleKey = GlobalKey();

  void _createAndJoinRoom(String name) async {
    await _createRoom(name);
    var token = await _getToken(_name!, _name!);

    await _room.connect("wss://bulle-c2tm82ct.livekit.cloud", token);

    await _room.localParticipant?.setMicrophoneEnabled(true);
    await _room.setSpeakerOn(true);
    _participant = _room.localParticipant;
    _room.addListener(_onChange);
  }

  void _joinRoom(String room) async {
    var token = await _getToken(_name!, room);

    await _room.connect("wss://bulle-c2tm82ct.livekit.cloud", token);

    await _room.localParticipant?.setMicrophoneEnabled(true);
    await _room.setSpeakerOn(true);
    _participant = _room.localParticipant;
    _room.addListener(_onChange);
  }

  void _onChange() {
    print("nb participants: ${_room.participants.length}");
  }

  Future<String> _getToken(String name, String room) async {
    var context = {"identity": _generateIdentity(name), "name": name, "room": _generateRoom(room)};

    final response = await HttpClient.instance.dio.post('/tokens', data: context);

    return response.data['token'];
  }

  Future<void> _createRoom(String name) async {
    var room = {"name": _generateRoom(name)};

    await HttpClient.instance.dio.post('/rooms', data: room);
  }

  String _generateIdentity(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

  String _generateRoom(String name) {
    return _generateIdentity(name);
  }

  void _selectName() {
    TextEditingController textFieldController = TextEditingController();

    defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text("Enter your name"),
                content: CupertinoTextField(
                  controller: textFieldController,
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  CupertinoDialogAction(
                      onPressed: () {
                        setState(() {
                          _name = textFieldController.text;
                        });
                        Navigator.pop(context);
                      },
                      isDefaultAction: true,
                      child: const Text("Confirm")),
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Enter your name"),
                content: TextField(
                  controller: textFieldController,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _name = textFieldController.text;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Confirm")),
                ],
              );
            });
  }

  void _joinBubble() {
    TextEditingController textFieldController = TextEditingController();
    defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text("Your friend's name"),
                content: CupertinoTextField(
                  controller: textFieldController,
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  CupertinoDialogAction(
                      onPressed: () {
                        _joinRoom(textFieldController.text);
                        Navigator.pop(context);
                      },
                      isDefaultAction: true,
                      child: const Text("Join")),
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Your friend's name"),
                content: TextField(
                  controller: textFieldController,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        _joinRoom(textFieldController.text);
                        Navigator.pop(context);
                      },
                      child: const Text("Join")),
                ],
              );
            });
  }

  void _reset() {
    _participant?.unpublishAllTracks();
    _participant?.dispose();
    _participant = null;
    _room.removeListener(_onChange);
    _room.disconnect();
    _room = Room();
  }

  void _showChoiceModal() async {
    _reset();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 100,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _createAndJoinRoom(_name!);
                  },
                  child: Text("My Bubble",
                      style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 20),
                PrimaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _joinBubble();
                  },
                  child: Text("Join a bubble",
                      style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _reset();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _room = Room();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Opacity(
                    opacity: 0.7,
                    child: BubbleAnimation(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        radius: MediaQuery.of(context).size.width * 0.4,
                        amplitude: 3),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: BubbleAnimation(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        radius: MediaQuery.of(context).size.width * 0.4,
                        amplitude: 2),
                  ),
                  Opacity(
                    opacity: 0.9,
                    child: BubbleAnimation(
                        key: mainBubbleKey,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        radius: MediaQuery.of(context).size.width * 0.4,
                        participants: _participants,
                        amplitude: 1),
                  )
                ],
              );
            })),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_participants.length < 6) {
                        int rdm = Random().nextInt(100);
                        _participants.add({'id': rdm, 'avatar': 'https://i.pravatar.cc/100?u=$rdm'});
                      }
                    });
                  },
                  child: const Text("+"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_participants.isNotEmpty) {
                        _participants.removeLast();
                      }
                    });
                  },
                  child: const Text("-"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Welcome",
                    style:
                        TextStyle(fontFamily: 'Viking', fontWeight: FontWeight.w700, color: Colors.white, fontSize: 40),
                  ),
                  const Text(
                    "Talk to your friends and family whenever you want",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: () {
                        // if (_name == null) {
                        //   _selectName();
                        // } else {
                        //   _showChoiceModal();
                        // }
                        context.go('/onboarding');
                      },
                      child: Text("Get started",
                          style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
