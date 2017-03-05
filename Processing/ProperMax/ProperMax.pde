Oscillators osc;
SerialInput serialObj;
EqualizedAudio ea;
Reverb rv;



void setup() {
  osc = new Oscillators(this);
  serialObj = new SerialInput(this);
  ea = new EqualizedAudio();
  rv = new Reverb(this);
  
}

void draw() {
  if (serialObj.hasNext()) {
    InstrumentData instrumentParams = serialObj.next().getInstrumentData();
    ea.setCoefficients(instrumentParams);
    osc.play(instrumentParams,rv,ea);
  }
}