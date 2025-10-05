import 'dart:math';
import 'custom_draw.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stroke_text/stroke_text.dart';

double normalize(double value, min, max) => ((value - min) / (max - min));

class SliderWidget extends StatefulWidget {
  final double initialVal;

  const SliderWidget({
    required this.initialVal,
    super.key,
  });

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double progressVal = normalize(widget.initialVal, -10, 70);
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: size.width * 0.538,
            child: const Image(
              image: AssetImage(
                'images/modules/RadialSlider.png',
              ),
              alignment: Alignment.center,
            ),
          ),
        ),
        ShaderMask(
          shaderCallback: (rect) {
            return SweepGradient(
              startAngle: 0,
              endAngle: 3 * pi / 2,
              colors: [
                (progressVal <= 0.3125)
                    ? Colors.blueAccent
                    : (progressVal <= 0.5)
                    ? Colors.green
                    : Colors.redAccent,
                const Color(0xFF665B6C)
              ],
              stops: [progressVal, progressVal],
              transform: const GradientRotation(
                3 * pi / 4,
              ),
            ).createShader(rect);
          },
          child: const Center(
            child: CustomArc(),
          ),
        ),
        Center(
          child: Container(
            width: size.width * 0.625 - size.width * 0.063,
            height: size.width * 0.625 - size.width * 0.063,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0),
                  width: size.width * 0.035,
                  style: BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: normalize(progressVal * 20000, 100, 255) + 1,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: -6,
                      color: (progressVal <= 0.3125)
                          ? Colors.blueAccent
                          : (progressVal <= 0.5)
                          ? Colors.green
                          : Colors.redAccent,
                      offset: const Offset(0, 0))
                ]),
            child: SleekCircularSlider(
              min: -10,
              max: 70,
              initialValue: widget.initialVal,
              appearance: CircularSliderAppearance(
                animationEnabled: true,
                startAngle: 135,
                angleRange: 270,
                size: size.width * 0.625 - size.width * 0.063,
                customWidths: CustomSliderWidths(
                  trackWidth: size.width * 0.010,
                  progressBarWidth: size.width * 0.040,
                  handlerSize: 0,
                ),
                customColors: CustomSliderColors(
                  hideShadow: true,
                  shadowColor: (progressVal <= 0.3125)
                      ? Colors.blueAccent
                      : (progressVal <= 0.5)
                      ? Colors.green
                      : Colors.redAccent,
                  progressBarColor: (progressVal <= 0.3125)
                      ? Colors.blueAccent
                      : (progressVal <= 0.5)
                      ? Colors.green
                      : Colors.redAccent,
                  trackColor: (progressVal <= 0.3125)
                      ? Colors.blueAccent.withOpacity(0.2)
                      : (progressVal <= 0.5)
                      ? Colors.green.withOpacity(0.2)
                      : Colors.redAccent.withOpacity(0.2),
                  dotColor: Colors.transparent,
                ),
              ),
              innerWidget: (percentage) {
                return Center(
                  child: StrokeText(
                    text: '${percentage.toInt()}°c',
                    strokeWidth: size.width * 0.006,
                    textStyle: TextStyle(
                        color: (progressVal <= 0.3125)
                            ? Colors.blueAccent
                            : (progressVal <= 0.5)
                            ? Colors.green
                            : Colors.redAccent,
                        fontSize: size.width * 0.104,
                        shadows: [
                          Shadow(
                            color: (progressVal <= 0.3125)
                                ? Colors.blueAccent.withOpacity(0.8)
                                : (progressVal <= 0.5)
                                ? Colors.green.withOpacity(0.8)
                                : Colors.redAccent.withOpacity(0.8),
                            offset: const Offset(0, 0),
                            blurRadius: 15,
                          )
                        ]),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
