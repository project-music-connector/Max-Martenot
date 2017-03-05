import processing.serial.*;

public class SerialInput implements java.util.Iterator, Constants{
  private Serial port;
  
  public SerialInput(PApplet p) {
    port = new Serial(p);
    port.clear();
    port.readStringUntil(ENDL);
  }
  
  public boolean hasNext() {
    if (port.available() > 0) {
      return true;
    }
    return false;
  }
  
  public ArduinoMessage next() {
    String serial = port.readStringUntil(ENDL);
    if (DEBUG) {
      System.out.println(serial);
    }
    String[] serialInput = serial.split(",");
    int[] numbers = new int[serialInput.length];
    for(int i = 0; i < serialInput.length; i++) {
     // Note that this is assuming valid input
     // If you want to check then add a try/catch 
     // and another index for the numbers if to continue adding the others
     numbers[i] = Integer.parseInt(serialInput[i]);
    }
    // Numbers now contains the int values of the string array.
    int[] switches = new int[SWITCHES];
    System.arraycopy(numbers,(numbers.length-SWITCHES-1),switches,0,SWITCHES);
    return new ArduinoMessage(numbers[1],numbers[2],numbers[3],switches);
  }
}