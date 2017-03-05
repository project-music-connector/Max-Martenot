public class ReverbEffect implements Constants, AudioEffect{
  private Reverb[] reverbs;
  private Oscillators osc;
  
  public ReverbEffect(PApplet p, Oscillators osc) {
    reverbs = new Reverb[6];
    for (int i = 0; i < reverbs.length; i++) {
      reverbs[i] = new Reverb(p);
    }
    this.osc = osc;
  }
  
  public void addEffect(InstrumentData d) {
    // Get the list of oscillators that have turned on
    int[] toOn = d.switches.getFlippedState(1);
    int[] toOff = d.switches.getFlippedState(0);
    int[] on = d.switches.getState(1);
    
    // Iterate through the lists
    for (int i = 0; i < toOn.length; i++) {
      switch (toOn[i]) {
        case 0:
          reverbs[0].process(osc.sinOsc);
        break;
        case 1:
          reverbs[1].process(osc.sinOscH);
        break;
        case 2:
          reverbs[2].process(osc.sinOscL);
        break;
        case 3:
          reverbs[3].process(osc.triOsc);
        break;
        case 4:
          reverbs[4].process(osc.sawOsc);
        break;
        case 5:
          reverbs[5].process(osc.sqrOsc);
        break;
      }
    }
    for (int i = 0; i < toOff.length; i++) { // This is why arrays are awesome.
      reverbs[toOff[i]].stop();
    }
    for (int i = 0; i < on.length; i++) { // This too
      reverbs[on[i]].room(d.reverb);
      reverbs[on[i]].damp(d.reverb);
    }
  }
  
  public Reverb getReverbSin() {
    return reverbs[0];
  }
  public Reverb getReverbSinH() {
    return reverbs[1];
  }
  public Reverb getReverbSinL() {
    return reverbs[2];
  }
  public Reverb getReverbTri() {
    return reverbs[3];
  }
  public Reverb getReverbSaw() {
    return reverbs[4];
  }
  public Reverb getReverbSqr() {
    return reverbs[5];
  }
}