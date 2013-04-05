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
  Edges.add(new Edge(0, BOX0 + 7,  26, 0, 1));
  Edges.add(new Edge(0, BOX0 + 7,  60, 1, 2));
  Edges.add(new Edge(0, BOX0 + 7,  94, 2, 3));
  Edges.add(new Edge(0, BOX0 + 7, 128, 3, 0));
  
  Edges.add(new Edge(0, BOX0 + 5,  26, 0, 4));
  Edges.add(new Edge(0, BOX0 + 5,  60, 4, 2));
  Edges.add(new Edge(0, BOX0 + 5,  94, 2, 5));
  Edges.add(new Edge(0, BOX0 + 5, 128, 5, 0));
  
  Edges.add(new Edge(0, BOX0 + 4,  26, 1, 5));
  Edges.add(new Edge(0, BOX0 + 4,  60, 5, 3));
  Edges.add(new Edge(0, BOX0 + 4,  96, 3, 4));
  Edges.add(new Edge(0, BOX0 + 4, 128, 4, 1));
}

