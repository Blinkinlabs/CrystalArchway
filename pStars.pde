class Stars extends Pattern {
  List<Star> m_stars;
  
  Stars() {
    m_name = "Stars";
    m_stars = new LinkedList<Star>();
    
    for(int i = 0; i < 30; i++) {
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
  int m_length;
  color m_color;
  
  Edge m_edge;
  int m_position;
  Boolean m_direction;
  
  Star() {
    m_length = 1;
    m_color = color(0,255,255);
    
    // starting position
    m_edge = edges.get(4);
    m_position = 0;
    m_direction = true;
    
    m_name = "Star";
  }
  
  void paint(PGraphics f) {
    m_edge.paint(f,m_position, m_color);
    
    // Update the star position
    
    if(m_direction == true) {
      m_position +=1;
    }
    else {
      m_position -=1;
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
  }
}

