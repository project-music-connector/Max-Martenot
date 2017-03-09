public class Equalizer {
  private float minFreq;
  
  public Equalizer() {
    this.minFreq = 90;
  }
  
  public Equalizer(float minFreq) {
    this.minFreq = minFreq;
  }
  
  public float getAmplitude(float amplitude, float frequency) {
    return amplitude * (pow(minFreq, 2) / pow(frequency, 2));
  }
}