
int lightPin = 13;
unsigned long tepTimer ;

void setup() {
  pinMode(lightPin, OUTPUT);
  Serial.begin(9600);        //设置波特率为9600 bps
  
  Serial.println("Temperature Detection Start");
  
}

void loop() {
  
  int valueFromLM35 = analogRead(0);
  
  // convert to temperature
  double temperatureData = (double) valueFromLM35 * (5 / 10.24);

  if (temperatureData >= 19) {
    //
    digitalWrite(lightPin, HIGH);
  } else {
    // switch off light
    digitalWrite(lightPin, LOW);
  }

  if (millis() - tepTimer > 500) {
    tepTimer = millis();
    Serial.print("Temperature: ");
    Serial.print(temperatureData);
    Serial.println(" C");
  }
}
