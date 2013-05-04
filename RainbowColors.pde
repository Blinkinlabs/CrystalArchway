// Draw a sparkley RGB rainbow on a 2d display
class RainbowColors extends Pattern {
  void draw() {
    long frame = frameCount - modeFrameStart;
    
    colorMode(HSB, 100);
    
    for(int x = 0; x < displayWidth; x++) {
      for(int y = 0; y < displayHeight; y++) {
        if (x < displayWidth/2) {
          stroke((pow(x,0.3)*pow(y,.8)+frame)%100,90*random(.2,1.8),90*random(.5,1.5));
        }
        else {
          stroke((pow(displayWidth-x,0.3)*pow(y,.8)+frame)%100,90*random(.2,1.8),90*random(.5,1.5));
        }
        point((x+frame)%displayWidth,y);
      }
    }
    
    colorMode(RGB, 255);
  }
}
