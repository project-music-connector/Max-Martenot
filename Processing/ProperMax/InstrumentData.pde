public class InstrumentData implements Constants{
  public float pitch;
  public float reverb;
  public float amplitude;
  public SwitchArray switches;
  public InstrumentData(ArduinoMessage m) {
    this.pitch = ((m.pitchPot/10.0 - 69.0)/12.0) * 440.0;
    this.reverb = map(m.reverbPot, 0, 1023, 0.0, 1.0);
    this.amplitude = map(m.photoSensor, 0, 1023, 0.0, 1.0);
    this.switches = new SwitchArray(m.switches);
  }
  
  //public InstrumentData(InstrumentData d) { // Copy constructor
  //  this.pitch = d.pitch;
  //  this.reverb = d.reverb;
  //  this.amplitude = d.amplitude;
    
  //  this.switches = new SwitchArray(d.switches);
  //}
}