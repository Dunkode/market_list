/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Render the default doughnut chart.
class DoughnutDefault extends StatefulWidget {
  final int qtdRec;
  final int qtdDisp;
  final DisponivelColor;
  final textTittleHint;
  final textInnerHint;


  const DoughnutDefault(this.qtdDisp, this.qtdRec, this.DisponivelColor, this.textTittleHint ,{this.textInnerHint});

  @override
  _DoughnutDefaultState createState() => _DoughnutDefaultState();
}

/// State class of doughnut chart.
class _DoughnutDefaultState extends State<DoughnutDefault> {
  _DoughnutDefaultState();

  late bool isCardView = true;

  @override
  Widget build(BuildContext context) {
    return _buildDefaultDoughnutChart();
  }

  /// Return the circular chart with default doughnut series.
  SfCircularChart _buildDefaultDoughnutChart() {
    return SfCircularChart(
      title: ChartTitle(text: widget.textTittleHint),
      legend: Legend(
          isVisible: isCardView, overflowMode: LegendItemOverflowMode.wrap),
      series: _getDefaultDoughnutSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
      annotations: [CircularChartAnnotation(widget: widget.textInnerHint == null ? null : widget.textInnerHint)],
    );
  }

  /// Returns the doughnut series which need to be render.
  List<DoughnutSeries<ChartSampleData, String>> _getDefaultDoughnutSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Quantidade\nDisponível',
          y: widget.qtdDisp,
          text: '${widget.qtdDisp}',
          pointColor: widget.DisponivelColor),
      ChartSampleData(
          x: 'Quantidade\nRecomendada',
          y: widget.qtdRec,
          text: '${widget.qtdRec}',
          pointColor: Colors.greenAccent),
    ];
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          innerRadius: "80%",
          radius: '90%',
          explode: true,
          explodeOffset: '10%',
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
