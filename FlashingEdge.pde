// A pattern that lights up a single edge with a solid color that changes randomly
class FlashingEdge extends Pattern {
  Edge m_edge;
  
  FlashingEdge(Edge edge, int channel, int pitch, int velocity) {
    super(channel, pitch, velocity);
    m_edge = edge;
  }
  
  void paint(PGraphics f) {
    color c = color(random(100,255), random(100, 255), random(100, 255));
    m_edge.paint(f, c);
  }
}

