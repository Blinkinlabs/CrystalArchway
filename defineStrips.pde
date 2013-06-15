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

  float zAng = atan((C-B)/D);
  float offZ = 2*D*sin(zAng);
  float offX = 2*D*cos(zAng)*sin(3.14159/3);
  float offY = 2*D*cos(zAng)*cos(3.14159/3);

  List<Node> Nodes = new LinkedList<Node>();

  // Structure A
  Nodes.add(new Node( 0, 0, 0, C, 0));  // layer 0
  Nodes.add(new Node( 1, -A, 0, -B, 0));
  Nodes.add(new Node( 2, A, 0, -B, 0));
  Nodes.add(new Node( 3, 0, D, -C, 0));  // layer 1
  Nodes.add(new Node( 4, A, D, B, 0));
  Nodes.add(new Node( 5, -A, D, B, 0));
  Nodes.add(new Node( 6, 0, 2*D, C, 0));  // layer 2
  Nodes.add(new Node( 7, -A, 2*D, -B, 0));
  Nodes.add(new Node( 8, A, 2*D, -B, 0));
  Nodes.add(new Node( 9, 0, 3*D, -C, 0));  // layer 3
  Nodes.add(new Node(10, A, 3*D, B, 0));

  Nodes.add(new Node(11, 0+offX, 2*D+offZ, C-offY, 0));  // layer 4 (note: faced from edge of layer 2-3 connection)
  Nodes.add(new Node(12, -A+offX, 2*D+offZ, -B-offY, 0));
  Nodes.add(new Node(13, -A+offX, 3*D+offZ, B-offY, 0));


  //Structure B  
  Nodes.add(new Node(14, 0, 0, C, PI*2/3));  // layer 0
  Nodes.add(new Node(15, -A, 0, -B, PI*2/3));
  Nodes.add(new Node(16, A, 0, -B, PI*2/3));
  Nodes.add(new Node(17, 0, D, -C, PI*2/3));  // layer 1
  Nodes.add(new Node(18, A, D, B, PI*2/3));
  Nodes.add(new Node(19, -A, D, B, PI*2/3));
  Nodes.add(new Node(20, 0, 2*D, C, PI*2/3));  // layer 2
  Nodes.add(new Node(21, -A, 2*D, -B, PI*2/3));
  Nodes.add(new Node(22, A, 2*D, -B, PI*2/3));
  Nodes.add(new Node(23, 0, 3*D, -C, PI*2/3));  // layer 3
  Nodes.add(new Node(24, A, 3*D, B, PI*2/3));

  Nodes.add(new Node(25, 0+offX, 2*D+offZ, C-offY, PI*2/3));  // layer 4 (note: faced from edge of layer 2-3 connection)
  Nodes.add(new Node(26, -A+offX, 2*D+offZ, -B-offY, PI*2/3));
  Nodes.add(new Node(27, -A+offX, 3*D+offZ, B-offY, PI*2/3));


  //Structure C
  Nodes.add(new Node(28, 0, 0, C, PI*4/3));  // layer 0
  Nodes.add(new Node(29, -A, 0, -B, PI*4/3));
  Nodes.add(new Node(30, A, 0, -B, PI*4/3));
  Nodes.add(new Node(31, 0, D, -C, PI*4/3));  // layer 1
  Nodes.add(new Node(32, A, D, B, PI*4/3));
  Nodes.add(new Node(33, -A, D, B, PI*4/3));
  Nodes.add(new Node(34, 0, 2*D, C, PI*4/3));  // layer 2
  Nodes.add(new Node(35, -A, 2*D, -B, PI*4/3));
  Nodes.add(new Node(36, A, 2*D, -B, PI*4/3));
  Nodes.add(new Node(37, 0, 3*D, -C, PI*4/3));  // layer 3
  Nodes.add(new Node(38, A, 3*D, B, PI*4/3));

  Nodes.add(new Node(39, 0+offX, 2*D+offZ, C-offY, PI*4/3));  // layer 4 (note: faced from edge of layer 2-3 connection)
  Nodes.add(new Node(41, -A+offX, 2*D+offZ, -B-offY, PI*4/3));
  Nodes.add(new Node(42, -A+offX, 3*D+offZ, B-offY, PI*4/3));

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

  //  // TODO: bottom piece
  //  Edges.add(new Edge(   0,   0,   0,  false,  0,   1,  0));
  //  Edges.add(new Edge(   0,   0,  32,  false,  1,   2,  0));
  //  Edges.add(new Edge(   0,   0,  64,  false,  2,   0,  0));
  //  Edges.add(new Edge(   0,   0,  96,  false,  0,   4,  0));
  //  Edges.add(new Edge(   0,   0, 128,  false,  0,   5,  0));
  //  Edges.add(new Edge(   0,   1,   0,  false,  1,   5,  0));
  //  Edges.add(new Edge(   0,   1,  32,  false,  1,   3,  0));
  //  Edges.add(new Edge(   0,   1,  64,  false,  2,   3,  0));
  //  Edges.add(new Edge(   0,   1,  96,  false,  2,   4,  0));
  //  
  //  Edges.add(new Edge(   0,   5, 102, false,   3,   4,  0));
  //  Edges.add(new Edge(   0,   1,  33, false,   4,   5,  0));
  //  Edges.add(new Edge(   0,   0,  33,  true,   5,   3,  0));
  //  Edges.add(new Edge(   0,   5,  68,  true,   3,   7,  0));
  //  Edges.add(new Edge(   0,   0,   0,  true,   3,   8,  0));
  //  Edges.add(new Edge(   0,   1,   0,  true,   4,   8,  0));
  //  Edges.add(new Edge(   0,   5,   0, false,   4,   6,  0));
  //  Edges.add(new Edge(   0,   0,  68, false,   5,   6,  0));
  //  Edges.add(new Edge(   0,   1,  68, false,   5,   7,  0));
  //  Edges.add(new Edge(   0,   5,  34, false,   6,   7,  0));
  //  Edges.add(new Edge(   0,   6, 133,  true,   7,   8,  0));
  //  Edges.add(new Edge(   0,   7, 138, false,   8,   6,  0));
  //  Edges.add(new Edge(   0,   0, 102, false,   6,  10,  0));
  //  Edges.add(new Edge(   0,   1, 101, false,   7,   9,  0));
  //  Edges.add(new Edge(   0,   7, 103,  true,   8,   9,  0));
  //  Edges.add(new Edge(   0,   6,   0, false,   8,  10,  0));
  //  Edges.add(new Edge(   0,   4, 101, false,   9,  10,  0));
  //  Edges.add(new Edge(   0,   4,  67,  true,   9,  12,  0));
  //  Edges.add(new Edge(   0,   7,  67,  true,   9,  13,  0));
  //  Edges.add(new Edge(   0,   6,  33, false,  10,  13,  0));
  //  Edges.add(new Edge(   0,   4,   0, false,  10,  11,  0));
  //  Edges.add(new Edge(   0,   7,   0, false,   8,  11,  0));
  //  Edges.add(new Edge(   0,   6, 100,  true,   8,  12,  0));
  //  Edges.add(new Edge(   0,   4,  34, false,  11,  12,  0));
  //  Edges.add(new Edge(   0,   6,  66,  true,  12,  13,  0));
  //  Edges.add(new Edge(   0,   7,  34,  true,  13,  11,  0));
  //  
  //  
  //  // TODO: bottom piece
  //  Edges.add(new Edge(   0,   0,   0,  false,  0,   1, 14));
  //  Edges.add(new Edge(   0,   0,  32,  false,  1,   2, 14));
  //  Edges.add(new Edge(   0,   0,  64,  false,  2,   0, 14));
  //  Edges.add(new Edge(   0,   0,  96,  false,  0,   4, 14));
  //  Edges.add(new Edge(   0,   0, 128,  false,  0,   5, 14));
  //  Edges.add(new Edge(   0,   1,   0,  false,  1,   5, 14));
  //  Edges.add(new Edge(   0,   1,  32,  false,  1,   3, 14));
  //  Edges.add(new Edge(   0,   1,  64,  false,  2,   3, 14));
  //  Edges.add(new Edge(   0,   1,  96,  false,  2,   4, 14));
  //  
  //  Edges.add(new Edge(   0,   5, 102, false,   3,   4, 14));
  //  Edges.add(new Edge(   0,   1,  33, false,   4,   5, 14));
  //  Edges.add(new Edge(   0,   0,  33,  true,   5,   3, 14));
  //  Edges.add(new Edge(   0,   5,  68,  true,   3,   7, 14));
  //  Edges.add(new Edge(   0,   0,   0,  true,   3,   8, 14));
  //  Edges.add(new Edge(   0,   1,   0,  true,   4,   8, 14));
  //  Edges.add(new Edge(   0,   5,   0, false,   4,   6, 14));
  //  Edges.add(new Edge(   0,   0,  68, false,   5,   6, 14));
  //  Edges.add(new Edge(   0,   1,  68, false,   5,   7, 14));
  //  Edges.add(new Edge(   0,   5,  34, false,   6,   7, 14));
  //  Edges.add(new Edge(   0,   6, 133,  true,   7,   8, 14));
  //  Edges.add(new Edge(   0,   7, 138, false,   8,   6, 14));
  //  Edges.add(new Edge(   0,   0, 102, false,   6,  10, 14));
  //  Edges.add(new Edge(   0,   1, 101, false,   7,   9, 14));
  //  Edges.add(new Edge(   0,   7, 103,  true,   8,   9, 14));
  //  Edges.add(new Edge(   0,   6,   0, false,   8,  10, 14));
  //  Edges.add(new Edge(   0,   4, 101, false,   9,  10, 14));
  //  Edges.add(new Edge(   0,   4,  67,  true,   9,  12, 14));
  //  Edges.add(new Edge(   0,   7,  67,  true,   9,  13, 14));
  //  Edges.add(new Edge(   0,   6,  33, false,  10,  13, 14));
  //  Edges.add(new Edge(   0,   4,   0, false,  10,  11, 14));
  //  Edges.add(new Edge(   0,   7,   0, false,   8,  11, 14));
  //  Edges.add(new Edge(   0,   6, 100,  true,   8,  12, 14));
  //  Edges.add(new Edge(   0,   4,  34, false,  11,  12, 14));
  //  Edges.add(new Edge(   0,   6,  66,  true,  12,  13, 14));
  //  Edges.add(new Edge(   0,   7,  34,  true,  13,  11, 14));
  //  
  //  
  //  // TODO: bottom piece
  //  Edges.add(new Edge(   0,   0,   0,  false,  0,   1, 28));
  //  Edges.add(new Edge(   0,   0,  32,  false,  1,   2, 28));
  //  Edges.add(new Edge(   0,   0,  64,  false,  2,   0, 28));
  //  Edges.add(new Edge(   0,   0,  96,  false,  0,   4, 28));
  //  Edges.add(new Edge(   0,   0, 128,  false,  0,   5, 28));
  //  Edges.add(new Edge(   0,   1,   0,  false,  1,   5, 28));
  //  Edges.add(new Edge(   0,   1,  32,  false,  1,   3, 28));
  //  Edges.add(new Edge(   0,   1,  64,  false,  2,   3, 28));
  //  Edges.add(new Edge(   0,   1,  96,  false,  2,   4, 28));
  //  
  //  Edges.add(new Edge(   0,   5, 102, false,   3,   4, 28));
  //  Edges.add(new Edge(   0,   1,  33, false,   4,   5, 28));
  //  Edges.add(new Edge(   0,   0,  33,  true,   5,   3, 28));
  //  Edges.add(new Edge(   0,   5,  68,  true,   3,   7, 28));
  //  Edges.add(new Edge(   0,   0,   0,  true,   3,   8, 28));
  //  Edges.add(new Edge(   0,   1,   0,  true,   4,   8, 28));
  //  Edges.add(new Edge(   0,   5,   0, false,   4,   6, 28));
  //  Edges.add(new Edge(   0,   0,  68, false,   5,   6, 28));
  //  Edges.add(new Edge(   0,   1,  68, false,   5,   7, 28));
  //  Edges.add(new Edge(   0,   5,  34, false,   6,   7, 28));
  //  Edges.add(new Edge(   0,   6, 133,  true,   7,   8, 28));
  //  Edges.add(new Edge(   0,   7, 138, false,   8,   6, 28));
  //  Edges.add(new Edge(   0,   0, 102, false,   6,  10, 28));
  //  Edges.add(new Edge(   0,   1, 101, false,   7,   9, 28));
  //  Edges.add(new Edge(   0,   7, 103,  true,   8,   9, 28));
  //  Edges.add(new Edge(   0,   6,   0, false,   8,  10, 28));
  //  Edges.add(new Edge(   0,   4, 101, false,   9,  10, 28));
  //  Edges.add(new Edge(   0,   4,  67,  true,   9,  12, 28));
  //  Edges.add(new Edge(   0,   7,  67,  true,   9,  13, 28));
  //  Edges.add(new Edge(   0,   6,  33, false,  10,  13, 28));
  //  Edges.add(new Edge(   0,   4,   0, false,  10,  11, 28));
  //  Edges.add(new Edge(   0,   7,   0, false,   8,  11, 28));
  //  Edges.add(new Edge(   0,   6, 100,  true,   8,  12, 28));
  //  Edges.add(new Edge(   0,   4,  34, false,  11,  12, 28));
  //  Edges.add(new Edge(   0,   6,  66,  true,  12,  13, 28));
  //  Edges.add(new Edge(   0,   7,  34,  true,  13,  11, 28));
  //// End of edge defines

  // Start of edge defines
  Edges.add(new Edge(   0, 0, 0, false, 0, 1, 0));
  Edges.add(new Edge(   0, 0, 32, false, 1, 2, 0));
  Edges.add(new Edge(   0, 0, 64, false, 2, 0, 0));
  Edges.add(new Edge(   0, 0, 96, false, 0, 4, 0));
  Edges.add(new Edge(   0, 0, 128, false, 0, 5, 0));
  Edges.add(new Edge(   0, 1, 0, false, 1, 5, 0));
  Edges.add(new Edge(   0, 1, 32, false, 1, 3, 0));
  Edges.add(new Edge(   0, 1, 64, false, 2, 3, 0));
  Edges.add(new Edge(   0, 1, 96, false, 2, 4, 0));
  Edges.add(new Edge(   0, 5, 102, false, 3, 4, 0));
  Edges.add(new Edge(   0, 1, 33, false, 4, 5, 0));
  Edges.add(new Edge(   0, 0, 33, true, 5, 3, 0));
  Edges.add(new Edge(   0, 5, 68, true, 3, 7, 0));
  Edges.add(new Edge(   0, 0, 0, true, 3, 8, 0));
  Edges.add(new Edge(   0, 1, 0, true, 4, 8, 0));
  Edges.add(new Edge(   0, 5, 0, false, 4, 6, 0));
  Edges.add(new Edge(   0, 0, 68, false, 5, 6, 0));
  Edges.add(new Edge(   0, 1, 68, false, 5, 7, 0));
  Edges.add(new Edge(   0, 5, 34, false, 6, 7, 0));
  Edges.add(new Edge(   0, 6, 133, true, 7, 8, 0));
  Edges.add(new Edge(   0, 7, 138, false, 8, 6, 0));
  Edges.add(new Edge(   0, 0, 102, false, 6, 10, 0));
  Edges.add(new Edge(   0, 1, 101, false, 7, 9, 0));
  Edges.add(new Edge(   0, 7, 103, true, 8, 9, 0));
  Edges.add(new Edge(   0, 6, 0, false, 8, 10, 0));
  Edges.add(new Edge(   0, 4, 101, false, 9, 10, 0));
  Edges.add(new Edge(   0, 4, 67, true, 9, 12, 0));
  Edges.add(new Edge(   0, 7, 67, true, 9, 13, 0));
  Edges.add(new Edge(   0, 6, 33, false, 10, 13, 0));
  Edges.add(new Edge(   0, 4, 0, false, 10, 11, 0));
  Edges.add(new Edge(   0, 7, 0, false, 8, 11, 0));
  Edges.add(new Edge(   0, 6, 100, true, 8, 12, 0));
  Edges.add(new Edge(   0, 4, 34, false, 11, 12, 0));
  Edges.add(new Edge(   0, 6, 66, true, 12, 13, 0));
  Edges.add(new Edge(   0, 7, 34, true, 13, 11, 0));
  Edges.add(new Edge(   0, 12, 99, false, 14, 15, 0));
  Edges.add(new Edge(   0, 12, 133, false, 15, 16, 0));
  Edges.add(new Edge(   0, 12, 65, false, 16, 14, 0));
  Edges.add(new Edge(   0, 13, 100, false, 14, 18, 0));
  Edges.add(new Edge(   0, 13, 66, true, 14, 19, 0));
  Edges.add(new Edge(   0, 13, 34, false, 15, 19, 0));
  Edges.add(new Edge(   0, 13, 0, true, 15, 17, 0));
  Edges.add(new Edge(   0, 12, 31, true, 16, 17, 0));
  Edges.add(new Edge(   0, 13, 132, true, 16, 18, 0));
  Edges.add(new Edge(   0, 15, 101, true, 17, 18, 0));
  Edges.add(new Edge(   0, 9, 34, false, 18, 19, 0));
  Edges.add(new Edge(   0, 11, 33, true, 19, 17, 0));
  Edges.add(new Edge(   0, 15, 0, false, 17, 21, 0));
  Edges.add(new Edge(   0, 11, 0, true, 17, 22, 0));
  Edges.add(new Edge(   0, 9, 0, true, 18, 22, 0));
  Edges.add(new Edge(   0, 15, 67, true, 18, 20, 0));
  Edges.add(new Edge(   0, 11, 67, false, 19, 20, 0));
  Edges.add(new Edge(   0, 9, 68, false, 19, 21, 0));
  Edges.add(new Edge(   0, 15, 33, true, 20, 21, 0));
  Edges.add(new Edge(   0, 14, 134, true, 21, 22, 0));
  Edges.add(new Edge(   0, 10, 135, false, 22, 20, 0));
  Edges.add(new Edge(   0, 11, 101, false, 20, 24, 0));
  Edges.add(new Edge(   0, 9, 101, false, 21, 23, 0));
  Edges.add(new Edge(   0, 10, 0, false, 22, 23, 0));
  Edges.add(new Edge(   0, 14, 0, false, 22, 24, 0));
  Edges.add(new Edge(   0, 8, 35, false, 23, 24, 0));
  Edges.add(new Edge(   0, 8, 0, true, 23, 26, 0));
  Edges.add(new Edge(   0, 10, 34, false, 23, 27, 0));
  Edges.add(new Edge(   0, 14, 34, false, 24, 27, 0));
  Edges.add(new Edge(   0, 8, 69, false, 24, 25, 0));
  Edges.add(new Edge(   0, 10, 102, true, 22, 25, 0));
  Edges.add(new Edge(   0, 14, 101, true, 22, 26, 0));
  Edges.add(new Edge(   0, 8, 103, false, 25, 26, 0));
  Edges.add(new Edge(   0, 14, 67, true, 26, 27, 0));
  Edges.add(new Edge(   0, 10, 68, false, 27, 25, 0));
  Edges.add(new Edge(   0, 0, 0, false, 28, 29, 0));
  Edges.add(new Edge(   0, 0, 32, false, 29, 30, 0));
  Edges.add(new Edge(   0, 0, 64, false, 30, 28, 0));
  Edges.add(new Edge(   0, 0, 96, false, 28, 32, 0));
  Edges.add(new Edge(   0, 0, 128, false, 28, 33, 0));
  Edges.add(new Edge(   0, 1, 0, false, 29, 33, 0));
  Edges.add(new Edge(   0, 1, 32, false, 29, 31, 0));
  Edges.add(new Edge(   0, 1, 64, false, 30, 31, 0));
  Edges.add(new Edge(   0, 1, 96, false, 30, 32, 0));
  Edges.add(new Edge(   0, 5, 102, false, 31, 32, 0));
  Edges.add(new Edge(   0, 1, 33, false, 32, 33, 0));
  Edges.add(new Edge(   0, 0, 33, true, 33, 31, 0));
  Edges.add(new Edge(   0, 5, 68, true, 31, 35, 0));
  Edges.add(new Edge(   0, 0, 0, true, 31, 36, 0));
  Edges.add(new Edge(   0, 1, 0, true, 32, 36, 0));
  Edges.add(new Edge(   0, 5, 0, false, 32, 34, 0));
  Edges.add(new Edge(   0, 0, 68, false, 33, 34, 0));
  Edges.add(new Edge(   0, 1, 68, false, 33, 35, 0));
  Edges.add(new Edge(   0, 5, 34, false, 34, 35, 0));
  Edges.add(new Edge(   0, 6, 133, true, 35, 36, 0));
  Edges.add(new Edge(   0, 7, 138, false, 36, 34, 0));
  Edges.add(new Edge(   0, 0, 102, false, 34, 38, 0));
  Edges.add(new Edge(   0, 1, 101, false, 35, 37, 0));
  Edges.add(new Edge(   0, 7, 103, true, 36, 37, 0));
  Edges.add(new Edge(   0, 6, 0, false, 36, 38, 0));
  Edges.add(new Edge(   0, 4, 101, false, 37, 38, 0));
  Edges.add(new Edge(   0, 4, 67, true, 37, 40, 0));
  Edges.add(new Edge(   0, 7, 67, true, 37, 41, 0));
  Edges.add(new Edge(   0, 6, 33, false, 38, 41, 0));
  Edges.add(new Edge(   0, 4, 0, false, 38, 39, 0));
  Edges.add(new Edge(   0, 7, 0, false, 36, 39, 0));
  Edges.add(new Edge(   0, 6, 100, true, 36, 40, 0));
  Edges.add(new Edge(   0, 4, 34, false, 39, 40, 0));
  Edges.add(new Edge(   0, 6, 66, true, 40, 41, 0));
  Edges.add(new Edge(   0, 7, 34, true, 41, 39, 0));
  // End of edge defines

  return Edges;
}

