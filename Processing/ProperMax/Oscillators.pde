import processing.sound.*;

public class Oscillators implements Constants{
  private SinOsc sinOsc;
  private SinOsc sinOscH;
  private SinOsc sinOscL;
  private TriOsc triOsc;
  private SawOsc sawOsc;
  private SqrOsc sqrOsc;
  
  public Oscillators(PApplet p) {
      
    //initialize instances of sound objects
    sinOsc = new SinOsc(p);
    sinOscH = new SinOsc(p);
    sinOscL = new SinOsc(p);
    triOsc = new TriOsc(p);
    sawOsc = new SawOsc(p);
    sqrOsc = new SqrOsc(p);
  }
  
  public void play(InstrumentData d) {
    // Get the list of oscillators that have turned on
    int[] toOn = d.switches.getFlippedState(1);
    int[] toOff = d.switches.getFlippedState(0);
    int[] on = d.switches.getState(1);
    
    // Iterate through the lists
    for (int i = 0; i < toOn.length; i++) {
      switch (toOn[i]) {
        case 0:
          sinOsc.play();
        break;
        case 1:
          sinOscH.play();
        break;
        case 2:
          sinOscL.play();
        break;
        case 3:
          triOsc.play();
        break;
        case 4:
          sawOsc.play();
        break;
        case 5:
          sqrOsc.play();
        break;
      }
    }
    for (int i = 0; i < toOff.length; i++) {
      switch (toOff[i]) {
        case 0:
          sinOsc.stop();
        break;
        case 1:
          sinOscH.stop();
        break;
        case 2:
          sinOscL.stop();
        break;
        case 3:
          triOsc.stop();
        break;
        case 4:
          sawOsc.stop();
        break;
        case 5:
          sqrOsc.stop();
        break;
      }
    }
    for (int i = 0; i < on.length; i++) {
      switch (on[i]) {
        case 0:
          sinOsc.amp(d.amplitude);
          sinOsc.freq(d.pitch);
        break;
        case 1:
          sinOscH.amp(d.amplitude);
          sinOscH.freq(d.pitch);
        break;
        case 2:
          sinOscL.amp(d.amplitude);
          sinOscL.freq(d.pitch);
        break;
        case 3:
          triOsc.amp(d.amplitude);
          triOsc.freq(d.pitch);
        break;
        case 4:
          sawOsc.amp(d.amplitude);
          sawOsc.freq(d.pitch);
        break;
        case 5:
          sqrOsc.amp(d.amplitude);
          sqrOsc.freq(d.pitch);
        break;
      }
    }
    
  }
}