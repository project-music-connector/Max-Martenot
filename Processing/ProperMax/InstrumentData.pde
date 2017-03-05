public class InstrumentData {
  public float pitch;
  public float reverb;
  public float amplitude;
  public boolean[] switches;
  public InstrumentData(ArduinoMessage m) {
    this.pitch = ((m.pitchPot/10.0 - 69.0)/12.0) * 440.0;
    this.reverb = map(m.reverbPot, 0, 1023, 0.0, 1.0);
    this.amplitude = map(m.photoSensor, 0, 1023, 0.0, 1.0);
    switches = new boolean[m.switches.length];
    for (int i = 0; i < m.switches.length; i++) {
      switches[i] = m.switches[i] == 1;
    }
  }
  
  public InstrumentData(InstrumentData d) { // Copy constructor
    this.pitch = d.pitch;
    this.reverb = d.reverb;
    this.amplitude = d.amplitude;
    switches = new boolean[d.switches.length];
    for (int i = 0; i < d.switches.length; i++) {
      switches[i] = d.switches[i];
    }
  }
}