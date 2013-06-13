class Edge {
  public int m_strip;
  public int m_offset;
  public int m_length;

  public int m_name;
  public int m_startNode;
  public int m_endNode;

  // For LED Tree edges
  // @param name Name of the edge
  // @param strip Strip number (0-7, one for each bb8 output)
  // @param offset 
  // @param startNode Node that the edge starts at
  // @param endNode Node that the edge ends at
  Edge(int name, int strip, int offset, int startNode, int endNode) {
    m_name = name;
    m_strip = strip;
    m_offset = offset;
    m_length = 31;  // For simplicity
    m_startNode = startNode;
    m_endNode = endNode;
  }

  // Paint a solid color along the whole edge
  void draw(PGraphics f, color c) {
    stroke(c);
    line(m_strip, m_offset, m_strip, m_offset + m_length);
  }
  
  // Draw a dot at a single pixel position
  void draw(color c, int position) {
    stroke(c);
    point(m_strip, m_offset + position);
  }
}

