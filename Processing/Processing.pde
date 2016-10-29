//Max Martenot
//October 28th, 2016

import processing.sound.*;
import processing.serial.*; //import the Serial library so can read from arudino input via serial communication

int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;   // declare a new string called 'serial' 
Serial port;     // The serial port, this is a new instance of the Serial class (an Object)
int[] serialInputInt; // Array of integers to contain serial input

//declare instances of sound oscillations
SinOsc sinOsc;
SinOsc sinOscH;
SinOsc sinOscL;
TriOsc triOsc;

//declare on/off variables for sound oscillations -- corresponds to Arduino switch input
int sinOscOn;
int sinOscHOn;
int sinOscLOn;
int triOscOn;

//declare on/off variables for sound oscillations from previous cycle
int sinOscOnOld;
int sinOscHOnOld;
int sinOscLOnOld;
int triOscOnOld;

void setup() {
  //serial reading code
  //when testing, this next line should be the ONLY line to cause an error: ArrayIndexOutOfBoundsExcpetion: 0
  port = new Serial(this, Serial.list()[0], 9600); // initializing the object by assigning a port and baud rate (must match that of Arduino)
  port.clear();  // function from serial library that throws out the first reading, in case we started reading in the middle of a string from Arduino
  serial = port.readStringUntil(end); // function that reads the string from serial port until a println and then assigns string to our string variable (called 'serial')
  serial = null; // initially, the string will be null (empty)
  
  //run data in the buffer once to ensure that we splice the data properly when we begin processing the data in draw()
  delay(50);
  serial = port.readStringUntil(10);
  if (serial != null) { 
    String[] serialInput = split(serial, ','); 
    for (String s : serialInput) {
       print(s + ", ");
    }
    print("\n");
    serialInputInt = int(serialInput);
  }
  
  //initialize instances of sound oscillations
  sinOsc = new SinOsc(this);
  sinOscH = new SinOsc(this);
  sinOscL = new SinOsc(this);
  triOsc = new TriOsc(this);
 
} //end setup

void draw() {
  //****************GET SERIAL DATA AND READ IT*******************************
  //if there is data coming from the serial port read it/ store it
  while (port.available() > 0) { 
    serial = port.readStringUntil(end);
  } //end while

  //if the string is not empty, do this
  if (serial != null) { 
    //sensor input from Arduino, each value is separated and split depending on the ','
    //and then saved in separate cells of the array so we can access each 
    String[] serialInput = split(serial, ','); 
    //can help to print these to console at this point to check it's working
    for (String s : serialInput) {
      print(s + ", ");
    }
    print("\n");

    //convert the string inputs that are stored in the serialInputInt array, which will then be further decomposed
    serialInputInt = int(serialInput);
    sinOscOnOld = sinOscOn;
    sinOscHOnOld = sinOscHOn;
    sinOscLOnOld = sinOscLOn;
    triOscOnOld = triOscOn;
    
    //parse values
    int potValue = serialInputInt[0];
    sinOscOn = serialInputInt[1];
    sinOscHOn = serialInputInt[2];
    sinOscLOn = serialInputInt[3];
    triOscOn = serialInputInt[4];
    
    //convert linear pot input from MIDI to frequencies
    float potFreq = pow(2, (potValue/10.0 - 69) / 12) * 440;
    
    //debugging
    println(potValue);
    println(potFreq);
    println(sinOscOn);
    println(sinOscHOn);
    println(sinOscLOn);
    println(triOscOn);
    
    //activate/stop oscillations if state has changed
    if (sinOscOn - 1 == sinOscOnOld) {
      sinOsc.play();
    }
    if (sinOscOnOld - 1 == sinOscOn) {
      sinOsc.stop();
    }
    
    if (sinOscHOn - 1 == sinOscHOnOld) {
      sinOscH.play();
    }
    if (sinOscHOnOld - 1 == sinOscHOn) {
      sinOscH.stop();
    }
    
    if (sinOscLOn - 1 == sinOscLOnOld) {
      sinOscL.play();
    }
    if (sinOscLOnOld - 1 == sinOscLOn) {
      sinOscL.stop();
    }
    
    if (triOscOn - 1 == triOscOnOld) {
      triOsc.play();
    }
    if (triOscOnOld - 1 == triOscOn) {
      triOsc.stop();
    }
    
    //set oscillation frequencies
    if (sinOscOn == 1) {
      sinOsc.freq(potFreq);
    }
    if (sinOscHOn == 1) {
      sinOscH.freq(potFreq);
    }
    if (sinOscLOn == 1) {
      sinOscL.play();
      sinOscL.freq(potFreq);
    }
    if (triOscOn == 1) {
      triOsc.play();
      triOsc.freq(potFreq);
    }
    
  } //stop reading serial
} //end draw