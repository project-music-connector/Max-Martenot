public interface AudioEffect {
  // Use this interface to implement an effect stack.
  // Transfer functions for frequency and amplitude are implemented in classes
  
  public void addEffect(InstrumentData input);
  
  /*
    Usage:
      // in setup()
      AudioEffect stack = new AudioEffect[EFFECT_STACK_LENGTH];
      // Fill the stack with your effects here 
      
      // in draw(), 
      InstrumentData d = some source of instrumentdata
      for (int i = 0; i < EFFECT_STACK_LENGTH; i++) {
        stack[i].addEffect(d);
      }
      oscillator.play(d);
  */
}