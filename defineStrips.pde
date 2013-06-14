//// Share this between the transmitter and simulator.


List<Node> defineNodes() {
  // Given an iscocoles triangle with side length L=1, like this:
  //       a
  //      / \ 
  //     /   \
  //    /  x  \
  //   /       \    
  //  /_________\  
  // b           c
  // where x is at (0,0), it follows that:
  // a is at (0, 1/(2*cos(30))  ~= (  0,  .577)
  // b is at (-.5, -tan(30)/2)  ~= (-.5, -.289)
  // c is at (-.5, tan(30)/2)   ~= ( .5, -.289)
  float A = .5;
  float B = .298;
  float C = .577;
  float D = .8; // fixme, just a guess.
  
  List<Node> Nodes = new LinkedList<Node>();
  Nodes.add(new Node( 0,     0,     0,     C));  // layer 0
  Nodes.add(new Node( 1,    -A,     0,    -B));
  Nodes.add(new Node( 2,     A,     0,    -B));
  Nodes.add(new Node( 3,     0,     D,    -C));  // layer 1
  Nodes.add(new Node( 4,     A,     D,     B));
  Nodes.add(new Node( 5,    -A,     D,     B));
  Nodes.add(new Node( 6,     0,   2*D,     C));  // layer 2
  Nodes.add(new Node( 7,    -A,   2*D,    -B));
  Nodes.add(new Node( 8,     A,   2*D,    -B));
  Nodes.add(new Node( 9,     0,   3*D,    -C));  // layer 3
  Nodes.add(new Node(10,     A,   3*D,     B));
//  Nodes.add(new Node(11,    -A,   3*D,     B));
  
  float zAng = atan((C-B)/D);
  float offZ = 2*D*sin(zAng);
  float offX = 2*D*cos(zAng)*sin(3.14159/3);
  float offY = 2*D*cos(zAng)*cos(3.14159/3);

  Nodes.add(new Node(11,     0+offX,   2*D+offZ,     C-offY));  // layer 4 (note: faced from edge of layer 2-3 connection)
  Nodes.add(new Node(12,    -A+offX,   2*D+offZ,    -B-offY));
  Nodes.add(new Node(13,    -A+offX,   3*D+offZ,     B-offY));
 
  return Nodes; 
}

List<Edge> defineEdges() {
  int BOX3 = 0;
  
  int BOX1 = 8;
  int BOX2 = 16;
  int BOX0 = 24;
  int BOX4 = 32;
  
  List<Edge> Edges = new LinkedList<Edge>();
////  Edges.add(new Edge(0, BOX3 + 0,   0,  0,  1));   // layer 0
////  Edges.add(new Edge(0, BOX3 + 0,  32,  1,  2));
////  Edges.add(new Edge(0, BOX3 + 0,  64,  2,  0));
////
////  Edges.add(new Edge(0, BOX3 + 0,  96,  0,  4));   // layer 0-1 connections
////  Edges.add(new Edge(0, BOX3 + 0, 128,  0,  5));
////  Edges.add(new Edge(0, BOX3 + 1,   0,  1,  5));
////  Edges.add(new Edge(0, BOX3 + 1,  32,  1,  3));
////  Edges.add(new Edge(0, BOX3 + 1,  64,  2,  3));
////  Edges.add(new Edge(0, BOX3 + 1,  96,  2,  4));
//  
//  Edges.add(new Edge(0, BOX3 + 1, 128,  3,  4));   // layer 1
//  Edges.add(new Edge(0, BOX3 + 2,   0,  4,  5));
//  Edges.add(new Edge(0, BOX3 + 2,  32,  5,  3));
//
//  Edges.add(new Edge(0, BOX3 + 2,  64,  3,  7));   // layer 1-2 connections
//  Edges.add(new Edge(0, BOX3 + 2,  96,  3,  8));
//  Edges.add(new Edge(0, BOX3 + 2, 128,  4,  8));
//  Edges.add(new Edge(0, BOX3 + 3,   0,  4,  6));
//  Edges.add(new Edge(0, BOX3 + 3,  32,  5,  6));
//  Edges.add(new Edge(0, BOX3 + 3,  64,  5,  7));
//
//  Edges.add(new Edge(0, BOX3 + 3,  96,  6,  7));   // layer 2
//  Edges.add(new Edge(0, BOX3 + 3, 128,  7,  8));
//  Edges.add(new Edge(0, BOX3 + 4,   0,  8,  6));
//  
//  Edges.add(new Edge(0, BOX3 + 4,  32,  6, 10));   // layer 2-3 connections
////  Edges.add(new Edge(0, BOX3 + 7,  60,  6, 11));
////  Edges.add(new Edge(0, BOX3 + 7,  26,  7, 11));
//  Edges.add(new Edge(0, BOX3 + 4,  64,  7,  9));
//  Edges.add(new Edge(0, BOX3 + 4,  96,  8,  9));
//  Edges.add(new Edge(0, BOX3 + 4, 128,  8, 10));
//
//  Edges.add(new Edge(0, BOX3 + 5,   0,  9, 10));   // layer 3 (note:truncated)
////  Edges.add(new Edge(0, BOX3 + 7,  26, 10, 11));
////  Edges.add(new Edge(0, BOX3 + 7,  26, 11,  9));
//
//  Edges.add(new Edge(0, BOX3 + 5,  32,  9, 12));   // layer 2/3-4 connections
//  Edges.add(new Edge(0, BOX3 + 5,  64,  9, 13));
//  Edges.add(new Edge(0, BOX3 + 5,  96, 10, 13));
//  Edges.add(new Edge(0, BOX3 + 5, 128, 10, 11));
//  Edges.add(new Edge(0, BOX3 + 6,   0,  8, 11));
//  Edges.add(new Edge(0, BOX3 + 6,  32,  8, 12));
//
//  Edges.add(new Edge(0, BOX3 + 6,  64, 11, 12));   // layer 4
//  Edges.add(new Edge(0, BOX3 + 6,  96, 12, 13));
//  Edges.add(new Edge(0, BOX3 + 6, 128, 13, 11));
  
// Start of edge defines
  Edges.add(new Edge(   0,   6, 102,   3,   4));
  Edges.add(new Edge(   0,   2,  33,   4,   5));
  Edges.add(new Edge(   0,   1,  33,   5,   3));
  Edges.add(new Edge(   0,   6,  68,   3,   7));
  Edges.add(new Edge(   0,   1,   0,   3,   8));
  Edges.add(new Edge(   0,   2,   0,   4,   8));
  Edges.add(new Edge(   0,   6,   0,   4,   6));
  Edges.add(new Edge(   0,   1,  68,   5,   6));
  Edges.add(new Edge(   0,   2,  68,   5,   7));
  Edges.add(new Edge(   0,   6,  34,   6,   7));
  Edges.add(new Edge(   0,   7, 133,   7,   8));
  Edges.add(new Edge(   0,   8, 138,   8,   6));
  Edges.add(new Edge(   0,   1, 102,   6,  10));
  Edges.add(new Edge(   0,   2, 101,   7,   9));
  Edges.add(new Edge(   0,   8, 103,   8,   9));
  Edges.add(new Edge(   0,   7,   0,   8,  10));
  Edges.add(new Edge(   0,   5, 101,   9,  10));
  Edges.add(new Edge(   0,   5,  67,   9,  12));
  Edges.add(new Edge(   0,   8,  67,   9,  13));
  Edges.add(new Edge(   0,   7,  33,  10,  13));
  Edges.add(new Edge(   0,   5,   0,  10,  11));
  Edges.add(new Edge(   0,   8,   0,   8,  11));
  Edges.add(new Edge(   0,   7, 100,   8,  12));
  Edges.add(new Edge(   0,   5,  34,  11,  12));
  Edges.add(new Edge(   0,   7,  66,  12,  13));
  Edges.add(new Edge(   0,   8,  34,  13,  11));
// End of edge defines
  
  return Edges;
}

