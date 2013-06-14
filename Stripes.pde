class Stripes extends Pattern {

  int m_x      = 0;
  int m_y      = 0;
  int m_width  = displayWidth;  
  int m_height = displayHeight;
  
  float m_step          = 0;
  float m_stepSize      = .2;
  int m_stripSeparation = 7;
  int m_lineWidth       = 2;
  
  void paint(PGraphics f) {
    f.pushStyle();
      f.noStroke();
      f.noSmooth();
      f.fill(255);
      for (int col = (int)m_step; col < m_width; col+=m_stripSeparation) {
        f.rect(m_x + col, m_y, m_lineWidth, m_height); 
      }

//      for (int col = (int)m_step; col < m_height; col+=m_stripSeparation) {
//        rect(m_x, m_y + col, m_width, m_lineWidth); 
//      }

    f.popStyle();

    m_step = (m_step+m_stepSize)%m_stripSeparation;
  }
}

