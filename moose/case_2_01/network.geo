Merge "network.brep";

///////////////////////////////////
// Physical geometry definitions //
///////////////////////////////////

// -- Physical entity definitions
Physical Surface(33) = {51};
Physical Surface(19) = {49};
Physical Surface(11) = {48};
Physical Surface(16) = {47};
Physical Surface(13) = {46, 50};
Physical Surface(27) = {43, 45};
Physical Surface(7) = {41, 44};
Physical Surface(37) = {40};
Physical Surface(14) = {39};
Physical Surface(35) = {38};
Physical Surface(1) = {37};
Physical Surface(9) = {11, 52};
Physical Surface(38) = {14};
Physical Surface(22) = {10};
Physical Surface(28) = {13, 35};
Physical Surface(2) = {12, 23};
Physical Surface(31) = {18};
Physical Surface(15) = {9};
Physical Surface(8) = {8, 32};
Physical Surface(25) = {6, 17};
Physical Surface(4) = {7, 27};
Physical Surface(30) = {5};
Physical Surface(17) = {4, 36};
Physical Surface(10) = {2};
Physical Surface(39) = {20};
Physical Surface(18) = {3, 42};
Physical Surface(5) = {1};
Physical Surface(34) = {31};
Physical Surface(6) = {15};
Physical Surface(36) = {16};
Physical Surface(21) = {19};
Physical Surface(29) = {21, 26};
Physical Surface(23) = {22};
Physical Surface(20) = {24};
Physical Surface(3) = {25, 53};
Physical Surface(32) = {30};
Physical Surface(40) = {28};
Physical Surface(26) = {29};
Physical Surface(24) = {33};
Physical Surface(12) = {34};

// -- Physical entity intersection definitions
Physical Curve(17) = {43};
Physical Curve(1) = {17};
Physical Curve(25) = {93};
Physical Curve(27) = {109};
Physical Curve(21) = {73};
Physical Curve(39) = {188};
Physical Curve(8) = {26};
Physical Curve(24) = {88};
Physical Curve(5) = {8};
Physical Curve(38) = {177};
Physical Curve(37) = {154};
Physical Curve(34) = {162};
Physical Curve(19) = {63};
Physical Curve(30) = {121};
Physical Curve(35) = {157};
Physical Curve(6) = {7};
Physical Curve(9) = {34};
Physical Curve(10) = {33};
Physical Curve(23) = {82};
Physical Curve(16) = {53};
Physical Curve(3) = {19};
Physical Curve(32) = {140};
Physical Curve(12) = {40};
Physical Curve(41) = {255};
Physical Curve(33) = {163};
Physical Curve(4) = {18};
Physical Curve(20) = {74};
Physical Curve(31) = {128};
Physical Curve(2) = {16};
Physical Curve(28) = {108};
Physical Curve(29) = {115};
Physical Curve(18) = {64};
Physical Curve(14) = {54};
Physical Curve(40) = {194};
Physical Curve(11) = {27};
Physical Curve(13) = {55};
Physical Curve(26) = {101};
Physical Curve(7) = {22};
Physical Curve(36) = {153};
Physical Curve(22) = {72};
Physical Curve(15) = {48};

///////////////////////////
// Mesh size definitions //
///////////////////////////

// The order of definition is such that those geometries
// with the coarsest defined mesh sizes are placed first
// to ensure that for shared vertices the minimum mesh size is set

DefineConstant[ entityMeshSize_1 = 50 ];

// physical entity 16
Characteristic Length{ PointsOf{Surface{47};} } = entityMeshSize_1;
// physical entity 37
Characteristic Length{ PointsOf{Surface{40};} } = entityMeshSize_1;
// physical entity 8
Characteristic Length{ PointsOf{Surface{8, 32};} } = entityMeshSize_1;
// physical entity 11
Characteristic Length{ PointsOf{Surface{48};} } = entityMeshSize_1;
// physical entity 19
Characteristic Length{ PointsOf{Surface{49};} } = entityMeshSize_1;
// physical entity 7
Characteristic Length{ PointsOf{Surface{41, 44};} } = entityMeshSize_1;
// physical entity 33
Characteristic Length{ PointsOf{Surface{51};} } = entityMeshSize_1;
// physical entity 4
Characteristic Length{ PointsOf{Surface{7, 27};} } = entityMeshSize_1;
// physical entity 22
Characteristic Length{ PointsOf{Surface{10};} } = entityMeshSize_1;
// physical entity 34
Characteristic Length{ PointsOf{Surface{31};} } = entityMeshSize_1;
// physical entity 2
Characteristic Length{ PointsOf{Surface{12, 23};} } = entityMeshSize_1;
// physical entity 31
Characteristic Length{ PointsOf{Surface{18};} } = entityMeshSize_1;
// physical entity 15
Characteristic Length{ PointsOf{Surface{9};} } = entityMeshSize_1;
// physical entity 25
Characteristic Length{ PointsOf{Surface{6, 17};} } = entityMeshSize_1;
// physical entity 17
Characteristic Length{ PointsOf{Surface{4, 36};} } = entityMeshSize_1;
// physical entity 10
Characteristic Length{ PointsOf{Surface{2};} } = entityMeshSize_1;
// physical entity 39
Characteristic Length{ PointsOf{Surface{20};} } = entityMeshSize_1;
// physical entity 18
Characteristic Length{ PointsOf{Surface{3, 42};} } = entityMeshSize_1;
// physical entity 5
Characteristic Length{ PointsOf{Surface{1};} } = entityMeshSize_1;
// physical entity 28
Characteristic Length{ PointsOf{Surface{13, 35};} } = entityMeshSize_1;
// physical entity 12
Characteristic Length{ PointsOf{Surface{34};} } = entityMeshSize_1;
// physical entity 24
Characteristic Length{ PointsOf{Surface{33};} } = entityMeshSize_1;
// physical entity 26
Characteristic Length{ PointsOf{Surface{29};} } = entityMeshSize_1;
// physical entity 40
Characteristic Length{ PointsOf{Surface{28};} } = entityMeshSize_1;
// physical entity 32
Characteristic Length{ PointsOf{Surface{30};} } = entityMeshSize_1;
// physical entity 3
Characteristic Length{ PointsOf{Surface{25, 53};} } = entityMeshSize_1;
// physical entity 20
Characteristic Length{ PointsOf{Surface{24};} } = entityMeshSize_1;
// physical entity 23
Characteristic Length{ PointsOf{Surface{22};} } = entityMeshSize_1;
// physical entity 29
Characteristic Length{ PointsOf{Surface{21, 26};} } = entityMeshSize_1;
// physical entity 13
Characteristic Length{ PointsOf{Surface{46, 50};} } = entityMeshSize_1;
// physical entity 36
Characteristic Length{ PointsOf{Surface{16};} } = entityMeshSize_1;
// physical entity 38
Characteristic Length{ PointsOf{Surface{14};} } = entityMeshSize_1;
// physical entity 9
Characteristic Length{ PointsOf{Surface{11, 52};} } = entityMeshSize_1;
// physical entity 35
Characteristic Length{ PointsOf{Surface{38};} } = entityMeshSize_1;
// physical entity 6
Characteristic Length{ PointsOf{Surface{15};} } = entityMeshSize_1;
// physical entity 1
Characteristic Length{ PointsOf{Surface{37};} } = entityMeshSize_1;
// physical entity 30
Characteristic Length{ PointsOf{Surface{5};} } = entityMeshSize_1;
// physical entity 14
Characteristic Length{ PointsOf{Surface{39};} } = entityMeshSize_1;
// physical entity 27
Characteristic Length{ PointsOf{Surface{43, 45};} } = entityMeshSize_1;
// physical entity 21
Characteristic Length{ PointsOf{Surface{19};} } = entityMeshSize_1;

// INCLUDE INJECTOR/PRODUCER IN MESH
//+
Point(99998) = {100.0, 400.0, -2500.0, 10.0};
//+
Physical Point("injection_node", 99998) = {99998};
//+
Point(99999) = {700.0, 400.0, -2500.0, 10.0};
//+
Physical Point("production_node", 99999) = {99999};
// Add injector to surface
Point{99998} In Surface{37};
// Add producer to surface
Point{99999} In Surface{12};
// Add producer to surface
Point{99999} In Surface{23};
