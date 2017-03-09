public class Equalizer {
  float minFreq;
  
  Equalizer() {
    minFreq = 80;
  }
  
  Equalizer(float minFreq) {
    this.minFreq = minFreq;
  }
  
  float getAmplitude(float amplitude, float frequency) {
    return amplitude * (pow(minFreq, 2) / pow(frequency, 2));
  }
}