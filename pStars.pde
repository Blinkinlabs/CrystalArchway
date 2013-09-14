class Stars extends Pattern {
  List<Star> m_stars;
  
  Stars() {
    m_name = "Stars";
    
    reset();
  }
  
  void reset() {
    m_stars = new LinkedList<Star>();
    
    for(int i = 0; i < 100; i++) {
      m_stars.add(new Star());
    }
  }
  
  void paint(PGraphics f) {
    for(Star s : m_stars) {
      s.paint(f);
    }
  }
}

// A particle is stuck to the graph of the sculpture
class Star extends Pattern {
  List<Edge> m_lowestEdges; 
  
  int m_length;
  color m_color;
  
  Edge m_edge;
  float m_position;
  
  float m_speed;
  
  Boolean m_direction;
  
  Star() {    
    m_name = "Star";
    
    // Make a list of the lowest edges
    float lowestY = Float.MAX_VALUE;
    for(Edge e : edges) {
      lowestY = min(e.getCentroid().y, lowestY);
    }
    
    m_lowestEdges = new LinkedList<Edge>();
    for(Edge e : edges) {
      if(e.getCentroid().y < lowestY + .1) {
        m_lowestEdges.add(e);
      }
    }
    
    
    reset();
  }
  
  void reset() {
    m_length = 1;
    m_color = color(0,255,255);
    
    // starting position
    m_edge = m_lowestEdges.get(int(random(0,m_lowestEdges.size())));
    m_position = 0;
    m_speed = random(0.5,1.5);
    m_direction = true;
  }
  
  void paint(PGraphics f) {
    m_edge.paint(f,int(m_position), m_color);
    
    // Update the star position
    
    if(m_direction == true) {
      m_position += m_speed;
    }
    else {
      m_position -= m_speed;
    }
      
    if(m_position >= m_edge.m_length || m_position < 0) {
      // Figure out where we are escaping to
      int exitNode;
      if(m_direction == true) {
        exitNode = m_edge.m_endNode;
      }
      else {
        exitNode = m_edge.m_startNode;
      }

      // Pick a new edge to jump to
      List<Edge> jumpEdges = nodes.get(exitNode).getConnectedEdges();
  
      // Filter out any edges that are lower than this one
      float oldY = m_edge.getCentroid().y;
      for (int i = jumpEdges.size() - 1; i >= 0; --i) {
        if (jumpEdges.get(i).getCentroid().y <= oldY + .3) {  // Note: Tweak this to be ~1/2 edge length
          jumpEdges.remove(i);
        }
      }
      
      if(jumpEdges.size() > 0) {
        // Random change
        Edge oldEdge = m_edge;
        while (oldEdge == m_edge) {
          m_edge = jumpEdges.get(int(random(0, jumpEdges.size())));
        }
        
        // and jump to the correct end of that edge
        if(m_edge.m_startNode == exitNode) {
          m_position = 0;
          m_direction = true;
        }
        else {
          m_position = m_edge.m_length - 1;
          m_direction = false;
        }
      }
      else {
        reset();
      }
    }
  }
}

