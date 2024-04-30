Merge "network.brep";

///////////////////////////////////
// Physical geometry definitions //
///////////////////////////////////

// -- Physical entity definitions
Physical Surface(13) = {55};
Physical Surface(20) = {54};
Physical Surface(1) = {53};
Physical Surface(37) = {52};
Physical Surface(24) = {49};
Physical Surface(10) = {48};
Physical Surface(25) = {47};
Physical Surface(11) = {46};
Physical Surface(28) = {44};
Physical Surface(34) = {43, 50};
Physical Surface(16) = {42};
Physical Surface(19) = {9};
Physical Surface(6) = {8, 61};
Physical Surface(35) = {3};
Physical Surface(23) = {11, 38};
Physical Surface(36) = {7};
Physical Surface(7) = {18, 26, 57, 62};
Physical Surface(26) = {6, 59};
Physical Surface(3) = {5, 20, 39, 51};
Physical Surface(32) = {33};
Physical Surface(18) = {15};
Physical Surface(31) = {4, 45};
Physical Surface(2) = {2, 56};
Physical Surface(9) = {14, 32, 58};
Physical Surface(38) = {36};
Physical Surface(17) = {10, 12, 35, 37};
Physical Surface(4) = {1, 13, 17};
Physical Surface(33) = {30};
Physical Surface(21) = {16, 23};
Physical Surface(39) = {19};
Physical Surface(12) = {21, 40};
Physical Surface(14) = {22};
Physical Surface(27) = {24};
Physical Surface(22) = {25};
Physical Surface(5) = {27, 60};
Physical Surface(8) = {28};
Physical Surface(30) = {29};
Physical Surface(40) = {31};
Physical Surface(15) = {34};
Physical Surface(29) = {41};

// -- Physical entity intersection definitions
Physical Curve(16) = {61};
Physical Curve(40) = {127};
Physical Curve(46) = {214};
Physical Curve(35) = {106};
Physical Curve(30) = {94};
Physical Curve(15) = {47};
Physical Curve(42) = {183};
Physical Curve(24) = {75};
Physical Curve(36) = {114};
Physical Curve(28) = {84};
Physical Curve(33) = {116};
Physical Curve(17) = {60};
Physical Curve(39) = {123};
Physical Curve(31) = {97};
Physical Curve(4) = {15};
Physical Curve(44) = {194};
Physical Curve(5) = {27};
Physical Curve(3) = {3};
Physical Curve(2) = {6};
Physical Curve(41) = {174};
Physical Curve(12) = {37};
Physical Curve(19) = {55};
Physical Curve(8) = {28};
Physical Curve(37) = {115};
Physical Curve(34) = {103};
Physical Curve(9) = {26};
Physical Curve(38) = {117};
Physical Curve(14) = {46};
Physical Curve(43) = {195};
Physical Curve(27) = {86};
Physical Curve(11) = {38};
Physical Curve(18) = {48};
Physical Curve(47) = {256};
Physical Curve(25) = {85};
Physical Curve(6) = {21};
Physical Curve(45) = {200};
Physical Curve(22) = {63};
Physical Curve(32) = {96};
Physical Curve(13) = {39};
Physical Curve(29) = {95};
Physical Curve(26) = {80};
Physical Curve(7) = {29};
Physical Curve(23) = {73};
Physical Curve(20) = {67};
Physical Curve(10) = {16};
Physical Curve(1) = {7};
Physical Curve(21) = {65};

///////////////////////////
// Mesh size definitions //
///////////////////////////

// The order of definition is such that those geometries
// with the coarsest defined mesh sizes are placed first
// to ensure that for shared vertices the minimum mesh size is set

DefineConstant[ entityMeshSize_1 = 50 ];

// physical entity 24
Characteristic Length{ PointsOf{Surface{49};} } = entityMeshSize_1;
// physical entity 37
Characteristic Length{ PointsOf{Surface{52};} } = entityMeshSize_1;
// physical entity 1
Characteristic Length{ PointsOf{Surface{53};} } = entityMeshSize_1;
// physical entity 20
Characteristic Length{ PointsOf{Surface{54};} } = entityMeshSize_1;
// physical entity 13
Characteristic Length{ PointsOf{Surface{55};} } = entityMeshSize_1;
// physical entity 23
Characteristic Length{ PointsOf{Surface{11, 38};} } = entityMeshSize_1;
// physical entity 36
Characteristic Length{ PointsOf{Surface{7};} } = entityMeshSize_1;
// physical entity 7
Characteristic Length{ PointsOf{Surface{18, 26, 57, 62};} } = entityMeshSize_1;
// physical entity 26
Characteristic Length{ PointsOf{Surface{6, 59};} } = entityMeshSize_1;
// physical entity 21
Characteristic Length{ PointsOf{Surface{16, 23};} } = entityMeshSize_1;
// physical entity 32
Characteristic Length{ PointsOf{Surface{33};} } = entityMeshSize_1;
// physical entity 18
Characteristic Length{ PointsOf{Surface{15};} } = entityMeshSize_1;
// physical entity 31
Characteristic Length{ PointsOf{Surface{4, 45};} } = entityMeshSize_1;
// physical entity 2
Characteristic Length{ PointsOf{Surface{2, 56};} } = entityMeshSize_1;
// physical entity 9
Characteristic Length{ PointsOf{Surface{14, 32, 58};} } = entityMeshSize_1;
// physical entity 38
Characteristic Length{ PointsOf{Surface{36};} } = entityMeshSize_1;
// physical entity 17
Characteristic Length{ PointsOf{Surface{10, 12, 35, 37};} } = entityMeshSize_1;
// physical entity 4
Characteristic Length{ PointsOf{Surface{1, 13, 17};} } = entityMeshSize_1;
// physical entity 33
Characteristic Length{ PointsOf{Surface{30};} } = entityMeshSize_1;
// physical entity 3
Characteristic Length{ PointsOf{Surface{5, 20, 39, 51};} } = entityMeshSize_1;
// physical entity 29
Characteristic Length{ PointsOf{Surface{41};} } = entityMeshSize_1;
// physical entity 15
Characteristic Length{ PointsOf{Surface{34};} } = entityMeshSize_1;
// physical entity 40
Characteristic Length{ PointsOf{Surface{31};} } = entityMeshSize_1;
// physical entity 30
Characteristic Length{ PointsOf{Surface{29};} } = entityMeshSize_1;
// physical entity 8
Characteristic Length{ PointsOf{Surface{28};} } = entityMeshSize_1;
// physical entity 5
Characteristic Length{ PointsOf{Surface{27, 60};} } = entityMeshSize_1;
// physical entity 22
Characteristic Length{ PointsOf{Surface{25};} } = entityMeshSize_1;
// physical entity 27
Characteristic Length{ PointsOf{Surface{24};} } = entityMeshSize_1;
// physical entity 14
Characteristic Length{ PointsOf{Surface{22};} } = entityMeshSize_1;
// physical entity 11
Characteristic Length{ PointsOf{Surface{46};} } = entityMeshSize_1;
// physical entity 39
Characteristic Length{ PointsOf{Surface{19};} } = entityMeshSize_1;
// physical entity 6
Characteristic Length{ PointsOf{Surface{8, 61};} } = entityMeshSize_1;
// physical entity 35
Characteristic Length{ PointsOf{Surface{3};} } = entityMeshSize_1;
// physical entity 19
Characteristic Length{ PointsOf{Surface{9};} } = entityMeshSize_1;
// physical entity 16
Characteristic Length{ PointsOf{Surface{42};} } = entityMeshSize_1;
// physical entity 34
Characteristic Length{ PointsOf{Surface{43, 50};} } = entityMeshSize_1;
// physical entity 28
Characteristic Length{ PointsOf{Surface{44};} } = entityMeshSize_1;
// physical entity 25
Characteristic Length{ PointsOf{Surface{47};} } = entityMeshSize_1;
// physical entity 10
Characteristic Length{ PointsOf{Surface{48};} } = entityMeshSize_1;
// physical entity 12
Characteristic Length{ PointsOf{Surface{21, 40};} } = entityMeshSize_1;

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
Point{99998} In Surface{53};
// Add producer to surface
Point{99999} In Surface{2};
// Add producer to surface
Point{99999} In Surface{56};
