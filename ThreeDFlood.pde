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

// Rainbow sweeps
//            float r = (sin(coords.x*3 + m_phase  ) + 1)*128*random(.8,1);
//            float g = (sin(coords.y*3 + m_phase*3.2) + 1)*128*random(.8,1);
//            float b = (sin(coords.z*3 + m_phase*4.3) + 1)*128*random(.8,1);
//            e.paint(f, i, color(r,g,b));

// Rainbow sweeps
            float r = (((coords.x*3 + m_phase    )%10>5) ? 255.0 : 0.0);
            float g = (((coords.y*3 + m_phase*3.2)%10>5) ? 255.0 : 0.0);
            float b = (((coords.z*3 + m_phase*4.3)%10>5) ? 255.0 : 0.0);
            e.paint(f, i, color(r,g,b));

      }
      // Otherwise we're high and dry!
    }
    
    m_phase += random(.01,.03);
  }
}

