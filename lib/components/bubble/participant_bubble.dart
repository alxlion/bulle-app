import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ParticipantBubble extends StatefulWidget {
  const ParticipantBubble({super.key, this.radius = 70, required this.participant});

  final double radius;
  final Map participant;

  @override
  State<ParticipantBubble> createState() => _ParticipantBubbleState();
}

class _ParticipantBubbleState extends State<ParticipantBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.1).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: CircleAvatar(
        radius: widget.radius / 2,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: widget.radius / 2 - 2,
          child: CachedNetworkImage(
            imageUrl: widget.participant['avatar'],
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
