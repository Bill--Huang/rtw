#include <DHT.h>

/*******************************************************

这个程序用来测试DHT22的温湿度。

********************************************************/
#define DHT22_PIN 7
DHT dht = DHT(DHT22_PIN, DHT22);


void setup() {
  
  Serial.begin(115200);
  dht.begin();
  Serial.println("DHT TEST PROGRAM ");
  Serial.println();
  Serial.println("Type,\tstatus,\tHumidity (%),\tTemperature (C)");
}

void loop() {
  
  
  Serial.print("DHT22, \t");
  boolean isRead = dht.read();  //读取数据
  if(isRead) {
    Serial.print(dht.readHumidity(), 1);
    Serial.print(",\t");
    Serial.println(dht.readTemperature(), 1);
  }
  // 显示数据
  delay(1000);
}
