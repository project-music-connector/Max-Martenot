public class Equalizer {
  private float minFreq;
  
  public Equalizer() {
    this.minFreq = 130;
  }
  
  public Equalizer(float minFreq) {
    this.minFreq = minFreq;
  }
  
  public float getAmplitude(float amplitude, float frequency) {
    return amplitude * (pow(minFreq, 1.5) / pow(frequency, 1.5));
  }
}