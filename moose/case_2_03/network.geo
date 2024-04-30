Merge "network.brep";

///////////////////////////////////
// Physical geometry definitions //
///////////////////////////////////

// -- Physical entity definitions
Physical Surface(39) = {69};
Physical Surface(40) = {66, 67};
Physical Surface(15) = {64};
Physical Surface(29) = {63};
Physical Surface(27) = {60, 71};
Physical Surface(28) = {59};
Physical Surface(13) = {58};
Physical Surface(9) = {53};
Physical Surface(31) = {52};
Physical Surface(34) = {51};
Physical Surface(26) = {50};
Physical Surface(37) = {15};
Physical Surface(8) = {5, 48, 61};
Physical Surface(1) = {14};
Physical Surface(30) = {3};
Physical Surface(33) = {13, 17};
Physical Surface(4) = {31};
Physical Surface(10) = {12, 24};
Physical Surface(36) = {10, 38};
Physical Surface(7) = {35, 68};
Physical Surface(25) = {7, 8, 43, 65};
Physical Surface(12) = {4, 36, 39, 70};
Physical Surface(17) = {16, 18, 20, 44, 57};
Physical Surface(19) = {11, 54};
Physical Surface(6) = {2, 9, 21, 23, 30, 72};
Physical Surface(35) = {49};
Physical Surface(18) = {1, 6};
Physical Surface(22) = {19};
Physical Surface(21) = {22, 40};
Physical Surface(3) = {25, 62};
Physical Surface(32) = {32};
Physical Surface(14) = {26, 41, 45};
Physical Surface(11) = {27};
Physical Surface(24) = {28, 33};
Physical Surface(5) = {29};
Physical Surface(38) = {34};
Physical Surface(16) = {37};
Physical Surface(23) = {42, 73};
Physical Surface(20) = {46, 55};
Physical Surface(2) = {47, 56};

// -- Physical entity intersection definitions
Physical Curve(24) = {68};
Physical Curve(38) = {122};
Physical Curve(49) = {168};
Physical Curve(8) = {19};
Physical Curve(32) = {97};
Physical Curve(50) = {180};
Physical Curve(51) = {179};
Physical Curve(55) = {182};
Physical Curve(39) = {120};
Physical Curve(40) = {112};
Physical Curve(41) = {130};
Physical Curve(57) = {207};
Physical Curve(74) = {332};
Physical Curve(4) = {10};
Physical Curve(15) = {41};
Physical Curve(43) = {139};
Physical Curve(5) = {20};
Physical Curve(64) = {247};
Physical Curve(28) = {79};
Physical Curve(71) = {308};
Physical Curve(12) = {34};
Physical Curve(13) = {37};
Physical Curve(72) = {307};
Physical Curve(37) = {121};
Physical Curve(68) = {264};
Physical Curve(9) = {27};
Physical Curve(21) = {60};
Physical Curve(53) = {177};
Physical Curve(61) = {252};
Physical Curve(2) = {6};
Physical Curve(3) = {7};
Physical Curve(62) = {238};
Physical Curve(30) = {98};
Physical Curve(1) = {1};
Physical Curve(60) = {226};
Physical Curve(16) = {42};
Physical Curve(75) = {350};
Physical Curve(45) = {150};
Physical Curve(19) = {55};
Physical Curve(6) = {21};
Physical Curve(65) = {237};
Physical Curve(54) = {181};
Physical Curve(20) = {56};
Physical Curve(33) = {96};
Physical Curve(46) = {156};
Physical Curve(17) = {47};
Physical Curve(23) = {76};
Physical Curve(52) = {178};
Physical Curve(70) = {306};
Physical Curve(11) = {36};
Physical Curve(47) = {155};
Physical Curve(18) = {51};
Physical Curve(63) = {246};
Physical Curve(35) = {119};
Physical Curve(22) = {77};
Physical Curve(42) = {129};
Physical Curve(67) = {255};
Physical Curve(29) = {88};
Physical Curve(34) = {105};
Physical Curve(26) = {86};
Physical Curve(48) = {162};
Physical Curve(73) = {309};
Physical Curve(14) = {45};
Physical Curve(69) = {265};
Physical Curve(10) = {22};
Physical Curve(59) = {216};
Physical Curve(31) = {99};
Physical Curve(44) = {146};
Physical Curve(25) = {69};
Physical Curve(27) = {87};
Physical Curve(56) = {196};
Physical Curve(7) = {18};
Physical Curve(66) = {228};
Physical Curve(58) = {204};
Physical Curve(36) = {108};

///////////////////////////
// Mesh size definitions //
///////////////////////////

// The order of definition is such that those geometries
// with the coarsest defined mesh sizes are placed first
// to ensure that for shared vertices the minimum mesh size is set

DefineConstant[ entityMeshSize_1 = 50 ];

// physical entity 40
Characteristic Length{ PointsOf{Surface{66, 67};} } = entityMeshSize_1;
// physical entity 26
Characteristic Length{ PointsOf{Surface{50};} } = entityMeshSize_1;
// physical entity 13
Characteristic Length{ PointsOf{Surface{58};} } = entityMeshSize_1;
// physical entity 39
Characteristic Length{ PointsOf{Surface{69};} } = entityMeshSize_1;
// physical entity 10
Characteristic Length{ PointsOf{Surface{12, 24};} } = entityMeshSize_1;
// physical entity 1
Characteristic Length{ PointsOf{Surface{14};} } = entityMeshSize_1;
// physical entity 30
Characteristic Length{ PointsOf{Surface{3};} } = entityMeshSize_1;
// physical entity 33
Characteristic Length{ PointsOf{Surface{13, 17};} } = entityMeshSize_1;
// physical entity 4
Characteristic Length{ PointsOf{Surface{31};} } = entityMeshSize_1;
// physical entity 21
Characteristic Length{ PointsOf{Surface{22, 40};} } = entityMeshSize_1;
// physical entity 7
Characteristic Length{ PointsOf{Surface{35, 68};} } = entityMeshSize_1;
// physical entity 25
Characteristic Length{ PointsOf{Surface{7, 8, 43, 65};} } = entityMeshSize_1;
// physical entity 12
Characteristic Length{ PointsOf{Surface{4, 36, 39, 70};} } = entityMeshSize_1;
// physical entity 17
Characteristic Length{ PointsOf{Surface{16, 18, 20, 44, 57};} } = entityMeshSize_1;
// physical entity 19
Characteristic Length{ PointsOf{Surface{11, 54};} } = entityMeshSize_1;
// physical entity 6
Characteristic Length{ PointsOf{Surface{2, 9, 21, 23, 30, 72};} } = entityMeshSize_1;
// physical entity 35
Characteristic Length{ PointsOf{Surface{49};} } = entityMeshSize_1;
// physical entity 18
Characteristic Length{ PointsOf{Surface{1, 6};} } = entityMeshSize_1;
// physical entity 22
Characteristic Length{ PointsOf{Surface{19};} } = entityMeshSize_1;
// physical entity 36
Characteristic Length{ PointsOf{Surface{10, 38};} } = entityMeshSize_1;
// physical entity 2
Characteristic Length{ PointsOf{Surface{47, 56};} } = entityMeshSize_1;
// physical entity 20
Characteristic Length{ PointsOf{Surface{46, 55};} } = entityMeshSize_1;
// physical entity 23
Characteristic Length{ PointsOf{Surface{42, 73};} } = entityMeshSize_1;
// physical entity 16
Characteristic Length{ PointsOf{Surface{37};} } = entityMeshSize_1;
// physical entity 38
Characteristic Length{ PointsOf{Surface{34};} } = entityMeshSize_1;
// physical entity 5
Characteristic Length{ PointsOf{Surface{29};} } = entityMeshSize_1;
// physical entity 24
Characteristic Length{ PointsOf{Surface{28, 33};} } = entityMeshSize_1;
// physical entity 11
Characteristic Length{ PointsOf{Surface{27};} } = entityMeshSize_1;
// physical entity 14
Characteristic Length{ PointsOf{Surface{26, 41, 45};} } = entityMeshSize_1;
// physical entity 27
Characteristic Length{ PointsOf{Surface{60, 71};} } = entityMeshSize_1;
// physical entity 3
Characteristic Length{ PointsOf{Surface{25, 62};} } = entityMeshSize_1;
// physical entity 37
Characteristic Length{ PointsOf{Surface{15};} } = entityMeshSize_1;
// physical entity 8
Characteristic Length{ PointsOf{Surface{5, 48, 61};} } = entityMeshSize_1;
// physical entity 34
Characteristic Length{ PointsOf{Surface{51};} } = entityMeshSize_1;
// physical entity 31
Characteristic Length{ PointsOf{Surface{52};} } = entityMeshSize_1;
// physical entity 9
Characteristic Length{ PointsOf{Surface{53};} } = entityMeshSize_1;
// physical entity 29
Characteristic Length{ PointsOf{Surface{63};} } = entityMeshSize_1;
// physical entity 28
Characteristic Length{ PointsOf{Surface{59};} } = entityMeshSize_1;
// physical entity 15
Characteristic Length{ PointsOf{Surface{64};} } = entityMeshSize_1;
// physical entity 32
Characteristic Length{ PointsOf{Surface{32};} } = entityMeshSize_1;

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
Point{99998} In Surface{14};
// Add producer to surface
Point{99999} In Surface{47};
// Add producer to surface
Point{99999} In Surface{56};
