// Our most traditional pattern, displays  series of RGB bands

class RGBStripes extends Pattern {
  int m_colorAngle = 0;
  int m_speed      = 1;
  
  RGBStripes() {
    m_name = "RGBStripes";
  }
  
  void paint(PGraphics f) {
    f.pushStyle();
      for (int row = 0; row < displayHeight; row++) {
          int r = (((row)*2          + 100*1/displayWidth + m_colorAngle +  0)%100)*(255/100);
          int g = (((row)*2          + 100*1/displayWidth + m_colorAngle + 33)%100)*(255/100);
          int b = (((row)*2          + 100*1/displayWidth + m_colorAngle + 66)%100)*(255/100);
        
          f.strokeWeight(1);
          f.stroke(r,g,b);
          f.rect(0, row, displayWidth, 3);
      }
    f.popStyle();
    
    m_colorAngle += m_speed;
  }
}
