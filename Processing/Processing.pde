//Max Martenot
//October 28th, 2016

//Data input: pitchPot(0-1023), reverbPot(0-1023), photoSensor(0-1023), switches(0-1);

import processing.sound.*;  //import the Sound library for oscillations and reverb
import processing.serial.*; //import the Serial library so we can read from arudino input via serial communication

int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;   // declare a new string called 'serial' 
Serial port;     // The serial port, this is a new instance of the Serial class (an Object)
int[] serialInputInt; // Array of integers to contain serial input

int numberOfSwitches = 6;

//declare instances of sound objects
SinOsc sinOsc;
SinOsc sinOscH;
SinOsc sinOscL;
TriOsc triOsc;
SawOsc sawOsc;
SqrOsc sqrOsc;
Reverb reverb;

int[] switches = new int[6];
int[] switchesOld = new int[6];

int pitchPot;
float pitchFreq;
int reverbPot;
float reverbValue;
int photoSensor;
float ampValue;

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
    serialInputInt = int(serialInput);
  }
  
  //initialize instances of sound objects
  sinOsc = new SinOsc(this);
  sinOscH = new SinOsc(this);
  sinOscL = new SinOsc(this);
  triOsc = new TriOsc(this);
  sawOsc = new SawOsc(this);
  sqrOsc = new SqrOsc(this);
  reverb = new Reverb(this);
 
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
    /*for (String s : serialInput) {
      print(s + ", ");
    }
    print("\n");*/

    //convert the string inputs that are stored in the serialInputInt array, which will then be further decomposed
    serialInputInt = int(serialInput);
    
    //copy switches to switchesOld
    arrayCopy(switches, switchesOld);
    
    //parse values
    pitchPot = serialInputInt[0];
    reverbPot = serialInputInt[1];
    photoSensor = serialInputInt[2];
    arrayCopy(serialInputInt, 3, switches, 0, numberOfSwitches);
    
    //convert linear pot input from MIDI to frequencies
    pitchFreq = pow(2, (pitchPot/10.0 - 69) / 12) * 440;
    //convert reverb pot input into 0 to 1 value
    reverbValue = map(reverbPot, 0, 1023, 0.0, 1.0);
    //conver photoSensor input into 0 to 1 value
    ampValue = map(photoSensor, 0, 1023, 0.0, 1.0);
    
    //debugging
    println(pitchPot + " " + pitchFreq + " " + ampValue);
    printArray(switches);
    
    //activate/stop oscillations if state has changed
    if (switches[0] - 1 == switchesOld[0]) {
      sinOsc.play();
    }
    if (switches[0] == switches[0] - 1) {
      sinOsc.stop();
    }
    if (switches[1] - 1 == switchesOld[1]) {
      sinOscH.play();
    }
    if (switches[1] == switches[1] - 1) {
      sinOscH.stop();
    }
    if (switches[2] - 1 == switchesOld[2]) {
      sinOscL.play();
    }
    if (switches[2] == switches[2] - 1) {
      sinOscL.stop();
    }
    if (switches[3] - 1 == switches[3]) {
      triOsc.play();
    }
    if (switches[3] == switches[3] - 1) {
      triOsc.stop();
    }
    if (switches[4] - 1 == switches[4]) {
      sawOsc.play();
    }
    if (switches[4] == switches[4] - 1) {
      sawOsc.stop();
    }
    if (switches[5] - 1 == switches[5]) {
      sqrOsc.play();
    }
    if (switches[5] == switches[5] - 1) {
      sqrOsc.stop();
    }
    
    //set oscillation frequencies
    if (switches[0] == 1) {
      sinOsc.freq(pitchFreq);
      sinOsc.amp(ampValue);
      reverb.process(sinOsc, reverbValue);
    }
    if (switches[1] == 1) {
      sinOscH.freq(pitchFreq);
      sinOscH.amp(ampValue);
      reverb.process(sinOscH, reverbValue);
    }
    if (switches[2] == 1) {
      sinOscL.freq(pitchFreq);
      sinOscL.amp(ampValue);
      reverb.process(sinOscL, reverbValue);
    }
    if (switches[3] == 1) {
      triOsc.freq(pitchFreq);
      triOsc.amp(ampValue);
      reverb.process(triOsc, reverbValue);
    }
    if (switches[4] == 1) {
      sawOsc.freq(pitchFreq);
      sawOsc.amp(ampValue);
      reverb.process(sawOsc, reverbValue);
    }
    if (switches[5] == 1) {
      sqrOsc.freq(pitchFreq);
      sqrOsc.amp(ampValue);
      reverb.process(sqrOsc, reverbValue);
    }
    
  } //stop reading serial
} //end draw