//Sets input and output pins
#define In1 13
#define In2 12
#define In3 11
#define In4 10
#define Out1 9
#define Out2 8
#define Out3 7
#define Out4 6

void setup()
{
//Initializes pins 1-4 as inputs and 5-8 as outputs
  pinMode(In1,INPUT);
  pinMode(In2,INPUT);
  pinMode(In3,INPUT);
  pinMode(In4,INPUT);
  pinMode(Out1,OUTPUT);
  pinMode(Out2,OUTPUT);
  pinMode(Out3,OUTPUT);
  pinMode(Out4,OUTPUT);
  Serial.begin(9600);
  
//Define a list of 10 sensor values initialized to 0
  int sensorValues[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
}

void loop()
{
  //In1 drives Out1
  if (digitalRead(In1) )
  {digitalWrite(Out1,HIGH);}
  else
  {digitalWrite(Out1,LOW);}

  //In2 drives Out2
  if (digitalRead(In2) )
  {digitalWrite(Out2,HIGH);}
  else
  {digitalWrite(Out2,LOW);}

  //In3 drives Out3
  if (digitalRead(In3) )
  {digitalWrite(Out3,HIGH);}
  else
  {digitalWrite(Out3,LOW);}

  //In4 drives Out4
  if (digitalRead(In4) )
  {digitalWrite(Out4,HIGH);}
  else
  {digitalWrite(Out4,LOW);}
  
  // shift sensorValues 0-8 to the left
  for (i = 0, i<9, i++){
    sensorValues[i] = sensorValues[i+1];
  }
  // read the input on analog pin 0 and place at index 9 in sensorValues
  sensorValues[9] = analogRead(A0);
  // take the average of sensorValues
  int sensorValue = 0;
  for (i=0, i<10, i++) {
    sensorValue += sensorValues[i];
  }
  sensorValue = sensorValue / 10;
  // print out the averaged value you read:
  Serial.println(sensorValue, DEC);
  Serial.print(",");
  
  // Print inputs to console
  Serial.print(digitalRead(In1), DEC );
  Serial.print(",");
  Serial.println();
  Serial.print(digitalRead(In2), DEC );
  Serial.print(",");
  Serial.println();
  Serial.print(digitalRead(In3), DEC );
  Serial.print(",");
  Serial.println();
  Serial.print(digitalRead(In4), DEC );
  Serial.print(",");
  Serial.println();
  delay(50);
}
