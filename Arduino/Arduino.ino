//Max Martenot
//Alice Barbe, Beatriz Fusaro, Samuel Yeomans
//November 2016

// set I/O pins
const int switch1 = 8;
const int switch2 = 9;
const int switch3 = 10;
const int switch4 = 11;
const int switch5 = 12;
const int switch6 = 13;

const int led1 = 2;
const int led2 = 3;
const int led3 = 4;
const int led4 = 5;
const int led5 = 6;
const int led6 = 7;

const int button1 = 0;
const int button2 = 1;

const int pitchPot = A0;
const int reverbPot = A1;
const int pinPhoto = A3;

// set photoresistor range variables
float maxrange = 0;
float minrange = 1023;
float photoReading;
int photoValue;

// set potentiometer variables
int pitchValue; // running average of pitchPot

// define a list of 10 sensor values initialized to 0
int pitchValues[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

void setup() {
  pinMode(switch1, INPUT_PULLUP);
  pinMode(switch2, INPUT_PULLUP);
  pinMode(switch3, INPUT_PULLUP);
  pinMode(switch4, INPUT_PULLUP);
  pinMode(switch5, INPUT_PULLUP);
  pinMode(switch6, INPUT_PULLUP);
  pinMode(button1, INPUT_PULLUP);
  pinMode(button2, INPUT_PULLUP);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);
  pinMode(led5, OUTPUT);
  pinMode(led6, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  //calibrate photoresistor
  if (digitalRead(button1) == LOW) {
    minrange = analogRead(pinPhoto);
  }
  if (digitalRead(button2) == LOW) {
    maxrange = analogRead(pinPhoto);
  }
  photoReading = analogRead(pinPhoto);
  if (photoReading >= maxrange) {
    photoReading = int(maxrange);
  }
  if (photoReading <= minrange) {
    photoReading = int(minrange);
  }
  photoValue = round((photoReading - minrange) / (maxrange - minrange) * 100);
  
  // drive LEDs using switch values
  // switch1 drives led1
  if (digitalRead(switch1)) {
    digitalWrite(led1,HIGH);
  } else {
    digitalWrite(led1,LOW);
  }

  // switch2 drives led2
  if (digitalRead(switch2)) {
    digitalWrite(led2,HIGH);
  } else {
    digitalWrite(led2,LOW);
  }

  // switch3 drives led3
  if (digitalRead(switch3)) {
    digitalWrite(led3,HIGH);
  } else {
    digitalWrite(led3,LOW);
  }

  // switch4 drives led4
  if (digitalRead(switch4)) {digitalWrite(led4,HIGH);
  } else {
    digitalWrite(led4,LOW);
  }

  // switch5 drives led5
  if (digitalRead(switch5)) {
    digitalWrite(led5,HIGH);
  } else {
    digitalWrite(led5,LOW);
  }

  // switch6 drives led6
  if (digitalRead(switch6)) {
    digitalWrite(led6,HIGH);
  } else {
    digitalWrite(led6,LOW);
  }

  // calculate running average of pitchPot
  // shift pitchValues 0-8 to the left
  for (int i = 0; i < 9; i++) {
    pitchValues[i] = pitchValues[i+1];
  }
  // read the input on analog pin 0 and place at index 9 in pitchValues
  pitchValues[9] = analogRead(pitchPot);
  // take the average of pitchValues
  int pitchValue = 0;
  for (int i = 0; i < 10; i++) {
    pitchValue += pitchValues[i];
  }
  pitchValue = pitchValue / 10;
  
  // print inputs to console
  Serial.print(pitchValue, DEC);
  Serial.print(",");
  Serial.print(analogRead(reverbPot), DEC);
  Serial.print(",");
  Serial.print(digitalRead(switch1), DEC);
  Serial.print(",");
  Serial.print(digitalRead(switch2), DEC);
  Serial.print(",");
  Serial.print(digitalRead(switch3), DEC);
  Serial.print(",");
  Serial.print(digitalRead(switch4), DEC);
  Serial.print(",");
  Serial.print(digitalRead(switch5), DEC);
  Serial.print(",");
  Serial.print(digitalRead(switch6), DEC);
  Serial.print(",");
  Serial.println();
  delay(50);
}
