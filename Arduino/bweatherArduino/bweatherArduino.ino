#include <DHT.h>

#define DHT22_PIN 7

#define GP_MEASURE_PIN 3 // 连接模拟口 0
#define GP_LEDPOWER_PIN 3 // 连接数字口 2

// dht
DHT dht = DHT(DHT22_PIN, DHT22);

// sharp gp2y10
int samplingTime = 280;
int deltaTime = 40;
int sleepTime = 9680;

float voMeasured = 0;
float calcVoltage = 0;
float dustDensity = 0;

// bluetooth
int incomingByte = 0;
bool isConnected = false;

// data formate
String temperaturePrefix = String("1:");
String humidityPrefix = String("2:");
String pm25Prefix = String("3:");

void setup() {  
  Serial.begin(115200);
  pinMode(GP_LEDPOWER_PIN, OUTPUT);
  dht.begin();
}

void loop() {
   if(Serial.available() > 0) {
    incomingByte = Serial.read();
    if(incomingByte == 49) {
      isConnected = true;
    } else {
      isConnected = false;
    }
  }
  
  if(isConnected) {
    getTemperatureAndHumidity();
    getPM25Data();
  }
}

void getTemperatureAndHumidity() {
  boolean isRead = dht.read();
  if(isRead) {
    float tempTemperature = dht.readTemperature();
    Serial.println(temperaturePrefix + tempTemperature);
    delay(1000);
    
    float tempHumidity = dht.readHumidity();
    Serial.println(humidityPrefix + tempHumidity);
    delay(1000);
  } 
}

void getPM25Data() {
  // 开启内部 LED
  digitalWrite(GP_LEDPOWER_PIN, LOW);
  // 开启 LED 后的 280us 的等待时间
  delayMicroseconds(samplingTime);
  // 读取模拟值
  voMeasured = analogRead(GP_MEASURE_PIN);
  // 40us 等待时间
  delayMicroseconds(deltaTime);
  // 关闭 LED
  digitalWrite(GP_LEDPOWER_PIN, HIGH);
  // 0 - 5V mapped to 0 - 1023 integer values recover voltage
  delayMicroseconds(sleepTime);
  // 将模拟值转换为电压值
  calcVoltage = voMeasured * (5.0 / 1024.0);
  
  // linear eqaution taken from http:www.howmuchsnow.com/arduino/airquality/    
  // (Chris Nafis (c) 2012)
  // 将电压值转换为粉尘密度输出单位 ug/m3
  dustDensity = 1000 * (0.17 * calcVoltage - 0.1);
  
  Serial.println(pm25Prefix + dustDensity);
  delay(1000);
}

