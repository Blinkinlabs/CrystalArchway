// Draw a sparkley RGB rainbow on a 2d display
class RainbowColors extends Pattern {
  long m_frameStart;
  
  RainbowColors() {
    m_frameStart = frameCount;
    
    m_name = "RainbowColors";
  }
  
  void paint(PGraphics f) {
    long frame = frameCount - m_frameStart;
    
    f.pushStyle();
      f.colorMode(HSB, 100);
    
      for(int x = 0; x < displayWidth; x++) {
        for(int y = 0; y < displayHeight; y++) {
          color c;
        
          if (x < displayWidth/2) {
            c = color((pow(x,0.3)*pow(y,.8)+frame)%100,
                      90*random(.2,1.8),
                      90*random(.5,1.5));
          }
          else {
            c = color((pow(displayWidth-x,0.3)*pow(y,.8)+frame)%100,
                      90*random(.2,1.8),
                      90*random(.5,1.5));
          }
          f.stroke(c);
          f.strokeWeight(1);
          f.point(x,y);
          //f.set(x,y, c);
        }
      }
    f.popStyle();
//    f.colorMode(RGB, 255);
  }
}
