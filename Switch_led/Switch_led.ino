//Sets input and output pins
#define In1 8
#define In2 9
#define In3 10
#define In4 11
#define In5 12
#define In6 13
#define Out1 2
#define Out2 3
#define Out3 4
#define Out4 5
#define Out5 6
#define Out6 7

//Define a list of 10 sensor values initialized to 0
int sensorValues[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  
void setup() {
//Initializes pins 1-4 as inputs and 5-8 as outputs
  pinMode(In1, INPUT_PULLUP);
  pinMode(In2, INPUT_PULLUP);
  pinMode(In3, INPUT_PULLUP);
  pinMode(In4, INPUT_PULLUP);
  pinMode(In5, INPUT_PULLUP);
  pinMode(In6, INPUT_PULLUP);
  pinMode(Out1, OUTPUT);
  pinMode(Out2, OUTPUT);
  pinMode(Out3, OUTPUT);
  pinMode(Out4, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  //In1 drives Out1
  if (digitalRead(In1))
  {digitalWrite(Out1,HIGH);}
  else
  {digitalWrite(Out1,LOW);}

  //In2 drives Out2
  if (digitalRead(In2))
  {digitalWrite(Out2,HIGH);}
  else
  {digitalWrite(Out2,LOW);}

  //In3 drives Out3
  if (digitalRead(In3))
  {digitalWrite(Out3,HIGH);}
  else
  {digitalWrite(Out3,LOW);}

  //In4 drives Out4
  if (digitalRead(In4))
  {digitalWrite(Out4,HIGH);}
  else
  {digitalWrite(Out4,LOW);}

  //In5 drives Out5
  if (digitalRead(In5))
  {digitalWrite(Out5,HIGH);}
  else
  {digitalWrite(Out5,LOW);}

  //In6 drives Out6
  if (digitalRead(In6))
  {digitalWrite(Out6,HIGH);}
  else
  {digitalWrite(Out6,LOW);}

  // shift sensorValues 0-8 to the left
  for (int i=0; i<9; i++){
    sensorValues[i] = sensorValues[i+1];
  }
  
  // read the input on analog pin 0 and place at index 9 in sensorValues
  sensorValues[9] = analogRead(A0);
  
  // take the average of sensorValues
  int sensorValue = 0;
  for (int i=0; i<10; i++) {
    sensorValue += sensorValues[i];
  }
  sensorValue = sensorValue / 10;
  
  // print out the value you read:
  Serial.print(sensorValue, DEC);
  Serial.print(",");
  
  //Print inputs to console
  Serial.print(digitalRead(In1), DEC);
  Serial.print(",");
  Serial.print(digitalRead(In2), DEC);
  Serial.print(",");
  Serial.print(digitalRead(In3), DEC);
  Serial.print(",");
  Serial.print(digitalRead(In4), DEC);
  Serial.print(",");
  Serial.print(digitalRead(In5), DEC);
  Serial.print(",");
  Serial.print(digitalRead(In6), DEC);
  Serial.print(",");
  Serial.println();
  delay(50);
}
