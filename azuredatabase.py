import mysql.connector
from azure.eventhub import EventHubConsumerClient
import threading
import json
from datetime import datetime

# Función para manejar los eventos recibidos
def on_event(partition_context, event):
    # Parsea el cuerpo del evento que es un JSON
    event_data = json.loads(event.body_as_str())

    print("Evento recibido:", event_data)

    # Extrae los datos necesarios
    temperatura = event_data.get('temperatura')
    humedad = event_data.get('humedad')
    frecuencia = event_data.get('frecuencia')

    # Conectar a la base de datos
    connection = mysql.connector.connect(
        host="localhost",
        user="Usuario",
        password="G3neric@12",
        database="iotdatabase"
    )
    cursor = connection.cursor()

    # Diccionario para mapear los tipos de datos a los IDs de sensores
    sensor_ids = {
        'humedad': 1,
        'temperatura': 2,
        'frecuencia': 3
    }

    # Insertar datos en la tabla correspondiente
    if humedad is not None:
        sql = "INSERT INTO humedad (idsensor, valor) VALUES (%s, %s)"
        val = (1, humedad)
        cursor.execute(sql, val)
    
    if temperatura is not None:
        sql = "INSERT INTO temperatura (idsensor, valor) VALUES (%s, %s)"
        val = (2, temperatura)
        cursor.execute(sql, val)
    
    if frecuencia is not None:
        sql = "INSERT INTO frecuencia_cardiaca (idsensor, valor) VALUES (%s, %s)"
        val = (3, frecuencia)
        cursor.execute(sql, val)
    
    # Hacer commit de los cambios y cerrar la conexión
    connection.commit()
    cursor.close()
    connection.close()

    # Notificar en la consola
    print("Datos insertados")

# Función que espera la presión de una tecla para detener el cliente
def wait_for_keypress(client):
    input("Presione cualquier tecla para detener...\n")
    client.close()

def main():
    # cadena de conexión de Event Hub
    connection_str = 'Endpoint=sb://iotfinal.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=SCdhQjlNV68zosztpxLqhhBnTIiW5sl0B+AEhCAMGsY='
    consumer_group = '$Default'  # Consumer Group predeterminado

    # Crea un cliente de Event Hub
    client = EventHubConsumerClient.from_connection_string(connection_str, consumer_group, eventhub_name='iotfinal')

    # Inicia la recepción de eventos en un hilo separado
    receive_thread = threading.Thread(target=client.receive, args=(on_event,))
    receive_thread.start()

    # Espera la presión de una tecla y luego detiene el cliente
    wait_for_keypress(client)

    # Asegurarse de que el hilo de recepción ha terminado
    receive_thread.join()

if __name__ == '__main__':
    main()
