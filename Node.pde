class Node {
  public int m_name;
  public float m_posX;
  public float m_posY;
  public float m_posZ;
  
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
