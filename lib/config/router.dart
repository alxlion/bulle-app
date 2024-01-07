import 'dart:math';

import 'package:bulle/home/ui/home_screen.dart';
import 'package:bulle/onboarding/ui/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'onboarding',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const OnboardingScreen(),
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return _CircleZoomTransition(animation: animation, child: child);
            },
          ),
        ),
      ],
    ),
  ],
);

class _CircleZoomTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _CircleZoomTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final size = MediaQuery.of(context).size;
        final radiusTween = Tween(begin: 0.0, end: size.diagonal / 2);
        final radius = radiusTween.evaluate(animation) + 100;

        return ClipOval(
          clipper: _CircleClipper(radius, size.center(const Offset(0, -100))),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _CircleClipper extends CustomClipper<Rect> {
  final double radius;
  final Offset center;

  _CircleClipper(this.radius, this.center);

  @override
  Rect getClip(Size size) => Rect.fromCircle(center: center, radius: radius);

  @override
  bool shouldReclip(_CircleClipper oldClipper) => radius != oldClipper.radius || center != oldClipper.center;
}

extension on Size {
  double get diagonal => sqrt(width * width + height * height);
  Offset center(Offset origin) => Offset(width / 2, height / 2) + origin;
}
