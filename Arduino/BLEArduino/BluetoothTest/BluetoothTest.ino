

int stringFromBluetooth;
void setup() {
  Serial.begin(9600);               //initial the Serial
  Serial.println("Bluetooth Test");
  Serial.write("Bluetooth Test");
}

void loop() {
  if(Serial.available()) {
    stringFromBluetooth = Serial.read();
//    int test = Serial.read();
//    Serial.println("int test: " + test);
    Serial.println("Bluetooth: " + stringFromBluetooth);
    Serial.write("Bluetooth: " + stringFromBluetooth);    //send what has been received
  }
}
