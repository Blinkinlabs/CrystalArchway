// A pattern that lights up a single edge with a solid color that changes randomly
class ThreeDFlood extends Pattern {
//  float m_height;
  color m_color;
  
  float m_phase;
  
  ThreeDFlood() {
    m_color = color(0,0,255);
  }
  
  void paint(PGraphics f) {
    float m_height = (sin(m_phase)+1) + .8;
    for( Edge e : edges) {
        for(int i = 0; i < e.m_length; i++) {
          PVector coords = e.getPixelCoordinates(i);
          if (sin(coords.z*2 + m_phase*2) > 0) {
            e.paint(f, i, color(0,0,255));
          }
          else {
            e.paint(f, i, color(0,0,0));
          }
            //e.paint(f, i, color((sin(coords.x*3 + m_phase*2) + 1)*128,
                                //(sin(coords.y*3 + m_phase*3.2) + 1)*128,
                                //(sin(coords.z*3 + m_phase*4.3) + 1)*128));
      }
      // Otherwise we're high and dry!
    }
    
    m_phase += .02;
  }
}

