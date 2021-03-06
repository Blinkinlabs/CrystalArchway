// A pattern that lights up a single edge with a solid color that changes randomly
class PulsingNode extends Pattern {
  Node m_node;
  color m_color;
  
  float m_phase;
  
  PulsingNode(Node node) {
    m_node = node;
    
    m_color = color(0,255,0);
    
    m_name = "PulsingNode" + node.m_name;
  }
  
  void paint(PGraphics f) {
    for(Edge e : g_edges) {
      if(e.m_startNode == m_node.m_name) {
        for(int i = 0; i < 3 + 3*sin(m_phase); i++) {
          e.paint(f, i, m_color);
        }
      }
      if(e.m_endNode == m_node.m_name) {
        for(int i = 0; i < 3 + 3*sin(m_phase); i++) {
          e.paint(f, e.m_length - 1 - i, m_color);
        }
      }
    }
    
    m_phase += .1;
  }
}

