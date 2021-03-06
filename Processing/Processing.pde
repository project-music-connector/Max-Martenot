// Max Martenot
// March 26th, 2016
// Alice Barbe, Kevin Choi, Beatriz Fusaro, Asimm Hirani

// Data input: pitchPot(0-1023), reverbPot(0-1023), photoSensor(0-1023), switches(0-1);

import processing.sound.*;  // import the Sound library for oscillations and reverb
import processing.serial.*; // import the Serial library so we can read from arudino input via serial communication

int end = 10;         // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;        // declare a new string called 'serial' 
Serial port;          // The serial port, this is a new instance of the Serial class (an Object)
int[] serialInputInt; // Array of integers to contain serial input

int numberOfSwitches = 6;

// declare instances of oscillator objects
SinOsc sinOsc;
SinOsc sinOscH;
SinOsc sinOscL;
TriOsc triOsc;
SawOsc sawOsc;
SqrOsc sqrOsc;

// declare instances of reverb objects
Reverb reverbSin;
Reverb reverbSinH;
Reverb reverbSinL;
Reverb reverbTri;
Reverb reverbSaw;
Reverb reverbSqr;

// declare instance of equalizer object
Equalizer equalizer;

int[] switches = new int[numberOfSwitches];    // current switches input
int[] switchesOld = new int[numberOfSwitches]; // previous switches input

int pitchPot;        // Arduino input. Ranges 0 - 1023, already adjusted for min/max, and running average.
float pitchMIDI;     // MIDI value of oscillation. Ranges 0 - 128, scaled to 48 - 84 (C3 - C6)
float pitchFreq;     // Frequency of oscillation. Ranges from 130.8 - 1046.5 Hz
int reverbPot;       // Arduino input. Ranges 0 - 1023.
float reverbValue;   // Reverb value. Ranges 0 - 1.
int photoSensor;     // Arduino input. Ranges 0 - 1023, already adjusted for min/max.
float ampValue;      // Amp value before equalization. Scaled 0 - 1 and ^10. Ranges 0 - 1.
float ampValueEqual; // Amp value after equalization. Ranges 0 - 1, maximized at 1.

void setup() {
  // serial reading code
  // when testing, this next line should be the ONLY line to cause an error: ArrayIndexOutOfBoundsExcpetion: 0
  port = new Serial(this, Serial.list()[0], 9600); // initializing the object by assigning a port and baud rate (must match that of Arduino)
  port.clear();                                    // throw out the first reading, in case we started reading in the middle of a string from Arduino
  serial = port.readStringUntil(end);              // read and assign the string from serial port until a println
  serial = null;                                   // initially, the string will be null (empty)
  
  //run data in the buffer once to ensure that we splice the data properly when we begin processing the data in draw()
  delay(50);
  serial = port.readStringUntil(end);
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
  
  // initialize instances of reverb objects
  reverbSin = new Reverb(this);
  reverbSinH = new Reverb(this);
  reverbSinL = new Reverb(this);
  reverbTri = new Reverb(this);
  reverbSaw = new Reverb(this);
  reverbSqr = new Reverb(this);
  
  // initialialize equalizer object
  equalizer = new Equalizer();
  
} //end setup

void draw() {
  // if there is data coming from the serial port read it/ store it
  while (port.available() > 0) { 
    serial = port.readStringUntil(end);
  } //end while
  
  // if the string is not empty, do this
  if (serial != null) { 
    // sensor input from Arduino, each value is separated and split depending on the ','
    // and then saved in separate cells of the array so we can access each 
    String[] serialInput = split(serial, ','); 
    
    // print serial input for debugging
    println("serialInput: ");
    printArray(serialInput);

    // convert the string inputs that are stored in the serialInputInt array, which will then be further decomposed
    serialInputInt = int(serialInput);
    
    // copy switches to switchesOld
    arrayCopy(switches, switchesOld);
    
    // parse values
    pitchPot = serialInputInt[0];
    reverbPot = serialInputInt[1];
    photoSensor = serialInputInt[2];
    arrayCopy(serialInputInt, 3, switches, 0, numberOfSwitches);
    
    // calculate frequency (MIDI: linear; frequency: logarithmic)
    pitchMIDI = pitchPot / 1023.0  * 128;            // scale input to MIDI notes range
    pitchFreq = map(pitchMIDI, 0, 128, 48, 84);      // map to a set range (C3 - C6)
    pitchFreq = pow(2, (pitchFreq - 69) / 12) * 440; // convert to frequency
    
    // convert reverb pot input into 0 to 1 value
    reverbValue = map(reverbPot, 0, 1023, 0.0, 1.0);
    
    // convert photoSensor input into 0 to 1 value, and ^10
    ampValue = pow(map(photoSensor, 0, 1023, 0.0, 1.0), 10);
    // apply equalizer and maximize at 1
    ampValueEqual = equalizer.getAmplitude(ampValue, pitchFreq);
    if (ampValueEqual > 1) {
      ampValueEqual = 1;
    }
    
    // debugging
    println("photoresistor value:", photoSensor);
    println("pitchMIDI <==> pitchFreq:   ", pitchMIDI, "<==>", pitchFreq);
    println("reverbValue:", reverbValue, " ampValue:", ampValue);
    printArray(switches);
    
    // activate/stop oscillations if state has changed
    if (switches[0] - 1 == switchesOld[0]) {
      sinOsc.play();
      reverbSin.process(sinOsc);
    }
    if (switches[0] == switchesOld[0] - 1) {
      sinOsc.stop();
      reverbSin.stop();
    }
    if (switches[1] - 1 == switchesOld[1]) {
      sinOscH.play();
      reverbSinH.process(sinOscH);
    }
    if (switches[1] == switchesOld[1] - 1) {
      sinOscH.stop();
      reverbSinH.stop();
    }
    if (switches[2] - 1 == switchesOld[2]) {
      sinOscL.play();
      reverbSinL.process(sinOscL);
    }
    if (switches[2] == switchesOld[2] - 1) {
      sinOscL.stop();
      reverbSinL.stop();
    }
    if (switches[3] - 1 == switchesOld[3]) {
      triOsc.play();
      reverbTri.process(triOsc);
    }
    if (switches[3] == switchesOld[3] - 1) {
      triOsc.stop();
      reverbTri.stop();
    }
    if (switches[4] - 1 == switchesOld[4]) {
      sawOsc.play();
      reverbSaw.process(sawOsc);
    }
    if (switches[4] == switchesOld[4] - 1) {
      sawOsc.stop();
      reverbSaw.stop();
    }
    if (switches[5] - 1 == switchesOld[5]) {
      sqrOsc.play();
      reverbSqr.process(sqrOsc);
    }
    if (switches[5] == switchesOld[5] - 1) {
      sqrOsc.stop();
      reverbSqr.stop();
    }
    
    //set oscillation frequencies and reverb parameters
    if (switches[0] == 1) {
      sinOsc.freq(pitchFreq);
      sinOsc.amp(ampValue);
      reverbSin.room(reverbValue);
      reverbSin.damp(reverbValue);
    }
    if (switches[1] == 1) {
      sinOscH.freq(pitchFreq * 2);
      sinOscH.amp(ampValue);
      reverbSinH.room(reverbValue);
      reverbSinH.damp(reverbValue);
    }
    if (switches[2] == 1) {
      sinOscL.freq(pitchFreq / 2);
      sinOscL.amp(ampValue);
      reverbSinL.room(reverbValue);
      reverbSinL.damp(reverbValue);
    }
    if (switches[3] == 1) {
      triOsc.amp(ampValue);
      triOsc.freq(pitchFreq);
      reverbTri.room(reverbValue);
      reverbTri.damp(reverbValue);
    }
    if (switches[4] == 1) {
      sawOsc.freq(pitchFreq);
      sawOsc.amp(ampValue);
      reverbSaw.room(reverbValue);
      reverbSaw.damp(reverbValue);
    }
    if (switches[5] == 1) {
      sqrOsc.freq(pitchFreq);
      sqrOsc.amp(ampValue);
      reverbSqr.room(reverbValue);
      reverbSqr.damp(reverbValue);
    }
    
  } // stop reading serial
  
  delay(20);
} // end draw