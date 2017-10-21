// Max Martenot
// Alice Barbe, Beatriz Fusaro, Samuel Yeomans
// March 2017

/*-------------Program Description--------------
Hardware inputs:
  - 6 switches, Digital I/O pins
  - 2 buttons, Analog pins (read digitally)
  - 2 potentiometers, Analog pins
  - 1 photoresistor, Analog pin
Hardware outputs:
  - 6 LEDS, Digital I/O pins 2-7
Serial output:
  - pitchValue: running average of the previous 10 values,
                adjusted between a maximum and minimum (set
                using button). pitchValue ranges from 0 - 1023.
  - analogRead(reverbPot): raw value of reverbPot, ranges from 0 - 1023.
  - photoValue: photosensor value adjusted between a maximum and
                minimum (set using button). 
                photoValue ranges from 0 - 1023.
  - digitalRead(switches 1 - 6): raw value of switches. Values are 0 or 1.
*/

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

const int button1 = A4;
const int button2 = A3;

const int pitchPot = A2;
const int reverbPot = A1;
const int pinPhoto = A0;

// set photoresistor range variables
float maxrange = 0;     // minimum photoresistor value (complete light)
float minrange = 1023;  // maximum photoresistor value (complete dark)
float photoReading;     // photosensor reading
int photoValue;         // adjusted photosensor value
boolean count = true;   // button count

// set pitch range variables
boolean count2 = true;  // button count
int zeropitch = 0;      // minimum potentiometer value in range
int maxpitch = 1023;    // maximum potentiometer value in range
int pitchValue;         // running average of pitchPot

// define a list of 10 sensor values initialized to 0
int pitchValues[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int i = 0;

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
  // calibrate photoresistor: set minimum and maximum photoresistor values
  if (digitalRead(button1) == LOW) {
    if (count) {
      minrange = analogRead(pinPhoto);
      count = false;
    } else {
      maxrange = analogRead(pinPhoto);
      count = true;
    }
    delay(1000);
  }

  photoReading = analogRead(pinPhoto);

  // minimize/maximize photoReading in case the photosensor acts strangely
  if (photoReading >= maxrange) {
    photoReading = int(maxrange);
  }
  if (photoReading <= minrange) {
    photoReading = int(minrange);
  }
  
  //calculate adjusted photoresistor value
  photoValue = round(map(photoReading, minrange, maxrange, 0, 1023));
  
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
  pitchValues[i] = analogRead(pitchPot);

  i++;
  if (i == 10) {
    i = 0;
  }
  
  // take the average of pitchValues
  int pitchValue = 0;
  for (int i = 0; i < 10; i++) {
    pitchValue += pitchValues[i];
  }
  pitchValue = pitchValue / 10;

  // calibrate pitch pot: set minimum and maximum pitch pot values
  if (digitalRead(button2) == LOW) {
    if (count2) {
      zeropitch = pitchValue;
      count2 = false;
    } else {
      maxpitch = pitchValue;
      count2 = true;
    }
    delay(1000);
  }

  // minimize/maximize pitch pot values in case it acts strangely
  if (pitchValue >= maxpitch) {
    pitchValue = int(maxpitch);
  }
  if (pitchValue <= zeropitch) {
    pitchValue = int(zeropitch);
  }

  // calculate adjusted pitch potentiometer value
  pitchValue = round(map(pitchValue, zeropitch, maxpitch, 0, 1023));
  
  // print inputs to console
  Serial.print(pitchValue, DEC);
  Serial.print(",");
  Serial.print(analogRead(reverbPot), DEC);
  Serial.print(",");
  Serial.print(photoValue, DEC);
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
