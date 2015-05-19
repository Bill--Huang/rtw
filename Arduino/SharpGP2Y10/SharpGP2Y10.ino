// Add Bluetooth module
int stringFromBluetooth;

int measurePin = 0; // 连接模拟口 0
int ledPower = 2; // 连接数字口 2

int samplingTime = 280;
int deltaTime = 40;
int sleepTime = 9680;

float voMeasured = 0;
float calcVoltage = 0;
float dustDensity = 0;


int incomingByte = 0;
bool isConnected = false;

void setup() {
  Serial.begin(115200);
  pinMode(ledPower, OUTPUT);

  //StandardPrint("Sharp GP2Y10 + Bluetooth");

}

void loop() {
  if(Serial.available() > 0) {
    incomingByte = Serial.read();
    if(incomingByte == 49) {
      Serial.print("Connected ");
      isConnected = true;
      //delay(1000);
      //sendPM25Data();
      //Serial.println(incomingByte, DEC);
    } else {
      Serial.print("No Connected");
      isConnected = false;
    }
    
    // say what you got:
    //Serial.print("I received: ");
    //Serial.println(incomingByte, DEC);
    //delay(1000);
  }
  if(isConnected) {
    getPM25Data();
  }
}

void getPM25Data() {
    digitalWrite(ledPower, LOW);// 开启内部 LED
    delayMicroseconds(samplingTime);//  开启 LED 后的 280us 的等待时间
  
    voMeasured = analogRead(measurePin);//  读取模拟值
  
    delayMicroseconds(deltaTime);//  40us 等待时间
    digitalWrite(ledPower, HIGH);//  关闭 LED
    delayMicroseconds(sleepTime);// 0 - 5V mapped to 0 - 1023 integer values recover voltage
    calcVoltage = voMeasured * (5.0 / 1024.0);// 将模拟值转换为电压值
  
     //linear eqaution taken from http:www.howmuchsnow.com/arduino/airquality/Chris Nafis (c) 2012
    dustDensity = 1000 * (0.17 * calcVoltage - 0.1);// 将电压值转换为粉尘密度输出单位
    
    Serial.println(dustDensity);
    delay(1000);
}

void sendPM25Data() {
    Serial.println("PM25");
    Serial.print(dustDensity);//  输出单位: ug/m3
    //
}



