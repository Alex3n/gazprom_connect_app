import 'dart:math';
import 'package:flutter/material.dart';
export 'Circle.dart';

/// Mediates indicator building and animation.
class Indicator {
  /// [normalController] Animation controller when state changes to normal
  /// [highlightedController] Animation controller when state changes to selected
  /// [widget] Indicator widget
  /// [builder] Widgetbuilder object
  /// [index] Determine index on the stack
  Indicator({
    this.normalController,
    this.highlightedController,
    this.widget,
    this.builder,
    this.index,
  });

  final AnimationController normalController;
  final AnimationController highlightedController;
  final Widget widget;
  final WidgetBuilder builder;
  final int index;

  void dispose() {
    normalController.dispose();
    highlightedController.dispose();
  }
}

typedef Widget IndicatorBuilder(AnimationController controller, int index);

/// The Indicator Widget, you would likely put it next to your PageView.
class PageViewIndicator extends StatefulWidget {
  /// [pageIndexNotifier] is how we can properly handle page changes.
  /// [length] is how much pages there is in the [PageView].
  /// [normalBuilder] is how we should build the Indicator at its normal state.
  /// [highlightedBuilder] is how we should build the Indicator at its highlighted state.
  /// [currentPage] gives you the ability to star the Indicator at a given index.
  /// [indicatorPadding] space around each Indicator.
  PageViewIndicator({
    Key key,
    @required this.pageIndexNotifier,
    @required this.length,
    @required this.normalBuilder,
    @required this.highlightedBuilder,
    this.currentPage = 0,
    this.indicatorPadding = const EdgeInsets.all(8.0),
    this.alignment = MainAxisAlignment.center,
  }) : super(key: key);

  final ValueNotifier<int> pageIndexNotifier;
  final int length;
  final IndicatorBuilder normalBuilder;
  final IndicatorBuilder highlightedBuilder;
  final int currentPage;
  final EdgeInsets indicatorPadding;
  final MainAxisAlignment alignment;

  @override
  _PageViewIndicatorState createState() => _PageViewIndicatorState();
}

class _PageViewIndicatorState extends State<PageViewIndicator>
    with TickerProviderStateMixin {
  List<Indicator> _indicators;
  int _prevPage;

  void _indicatorsListener() {
    final currPage = widget.pageIndexNotifier.value;

    if (currPage != _prevPage) {
      _indicators[_prevPage].normalController.forward();
      _indicators[_prevPage].highlightedController.reverse();

      _indicators[currPage].normalController.reverse();
      _indicators[currPage].highlightedController.forward();

      _prevPage = currPage;
    }
  }

  void _addIndicatorsListener() {
    widget.pageIndexNotifier.removeListener(_indicatorsListener);
    widget.pageIndexNotifier.addListener(_indicatorsListener);
  }

  @override
  void initState() {
    super.initState();
    _prevPage = max(0, widget.currentPage);

    _indicators = List.generate(
        widget.length,
        (index) => Indicator(
            index: index,
            normalController: AnimationController(
              vsync: this,
              duration: Duration(microseconds: 200),
            )..forward(),
            highlightedController: AnimationController(
              vsync: this,
              duration: Duration(milliseconds: 200),
            )));

    _indicators[widget.currentPage].normalController.reverse();
    _indicators[widget.currentPage].highlightedController.forward();

    _addIndicatorsListener();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _addIndicatorsListener();
  }

  @override
  void dispose() {
    _indicators.forEach((indicator) => indicator.dispose());
    widget.pageIndexNotifier.removeListener(_indicatorsListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: widget.alignment,
      children: _indicators
          .map<Widget>((indicator) =>
              _buildIndicator(indicator))
          .toList(),
    );
  }

  Widget _buildIndicator(Indicator indicator) {
    return Padding(
      padding: widget.indicatorPadding,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          widget.normalBuilder(indicator.normalController, indicator.index),
          widget.highlightedBuilder(
              indicator.highlightedController, indicator.index),
        ],
      ),
    );
  }
}
