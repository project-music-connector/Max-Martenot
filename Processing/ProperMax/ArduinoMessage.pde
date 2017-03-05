public class ArduinoMessage implements Constants{
  public int pitchPot;
  public int reverbPot;
  public int photoSensor;
  public int[] switches;
  
  public ArduinoMessage(int pitchPot, int reverbPot, int photoSensor, int[] switches) {
    this.pitchPot = pitchPot;
    this.reverbPot = reverbPot;
    this.photoSensor = photoSensor;
    this.switches = switches;
  }
  
  public InstrumentData getInstrumentData() {
    return new InstrumentData(this);
  }
  
}