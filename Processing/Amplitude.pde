// Max Martenot amplitude debugging module

class AmpValue {
  float ampValue;
  float pitchFreq;
  
  float f[] = {20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800,
       1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500};
  
  float af[] = {0.532, 0.506, 0.480, 0.455, 0.432, 0.409, 0.387, 0.367, 0.349, 0.330, 0.315,
        0.301, 0.288, 0.276, 0.267, 0.259, 0.253, 0.250, 0.246, 0.244, 0.243, 0.243,
        0.243, 0.242, 0.242, 0.245, 0.254, 0.271, 0.301};
  
  float lu[] = {-31.6, -27.2, -23.0, -19.1, -15.9, -13.0, -10.3, -8.1, -6.2, -4.5, -3.1,
         -2.0,  -1.1,  -0.4,   0.0,   0.3,   0.5,  0.0, -2.7, -4.1, -1.0,  1.7,
          2.5,   1.2,  -2.1, -7.1, -11.2, -10.7,  -3.1};
  
  float tf[] = {78.5,  68.7, 59.5,  51.1,  44.0,  37.5,  31.5,  26.5,  22.1,  17.9,  14.4,
         11.4,   8.6,   6.2,   4.4,  3.0,   2.2,  2.4,   3.5,   1.7,  -1.3,  -4.2,
         -6.0,  -5.4,  -1.5,   6.0,  12.6,  13.9,  12.3};
  
  float vAf;
  float spl;
  float phon;
  int xr;
  int xl;
  int xu;
  
  AmpValue(float ampValue, float pitchFreq) {
    this.ampValue = ampValue;
    this.pitchFreq = pitchFreq;
  }
  
  float getAmplitude() {
    // match the discretized values of f with the value of pitchFreq:
    xl = 0;
    xu = f.length; // 29
    do {
      xr = (xl + xu) / 2; // 14 // 22
        if (f[xr] < pitchFreq) { // f[14] = 400; 400 < 880 true; // 2500 < 880 false;
            xl = xr; // xl = 14
        } else {
            xu =  xr;
        }
    } while(f[xr] >= pitchFreq || f[xr + 1] <= pitchFreq); // true (!false) //<>//
    // now ndx is the index value of f in which pitchFreq is in between
    
    // find phon:
    // phon is a value from 0 to 90 in dB;
    // ampValue is a value from 0 to 1;
    ampValue = map(ampValue,0,1,1,31622); //<>//
    phon = 20 * (log(ampValue)/log(10));
    /*print(ampValue);
    print(", ");
    println(phon);*/
    // find spl:
    
    // exponents in java: pow(x,y) where x^y; uses double types (jk processing doesn't use doubles)
    // logarithms in java: log(x) where ln(x); uses double types
    float tmp1 = pow(10,(0.025*phon)) - 1.15;
    float tmp15 = pow(10, (tf[xr] + lu[xr])/10);
    float tmp2 = pow(tmp15, af[xr]);
    vAf = 0.00447 * tmp1 + 0.4 * tmp2;
    
    
    spl = ((10/af[xr]) * (log(vAf)/log(10))) - lu[xr] + 94;
    
    // spl is given in dB (iirc); convert back to a linear scale
    return pow(10, spl / 20);
  }
}