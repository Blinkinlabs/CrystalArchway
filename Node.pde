class Node {
  public int m_name;
  public float m_posX;
  public float m_posY;
  public float m_posZ;

  // For graph nodes, rotate points about the Y axis
  Node(int name, float posX, float posY, float posZ, float angle) {
    m_name = name;
    // Crystal archway hack- pre-rotate and shift the structures
    float posX_ = posX*cos(PI/6) - posZ*sin(PI/6);
    float posY_ = posY;
    float posZ_ = posX*sin(PI/6) + posZ*cos(PI/6);
    posX_ = posX_ - 1.52;
    
    m_posX = posX_*cos(angle) - posZ_*sin(angle);
    m_posY = posY_;
    m_posZ = posX_*sin(angle) + posZ_*cos(angle);
  }
  
  // For graph nodes
  // @param name Name of the segment
  // @param posX // Spacial position of the node
  // @param posY
  // @param posZ
  Node(int name, float posX, float posY, float posZ) {
    m_name = name;
    m_posX = posX;
    m_posY = posY;
    m_posZ = posZ;
  }
}
