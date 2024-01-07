import 'package:bulle/components/bubble/circle_layout_delegate.dart';
import 'package:bulle/components/bubble/participant_bubble.dart';
import 'package:flutter/material.dart';

class Participants extends StatefulWidget {
  const Participants({required this.participants, super.key});

  final List participants;

  @override
  State<Participants> createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  final double _radius = 70;

  @override
  Widget build(BuildContext context) {
    //_evalNoise();

    return CustomMultiChildLayout(
        delegate: CircleLayoutDelegate(itemCount: widget.participants.length, wrapRadius: 80, shapeRadius: _radius),
        children: [
          for (var i = 0; i < widget.participants.length; i++)
            LayoutId(
              id: i,
              child: ParticipantBubble(
                radius: _radius,
                participant: widget.participants[i],
              ),
            ),
        ]);
  }
}
