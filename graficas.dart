import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sql.dart'; // Asegúrate de que este import refleje la ubicación correcta de tu archivo sql.dart
import 'dart:math';
class GraficasScreen extends StatelessWidget {
  const GraficasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GraficaTitulo('Temperatura', 'temperatura'),
            GraficaTitulo('Humedad', 'humedad'),
            GraficaTitulo('Frecuencia Cardiaca', 'frecuencia_cardiaca'),
          ],
        ),
      ),
    );
  }
}

class GraficaTitulo extends StatelessWidget {
  final String titulo;
  final String tableName;

  const GraficaTitulo(this.titulo, this.tableName);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetch30Measurements(tableName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Grafica(data: snapshot.data!, titulo: titulo);
        } else {
          return Text('No hay datos disponibles');
        }
      },
    );
  }
}

class Grafica extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String titulo;

  const Grafica({required this.data, required this.titulo});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = data.asMap().entries.map((e) {
      var yValue = e.value['valor'] as double;
      var xValue = e.key.toDouble();
      return FlSpot(xValue, yValue);
    }).toList();

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              titulo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: const FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minY: spots.map((spot) => spot.y).reduce(min) * 0.95, // Reduce el valor mínimo en un 5%
                  maxY: spots.map((spot) => spot.y).reduce(max) * 1.05, // Aumenta el valor máximo en un 5%
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
