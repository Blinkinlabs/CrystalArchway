// Fill all of the LEDs at once
class ScreenFlash extends Pattern {
  color[] m_colors = new color[] {
    color(255, 0, 0), 
    color(0, 255, 0), 
    color(0, 0, 255), 
    color(255, 255, 0), 
    color(0, 255, 255), 
    color(255, 0, 255), 
    color(255, 255, 255), 
    color(255, 64, 64), 
    color(255, 127, 0), 
    color(0, 255, 127), 
    color(255, 0, 0), 
    color(0, 255, 0), 
    color(0, 0, 255), 
    color(255, 255, 0), 
    color(0, 255, 255), 
    color(255, 0, 255)
  };
  
  int m_pitch;
  
  ScreenFlash(int channel, int pitch, int velocity) {
    super(channel, pitch, velocity);
    m_pitch = pitch;
    println("Flash pitch " + m_pitch);
  }
  
  void draw(PGraphics f) {    
    int colorIndex = m_pitch - 36;
    if(colorIndex >= 0 && colorIndex < m_colors.length) {
      f.pushStyle();
        f.noStroke();
        f.fill(m_colors[colorIndex]);
        f.rect(0, 0, displayWidth, displayHeight);
      f.popStyle();
    }
  }
}

