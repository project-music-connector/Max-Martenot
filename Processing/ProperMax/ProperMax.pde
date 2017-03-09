import processing.sound.*;  //import the Sound library for oscillations and reverb
import processing.serial.*; //import the Serial library so we can read from arudino input via serial communication

int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;   // declare a new string called 'serial' 
Serial port;     // The serial port, this is a new instance of the Serial class (an Object)
int[] serialInputInt; // Array of integers to contain serial input

Oscillators osc;
//SerialInput serialObj;
EqualizedAudio ea;
ReverbEffect rv;
AudioEffect[] stack;
/*
public static String arrayToString(int[] input) {
  String[] intermediate = new String[input.length];
  for (int i = 0; i < input.length; i++) {
    intermediate[i] = (new Integer(input[i])).toString();
  }
  return join(intermediate,", ");
}*/

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
  
  osc = new Oscillators(this);
  //serialObj = new SerialInput(this);
  ea = new EqualizedAudio();
  rv = new ReverbEffect(this,osc);
  stack = new AudioEffect[Constants.EFFECTS];
  stack[0] = rv;
  stack[1] = ea;
  delay(200);
}

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
    int[] numbers = int(serialInput);
  int[] switches = new int[6];
    arrayCopy(numbers, 3, switches, 0, 6);
    ArduinoMessage arduinoMessage = new ArduinoMessage(numbers[0],numbers[1],numbers[2],switches);
    InstrumentData instrumentParams = arduinoMessage.getInstrumentData();
  //if (serialObj.hasNext()) {
  //  InstrumentData instrumentParams = serialObj.next().getInstrumentData(); // Get the next set of data from the Arduino
  //  ea.setCoefficients(instrumentParams); // Feed the equalizer new data
    
    // TODO: Implement dynamic state change detection.
    
    for (int i = 0; i < Constants.EFFECTS; i++) {
      stack[i].addEffect(instrumentParams); // Apply all effects (currently equalizer and reverb)
    }
    
    osc.play(instrumentParams); // Set the oscillators to play.
    
    delay(20);
  }
}