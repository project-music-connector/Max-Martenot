Oscillators osc;
SerialInput serialObj;
EqualizedAudio ea;
ReverbEffect rv;
AudioEffect[] stack;



void setup() {
  osc = new Oscillators(this);
  serialObj = new SerialInput(this);
  ea = new EqualizedAudio();
  rv = new ReverbEffect(this,osc);
  stack = new AudioEffect[Constants.EFFECTS];
  stack[0] = rv;
  stack[1] = ea;
}

void draw() {
  if (serialObj.hasNext()) {
    InstrumentData instrumentParams = serialObj.next().getInstrumentData(); // Get the next set of data from the Arduino
    ea.setCoefficients(instrumentParams); // Feed the equalizer new data
    
    // TODO: Implement dynamic state change detection.
    
    for (int i = 0; i < Constants.EFFECTS; i++) {
      stack[i].addEffect(instrumentParams); // Apply all effects (currently equalizer and reverb)
    }
    
    osc.play(instrumentParams); // Set the oscillators to play.
    
    delay(20);
  }
}