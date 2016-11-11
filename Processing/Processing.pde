//Max-Martenot
//Alice Barbe
//November 2016

//INPUT: POTPITCH, POTREVERB, SWITCH0, SWITCH1, etc.

import processing.sound.*;
import processing.serial.*; //import the Serial library so can read from arudino input via serial communication

int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;   // declare a new string called 'serial' 
Serial port;     // The serial port, this is a new instance of the Serial class (an Object)

//declare oscillation variables that will contain the sounds
SinOsc sin;
SinOsc sinH;
SinOsc sinL;
SqrOsc sqr;
SqrOsc sqrH;
SqrOsc sqrL;

Reverb reverb;

//Array for holding serial input in integers
int[] serialInputInt = new int[numberOfSwitches + 2];

//Array for holding switch values
int numberOfSwitches = 6;
int[] switches = new int[numberOfSwitches];
int[] switchesOLD = new int[numberOfSwitches];

int potPitch = 0;
int potReverb = 0;


void setup() {

  sin = new SinOsc(this);
  sinH = new SinOsc(this);
  sinL = new SinOsc(this);
  sqr = new SqrOsc(this);
  sqrH = new SqrOsc(this);
  sqrL = new SqrOsc(this);
  
  reverb = new Reverb(this);

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
    /*for (int x = 0; x < numberOfSwitches + 2; x++) {
      serialInputInt[x] = int(serialInput[x]);
    }*/
    serialInputInt = int(serialInput);
    potPitch = serialInputInt[0];
    potReverb = serialInputInt[1];
    
    //**************PLAY SOUND******************************************
    
    float pitch = pow(2, (potPitch - 19) / 12) * 440;
    float reverbNum = map(potReverb, 0, 1023, 0, 1);
    
    for (int x = 0; x < numberOfSwitches; x++) {
      switchesOLD[x] = switches[x];                //update switchesOLD
      switches[x] = serialInputInt[x + 2];         //update switches with current data      
    }
    
    if (switches[0] == switches[0] + 1) {
      sin.play();
    }
    else if (switches[0] == switches[0] - 1) {
      sin.stop();
    }
    if (switches[0] == 1) {
      sin.freq(pitch);
      reverb.process(sin, reverbNum);
    }
    
    if (switches[1] == switches[1] + 1) {
      sinH.play();
    }
    else if (switches[1] == switches[1] - 1) {
      sinH.stop();
    }
    if (switches[1] == 1) {
      sinH.freq(pitch);
      reverb.process(sinH, reverbNum);
    }
    
    if (switches[2] == switches[2] + 1) {
      sinL.play();
    }
    else if (switches[2] == switches[2] - 1) {
      sinL.stop();
    }
    if (switches[2] == 1) {
      sinL.freq(pitch);
      reverb.process(sinL, reverbNum);
    }
    
    if (switches[3] == switches[3] + 1) {
      sqr.play();
    }
    else if (switches[3] == switches[3] - 1) {
      sqr.stop();
    }
    if (switches[3] == 1) {
      sqr.freq(pitch);
      reverb.process(sqr, reverbNum);
    }
    
    if (switches[4] == switches[4] + 1) {
      sqrH.play();
    }
    else if (switches[4] == switches[4] - 1) {
      sqrH.stop();
    }
    if (switches[4] == 1) {
      sqrH.freq(pitch);
      reverb.process(sqrH, reverbNum);
    }
    
    if (switches[5] == switches[5] + 1) {
      sqrL.play();
    }
    else if (switches[5] == switches[5] - 1) {
      sqrL.stop();
    }
    if (switches[5] == 1) {
      sqrL.freq(pitch);
      reverb.process(sqrL, reverbNum);
    }

  }//end if(serial != null)
} //end draw()