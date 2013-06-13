// Bouncy things
// A 2d particle pattern, lots of squares that bounce off the edges of a 2d screen.
class BouncyThings extends Pattern {
  List<BouncyThing> bouncyThings;
  
  void paint(PGraphics f) {
    if(bouncyThings == null) {
      bouncyThings = new LinkedList<BouncyThing>();
      for(int i = 0; i < 30; i++) {
        color c = color(random(0,255),random(0,255),random(0,255));
        bouncyThings.add(new BouncyThing(c));
      }
    }
    
    for (BouncyThing bt : bouncyThings) {
      bt.paint(f);
    }
  }
}

class BouncyThing extends Pattern {
  int m_x      = 0;
  int m_y      = 0;
  int m_width  = displayWidth;
  int m_height = displayHeight;
  
  int m_step   = 0;

  color m_c;
  float m_xPos;
  float m_yPos;
  float m_xVelocity;
  float m_yVelocity;

  float m_minVelocity = .1;
  float m_maxVelocity = 2;
  
  float m_size = 5;
  
  BouncyThing(color c) {
    m_xPos = random(0,displayWidth);
    m_yPos = random(0,displayHeight);
    m_c = c;
    
    m_xVelocity = random(-m_maxVelocity, m_maxVelocity);
    m_yVelocity = random(-m_maxVelocity, m_maxVelocity);
  }
  
  void paint(PGraphics f) {
    
    f.pushStyle();
      f.fill(m_c);
      f.noStroke();
      f.rect(m_x + m_xPos, m_y + m_yPos, m_size, m_size);
    f.popStyle();
    
    m_xPos += m_xVelocity;
    if(m_xPos > m_width - m_size) {
      m_xVelocity = -random(m_minVelocity, m_maxVelocity);
    }
    if(m_xPos < 0) {
      m_xVelocity = random(m_minVelocity, m_maxVelocity);
    }

    m_yPos += m_yVelocity;
    if(m_yPos > m_height - m_size) {
      m_yVelocity = -random(m_minVelocity, m_maxVelocity);
    }
    if(m_yPos < 0) {
      m_yVelocity = random(m_minVelocity, m_maxVelocity);
    }

  }
}

