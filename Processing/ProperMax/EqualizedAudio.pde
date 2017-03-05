public class EqualizedAudio implements Constants, AudioEffect {
  private float phon;
  private float vAf;
  private float spl;
  
  public EqualizedAudio() {
  }
  
  public void setCoefficients(InstrumentData d) {
    int ndx = getClosestVal(f,d.pitch);
    phon = 20 * log(d.amplitude);
    float tmp1 = pow(10,(0.025*phon)) - 1.15;
    float tmp15 = pow(10, tf[ndx] + lu[ndx]);
    float tmp2 = pow(0.4 * tmp15/10 - 9, af[ndx]);
    vAf = 0.00447 * tmp1 + tmp2;
    spl = ((10/af[ndx]) * (log(vAf)/log(vAf))) - lu[ndx] + 94;
  }
  
  public float getVaf() {
    return vAf;
  }
  public float getSpl() {
    return spl;
  }
  
  public float pitchMod(float pitch) {
    return pitch; // H(w) = 1
  }
  public float ampMod(float ampValue) {
    // TODO: implement amplitude modulation.
    return 0.0;
  }
}
public static int getClosestVal(float[] toSearch, float toFind) { // Binary Search Static Method
  int low = 0;
  int high = toSearch.length - 1;

  if (high < 0)
    throw new IllegalArgumentException("The array cannot be empty");

  while (low < high) {
    int mid = (low + high) / 2;
    assert(mid < high);
    float d1 = Math.abs(toSearch[mid  ] - toFind);
    float d2 = Math.abs(toSearch[mid+1] - toFind);
    if (d2 <= d1) {
      low = mid+1;
    } else {
      high = mid;
    }
  }
  return high;
}