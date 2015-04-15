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



void setup() {
  Serial.begin(115200);
  pinMode(ledPower, OUTPUT);
  
  StandardPrint("Sharp GP2Y10 + Bluetooth");
  
}

void loop() {
  
  if(Serial.available()) {
    stringFromBluetooth = Serial.read();
//    int test = Serial.read();
//    Serial.println("int test: " + test);
//    Serial.write("M2B");
    Serial.write("Yes, come from bluetooth");
//    Serial.write("B2M: Dust2");
  }
  
  
  
//  digitalWrite(ledPower, LOW); //开启内部 LED
//  delayMicroseconds(samplingTime); // 开启 LED 后的 280us 的等待时间
//
//  voMeasured = analogRead(measurePin); // 读取模拟值
//
//  delayMicroseconds(deltaTime); // 40us 等待时间
//  digitalWrite(ledPower, HIGH); // 关闭 LED
//  delayMicroseconds(sleepTime);
//  // 0 - 5V mapped to 0 - 1023 integer values
//  // recover voltage
//  calcVoltage = voMeasured * (5.0 / 1024.0); //将模拟值转换为电压值
//  
//  // linear eqaution taken from http://www.howmuchsnow.com/arduino/airquality/
//  // Chris Nafis (c) 2012
//  dustDensity = 0.17 * calcVoltage - 0.1; //将电压值转换为粉尘密度输出单位
//  
//  StandardPrint("Raw Signal Value (0-1023): ");
//  StandardPrint(Float2Str(voMeasured));
//
//  StandardPrint(" - Voltage: ");
//  StandardPrint(Float2Str(calcVoltage));
//  StandardPrint(" - Dust Density: ");
//  StandardPrint(Float2Str(dustDensity)); // 输出单位: 毫克/立方米
//  delay(1000);
}

void StandardPrint(const char* temp) {
//  Serial.println(temp);
  Serial.write(temp);
}

char* Float2Str(float f) {
  char temp[256];
  sprintf(temp, "%f", f);
  return temp;
}
