// lib/widgets/loading_skeleton.dart
import 'package:flutter/material.dart';

class SkeletonThemeConfig {
  static const Color baseDark = Color(0xFF1A1A1A);
  static const Color highlightDark = Color(0xFF2A2A2A);
  static const Color cardDark = Color(0xFF141414);
  static const Color accent = Color(0xFFE57373);
}

class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.margin,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: SkeletonThemeConfig.baseDark,
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(-1.0 + _animation.value, 0),
                  end: Alignment(1.0 + _animation.value, 0),
                  colors: const [
                    SkeletonThemeConfig.baseDark,
                    SkeletonThemeConfig.highlightDark,
                    SkeletonThemeConfig.baseDark,
                  ],
                  stops: const [0.25, 0.5, 0.75],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: child,
            );
          },
          child: Container(color: SkeletonThemeConfig.baseDark),
        ),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const SkeletonText({
    super.key,
    required this.width,
    this.height = 12,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      margin: margin,
      borderRadius: BorderRadius.circular(8),
    );
  }
}

class DashboardLoadingSkeleton extends StatelessWidget {
  const DashboardLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonText(width: 140, height: 20),
          const SizedBox(height: 8),
          const SkeletonText(width: 220, height: 12),
          const SizedBox(height: 24),

          Row(
            children: const [
              Expanded(child: StatCardSkeleton()),
              SizedBox(width: 12),
              Expanded(child: StatCardSkeleton()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: StatCardSkeleton()),
              SizedBox(width: 12),
              Expanded(child: StatCardSkeleton()),
            ],
          ),
          const SizedBox(height: 20),

          const SectionHeaderSkeleton(),
          const SizedBox(height: 12),
          const ChartCardSkeleton(),
          const SizedBox(height: 20),

          const SectionHeaderSkeleton(),
          const SizedBox(height: 12),
          ...List.generate(
            5,
                (index) => const WatchlistTileSkeleton(),
          ),
        ],
      ),
    );
  }
}

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SkeletonThemeConfig.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonText(width: 70, height: 10),
          SizedBox(height: 14),
          SkeletonText(width: 100, height: 18),
          SizedBox(height: 10),
          SkeletonText(width: 60, height: 10),
        ],
      ),
    );
  }
}

class SectionHeaderSkeleton extends StatelessWidget {
  const SectionHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SkeletonText(width: 110, height: 16),
        SkeletonText(width: 50, height: 12),
      ],
    );
  }
}

class ChartCardSkeleton extends StatelessWidget {
  const ChartCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SkeletonThemeConfig.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonText(width: 120, height: 14),
          const SizedBox(height: 10),
          const SkeletonText(width: 180, height: 10),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              7,
                  (index) => SkeletonBox(
                width: 18,
                height: 50 + (index % 4) * 22,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class WatchlistTileSkeleton extends StatelessWidget {
  const WatchlistTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SkeletonThemeConfig.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: const [
          SkeletonBox(
            width: 44,
            height: 44,
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 90, height: 14),
                SizedBox(height: 8),
                SkeletonText(width: 60, height: 10),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonText(width: 70, height: 14),
              SizedBox(height: 8),
              SkeletonText(width: 50, height: 10),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatLoadingSkeleton extends StatelessWidget {
  const ChatLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      children: const [
        ChatBubbleSkeleton(isUser: false, widthFactor: 0.68),
        ChatBubbleSkeleton(isUser: true, widthFactor: 0.52),
        ChatBubbleSkeleton(isUser: false, widthFactor: 0.74),
        ChatBubbleSkeleton(isUser: true, widthFactor: 0.44),
      ],
    );
  }
}

class ChatBubbleSkeleton extends StatelessWidget {
  final bool isUser;
  final double widthFactor;

  const ChatBubbleSkeleton({
    super.key,
    required this.isUser,
    required this.widthFactor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.all(14),
        width: screenWidth * widthFactor,
        decoration: BoxDecoration(
          color: isUser
              ? SkeletonThemeConfig.accent.withOpacity(0.18)
              : SkeletonThemeConfig.cardDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonText(width: 180, height: 12),
            SizedBox(height: 8),
            SkeletonText(width: 130, height: 12),
            SizedBox(height: 10),
            SkeletonText(width: 40, height: 10),
          ],
        ),
      ),
    );
  }
}

class HistoryLoadingSkeleton extends StatelessWidget {
  const HistoryLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: SkeletonThemeConfig.cardDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          child: const Row(
            children: [
              SkeletonBox(
                width: 46,
                height: 46,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(width: 140, height: 14),
                    SizedBox(height: 8),
                    SkeletonText(width: 90, height: 10),
                  ],
                ),
              ),
              SkeletonText(width: 54, height: 12),
            ],
          ),
        );
      },
    );
  }
}