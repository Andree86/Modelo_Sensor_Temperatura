#include <OneWire.h> /Esta libreria se encarga de implementar el protocolo completo de comunicación 1-wire,
/el cual permite realizar una comunicación serial asincronica entre un maestro y varios esclavos, otorgando
/una identificación unica a través de la ROM.

OneWire ourWire(2);     /Se establece el pin 2  como bus OneWire

void setup(void) {
  Serial.begin(9600);
}
/El siguiente codigo permite al arduino leer e imprimir cada una de las direcciones o identificaciones de cada
/Cada dispositivo de forma Hexadecimal, para poder realizar el siguiente codigo a un solo Pin
void loop(void) {
  byte addr[8];  
  Serial.println("Obteniendo direcciones:");
  while (ourWire.search(addr)) 
  {  
  Serial.print("Address = ");
  for( int i = 0; i < 8; i++) {
    Serial.print(" 0x");
    Serial.print(addr[i], HEX);
  }
  Serial.println();
}

Serial.println();
ourWire.reset_search();
delay(2000);
}
