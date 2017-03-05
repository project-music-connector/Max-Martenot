import processing.sound.*;

public class Oscillators implements Constants{
  private SinOsc sinOsc;
  private SinOsc sinOscH;
  private SinOsc sinOscL;
  private TriOsc triOsc;
  private SawOsc sawOsc;
  private SqrOsc sqrOsc;
  
  private InstrumentData oldData;
  
  public Oscillators(PApplet p) {
      
    //initialize instances of sound objects
    sinOsc = new SinOsc(p);
    sinOscH = new SinOsc(p);
    sinOscL = new SinOsc(p);
    triOsc = new TriOsc(p);
    sawOsc = new SawOsc(p);
    sqrOsc = new SqrOsc(p);
    
    oldData = null;
  }
  
  public SinOsc getSinOsc() {
    return sinOsc;
  }
  public SinOsc getSinOscH() {
    return sinOscH;
  }
  public SinOsc getsinOscL() {
    return sinOscL;
  }
  public TriOsc getTriOsc() {
    return triOsc;
  }
  public SawOsc getSawOsc() {
    return sawOsc;
  }
  public SqrOsc getSqrOsc() {
    return sqrOsc;
  }
  
  public void play(InstrumentData d, Reverb r, EqualizedAudio e) {
    if (oldData != null) { // Check to see if this is not the first time the play function is called
      for (int i = 0; i < SWITCHES; i++) {
        if (d.switches[i] != oldData.switches[i]) {
          // TODO: Write code for ith case
        }
      } 
    } else {
//activate/stop oscillations if state has changed

    oldData = new InstrumentData(d);
  }
  
  
}