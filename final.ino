#include <NXTIoT_dev.h>
#include "DHT.h"

NXTIoT_dev mysigfox;
const int boton = 6;
const int sensorPin1 = A0;  // Pin del primer sensor analógico
const int sensorPin2 = A1;  // Pin del segundo sensor analógico
const int sensorPin3 = A2;   // Pin del sensor DHT11

DHT dht(sensorPin3, DHT11);

float temp; // Variable para almacenar la temperatura del primer sensor
float humedad; // Variable para almacenar la humedad del sensor DHT
int promedioFrecuencia; // Variable para almacenar el promedio de frecuencia cardíaca

void setup()
{
  Serial.begin(9600);
  pinMode(boton, INPUT);
  dht.begin();
}

void leer_temperatura()
{
  // Código para el primer sensor de temperatura
  int sensorVal = analogRead(sensorPin1);
  float voltaje = (sensorVal / 1023.0) * 5;
  Serial.print("Voltaje: ");
  Serial.println(voltaje);
  Serial.print("Grados Cº: ");
  temp = (voltaje) * 100;
  Serial.println(temp);
}

void leer_temperatura_dht()
{
  // Código para el sensor de temperatura DHT
  humedad = dht.readHumidity();
  float temperatura = dht.readTemperature();

  if (isnan(humedad) || isnan(temperatura))
  {
    Serial.println("no jala");
    return;
  }

  Serial.print("Humedad: ");
  Serial.print(round(humedad));
  Serial.print("%, ");

  Serial.print("Temperatura: ");
  Serial.print(temperatura);
  Serial.println("°C");
}

void leer_frecuencia_cardiaca()
{
  // Código para el segundo sensor de frecuencia cardíaca
  int sumaFrecuencia = 0;
  int conteoLecturas = 0;

  for (int i = 0; i < 5; i++)
  {
    int heartRate = map(analogRead(sensorPin2), 0, 1023, 0, 150);
    sumaFrecuencia += heartRate;
    conteoLecturas++;
    Serial.print("Heart rate: ");
    Serial.println(heartRate);
  }

  if (conteoLecturas == 5)
  {
    promedioFrecuencia = sumaFrecuencia / conteoLecturas;
    Serial.print("Promedio de las 5 mediciones: ");
    Serial.println(promedioFrecuencia);
  }
}

void enviar_datos_a_sigfox()
{
  mysigfox.initpayload();
  mysigfox.addfloat(temp);
  mysigfox.addfloat(humedad);
  mysigfox.addint(promedioFrecuencia);
  mysigfox.sendmessage();
}

void loop()
{
  if (digitalRead(boton) == LOW)
  {
    // Llamar a la función para el primer sensor de temperatura
    leer_temperatura();
    delay(500);

    // Llamar a la función para el sensor de temperatura DHT
    leer_temperatura_dht();
    delay(500);

    // Llamar a la función para el segundo sensor de frecuencia cardíaca
    leer_frecuencia_cardiaca();
    delay(1000);

    // Llamar a la función para enviar los datos a Sigfox
    enviar_datos_a_sigfox();
  }
}
