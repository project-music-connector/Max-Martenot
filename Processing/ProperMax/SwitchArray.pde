private static int[] oldState;
private static int[] currentState = {0, 0, 0, 0, 0, 0};

public class SwitchArray implements Constants {
  
  public SwitchArray(int[] switches) {
    oldState = currentState;
    
    currentState = new int[SWITCHES];
    for (int i = 0; i<SWITCHES; i++) {
      currentState[i] = new Integer(switches[i]);
    }
  }
  
  //public SwitchArray(SwitchArray s) {
  //  // No need to do anything, because everything is static!
  //}
  
  public int[] getState(int state) {
    int[] on = new int[SWITCHES];
    int nOn = 0;
    if (DEBUG) {
      System.out.println(System.currentTimeMillis() + ", Attempting to get switch states.");
      System.out.println("Search for state: " + str(state));
      //System.out.println("Old State: " + str(oldState));
      //System.out.println("Current State: " + str(currentState));
      println("Old State:");
      printArray(oldState);
      println("Current State: ");
      printArray(currentState);
    }
    for (int i = 0; i < SWITCHES; i++) {
      if (currentState[i] == state) {
        on[nOn] = i;
      }
    }
    int[] returnObject = new int[nOn];
    for (int i = 0; i < nOn; i++) {
      returnObject[i] = new Integer(on[i]);
    }
    if (DEBUG) {
      System.out.println(System.currentTimeMillis() + ", Switch states achieved");
      //System.out.println(arrayToString(returnObject));
      printArray(returnObject);
    }
    return returnObject;
  }
  
  public int[] getFlippedState(int state) { // Returns only the switches that changed states to state
    int[] stateDelta = new int[SWITCHES];
    for (int i = 0; i < SWITCHES; i++) {
      stateDelta[i] = currentState[i] - oldState[i];
    }
    int[] tmp = currentState;
    currentState = stateDelta; // This is really bad practice, but it's a botch job
    int[] returnState = getState((state == 1) ? 1 : -1); 
    currentState = tmp;
    return returnState;
  }
}