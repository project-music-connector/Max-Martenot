float maxrange;
float minrange;
float val;
int pin = A0;
void setup() {
  minrange = 0;
  maxrange = 1023;
  Serial.begin(9600);
}

void loop() {
  if (digitalRead(8) == HIGH) {
    minrange = analogRead(pin);
  }
  if (digitalRead(9) == HIGH) {
    maxrange = analogRead(pin);
  }
  val = analogRead(pin);
  if (val >= maxrange) {
    val = int(maxrange);
  }
  if (val <= minrange) {
    val = int(minrange);
  }
  Serial.print(round((val-minrange)/(maxrange - minrange) * 100), DEC);
  Serial.print('\n');
}
