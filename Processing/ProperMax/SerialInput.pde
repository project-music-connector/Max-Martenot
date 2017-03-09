import processing.serial.*;

public class SerialInput implements java.util.Iterator, Constants{
  private Serial port;
  
  public SerialInput(PApplet p) {
    port = new Serial(p, Serial.list()[0], 9600);
    port.clear();
    port.readStringUntil(ENDL);
    String serial = null;
    while (serial == null) {
      serial = port.readStringUntil(ENDL);
      delay(40);
    }
  }
  
  public boolean hasNext() {
    if (port.available() > 0) {
      return true;
    }
    return false;
  }
  
  public ArduinoMessage next() {
    String serial = null;
    while (serial == null || serial.length() < 15) {
      serial = port.readStringUntil(ENDL);
      delay(40);
    }
    if (DEBUG) {
      System.out.println(serial);
    }
    String[] serialInput = serial.split(",");
    //int[] numbers = new int[serialInput.length];
    int[] numbers = int(serialInput);
    //for(int i = 0; i < serialInput.length; i++) {
     // Note that this is assuming valid input
     // If you want to check then add a try/catch 
     // and another index for the numbers if to continue adding the others
    // numbers[i] = Integer.parseInt(serialInput[i]);
    //}
    // Numbers now contains the int values of the string array.
    int[] switches = new int[SWITCHES];
    System.arraycopy(numbers,(numbers.length-SWITCHES),switches,0,SWITCHES);
    return new ArduinoMessage(numbers[0],numbers[1],numbers[2],switches);
  }
}