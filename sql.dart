import 'package:mysql1/mysql1.dart';

Future<Map<String, dynamic>> fetchLatestValues() async {
  var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'Usuario',
    db: 'iotdatabase',
    password: 'G3neric@12',
  );

  var conn = await MySqlConnection.connect(settings);
  var results = await conn.query(
    'SELECT valor FROM humedad ORDER BY fecha DESC, hora DESC LIMIT 1');
  var humedad = results.first.fields['valor'];

  results = await conn.query(
    'SELECT valor FROM temperatura ORDER BY fecha DESC, hora DESC LIMIT 1');
  var temperatura = results.first.fields['valor'];

  results = await conn.query(
    'SELECT valor FROM frecuencia_cardiaca ORDER BY fecha DESC, hora DESC LIMIT 1');
  var frecuenciaCardiaca = results.first.fields['valor'];

  await conn.close();

  return {
    'humedad': humedad,
    'temperatura': temperatura,
    'frecuenciaCardiaca': frecuenciaCardiaca,
  };
}

Future<List<Map<String, dynamic>>> fetch30Measurements(String tableName) async {
  var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'Usuario',
    db: 'iotdatabase',
    password: 'G3neric@12',
  );

  var conn = await MySqlConnection.connect(settings);
  var results = await conn.query(
    'SELECT valor, fecha, hora FROM $tableName ORDER BY fecha DESC, hora DESC LIMIT 15');
  
  List<Map<String, dynamic>> measurements = [];
  for (var row in results) {
    measurements.add({
      'valor': row[0],
      'fecha': row[1],
      'hora': row[2],
    });
  }

  await conn.close();

  return measurements;
}
