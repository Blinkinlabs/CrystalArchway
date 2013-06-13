// Draw a sparkley RGB rainbow on a 2d display
class RainbowColors extends Pattern {
  long m_frameStart;
  
  RainbowColors() {
    m_frameStart = frameCount;
  }
  
  void draw(PGraphics f) {
    long frame = frameCount - m_frameStart;
    
    f.colorMode(HSB, 100);
    
    for(int x = 0; x < displayWidth; x++) {
      for(int y = 0; y < displayHeight; y++) {
        if (x < displayWidth/2) {
          f.stroke((pow(x,0.3)*pow(y,.8)+frame)%100,90*random(.2,1.8),90*random(.5,1.5));
        }
        else {
          f.stroke((pow(displayWidth-x,0.3)*pow(y,.8)+frame)%100,90*random(.2,1.8),90*random(.5,1.5));
        }
        f.point((x+frame)%displayWidth,y);
      }
    }
    
    f.colorMode(RGB, 255);
  }
}
