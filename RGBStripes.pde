// Our most traditional pattern, displays  series of RGB bands

class RGBStripes extends Pattern {
  int m_colorAngle = 0;
  int m_speed      = 1;
  
  void draw(PGraphics f) {
    for (int row = 0; row < displayHeight; row++) {
        int r = (((row)*2          + 100*1/displayWidth + m_colorAngle +  0)%100)*(255/100);
        int g = (((row)*2          + 100*1/displayWidth + m_colorAngle + 33)%100)*(255/100);
        int b = (((row)*2          + 100*1/displayWidth + m_colorAngle + 66)%100)*(255/100);
        
        f.stroke(r,g,b);
        f.rect(0, row, displayWidth, 3);
    }
    
    m_colorAngle += m_speed;
  }
}
