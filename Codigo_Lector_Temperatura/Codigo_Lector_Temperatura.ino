#include <OneWire.h>                
#include <DallasTemperature.h>
#include <TimerOne.h>
 
OneWire ourWire(2);                //Se establece el pin 2  como bus OneWire
 
DallasTemperature sensors(&ourWire); //Se declara una variable u objeto para nuestro sensor

DeviceAddress address1 = {0x28, 0x54, 0x14, 0x80, 0xE3, 0xE1, 0x3C, 0xD9};//dirección del sensor 1
DeviceAddress address2 = {0x28, 0x4E, 0xA7, 0x58, 0xD4, 0xE1, 0x3C, 0xF5};//dirección del sensor 2
DeviceAddress address3 = {0x28, 0xDB, 0x47, 0x80, 0xE3, 0xE1, 0x3C, 0xCC};//dirección del sensor 3


void setup() {
  delay(1000);
  Serial.begin(9600);
  sensors.begin();   //Se inicia el sensor
}
 
void loop() {
  // Variables locales
  float aux[3];
  uint16_t temp[3];
  byte temp_valorL[3],temp_valorH[3],buffer_tx[8];
  // Lectura de Datos
  sensors.requestTemperatures();   //envía el comando para obtener las temperaturas
  aux[0]= sensors.getTempC(address1);//Se obtiene la temperatura en °C del sensor 1
  aux[1]= sensors.getTempC(address2);//Se obtiene la temperatura en °C del sensor 2
  aux[2]= sensors.getTempC(address3);//Se obtiene la temperatura en °C del sensor 3
  // Converción a tipo entero
  temp[0] = aux[0]*100;
  temp[1] = aux[1]*100;
  temp[2] = aux[2]*100;
  // Converción a timpo byte
  temp_valorL[0] = temp[0] & 0xFF;
  temp_valorH[0] = (temp[0] >> 8) & 0xFF;
  temp_valorL[1] = temp[1] & 0xFF;
  temp_valorH[1] = (temp[1] >> 8) & 0xFF;
  temp_valorL[2] = temp[2] & 0xFF;
  temp_valorH[2] = (temp[2] >> 8) & 0xFF;
  // Asignación
  buffer_tx[0] = 'A';
  buffer_tx[1] = temp_valorL[0];
  buffer_tx[2] = temp_valorH[0];
  buffer_tx[3] = temp_valorL[1];
  buffer_tx[4] = temp_valorH[1];
  buffer_tx[5] = temp_valorL[2];
  buffer_tx[6] = temp_valorH[2];
  buffer_tx[7] = '\n';
  // Transmición de datos
  Serial.write(buffer_tx,8);

  delay(10);
}
