//// Share this between the transmitter and simulator.


void defineNodes() {
  Nodes = new LinkedList<Node>();
  Nodes.add(new Node(0,      0, -1.414,      0));
  Nodes.add(new Node(1,  1.414,      0,      0));
  Nodes.add(new Node(2,      0,  1.414,      0));
  Nodes.add(new Node(3, -1.414,      0,      0));
  Nodes.add(new Node(4,      0,      0,  1.414));
  Nodes.add(new Node(5,      0,      0, -1.414));
}

void defineEdges() {
  Edges = new LinkedList<Edge>();
  Edges.add(new Edge(0, BOX0 + 7,  28, 0, 1));
  Edges.add(new Edge(0, BOX0 + 7,  62, 1, 2));
  Edges.add(new Edge(0, BOX0 + 7,  96, 2, 3));
  Edges.add(new Edge(0, BOX0 + 7, 130, 3, 0));
  
  Edges.add(new Edge(0, BOX0 + 5,  28, 0, 4));
  Edges.add(new Edge(0, BOX0 + 5,  62, 4, 2));
  Edges.add(new Edge(0, BOX0 + 5,  96, 2, 5));
  Edges.add(new Edge(0, BOX0 + 5, 130, 5, 0));
  
  Edges.add(new Edge(0, BOX0 + 4,  28, 1, 5));
  Edges.add(new Edge(0, BOX0 + 4,  62, 5, 3));
  Edges.add(new Edge(0, BOX0 + 4,  96, 3, 4));
  Edges.add(new Edge(0, BOX0 + 4, 130, 4, 1));
}

