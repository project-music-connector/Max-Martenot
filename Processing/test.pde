float ampVal[] = {0,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90};
// phon range is 0 to 90 dB
for (float b:ampVal) {     
  AmpValue val = new AmpValue(b, 900f);
  float amp = val.getAmplitude(); //<>//
  print(amp);
  print(", ");
}