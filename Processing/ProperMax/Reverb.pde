public class Reverb implements Constants{
  private Reverb[] reverbs;
  
  public Reverb(PApplet p) {
    reverbs = new Reverb[6];
    for (int i = 0; i < reverbs.length; i++) {
      reverbs[i] = new Reverb(p);
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