Merge "network.brep";

///////////////////////////////////
// Physical geometry definitions //
///////////////////////////////////

// -- Physical entity definitions
Physical Surface(33) = {89, 93};
Physical Surface(34) = {86};
Physical Surface(1) = {75};
Physical Surface(39) = {74};
Physical Surface(15) = {68};
Physical Surface(2) = {62};
Physical Surface(19) = {58, 92};
Physical Surface(38) = {56, 80};
Physical Surface(25) = {54};
Physical Surface(17) = {52};
Physical Surface(31) = {50};
Physical Surface(40) = {18, 83};
Physical Surface(11) = {35};
Physical Surface(6) = {16, 47};
Physical Surface(35) = {13, 88};
Physical Surface(5) = {15, 82, 85};
Physical Surface(24) = {9, 19, 33, 39, 64, 72, 81};
Physical Surface(23) = {11, 29, 67};
Physical Surface(36) = {10, 63, 78};
Physical Surface(7) = {1, 4};
Physical Surface(10) = {8, 12, 84, 94};
Physical Surface(4) = {7, 41};
Physical Surface(29) = {3, 17, 26, 66};
Physical Surface(21) = {5, 48, 49, 51};
Physical Surface(8) = {2, 6, 14, 22, 31, 44, 57, 59, 60, 70, 71};
Physical Surface(37) = {20};
Physical Surface(26) = {21};
Physical Surface(22) = {23, 55};
Physical Surface(13) = {24, 69};
Physical Surface(9) = {25};
Physical Surface(28) = {27};
Physical Surface(16) = {28, 32, 38, 43, 61, 65, 77, 79};
Physical Surface(12) = {30, 53};
Physical Surface(18) = {34};
Physical Surface(20) = {36};
Physical Surface(27) = {37, 73, 87};
Physical Surface(3) = {40, 76, 90, 91};
Physical Surface(32) = {46};
Physical Surface(30) = {42};
Physical Surface(14) = {45};

// -- Physical entity intersection definitions
Physical Curve(94) = {284};
Physical Curve(86) = {248};
Physical Curve(30) = {80};
Physical Curve(54) = {157};
Physical Curve(42) = {110};
Physical Curve(92) = {256};
Physical Curve(50) = {149};
Physical Curve(71) = {194};
Physical Curve(91) = {264};
Physical Curve(7) = {20};
Physical Curve(8) = {26};
Physical Curve(33) = {86};
Physical Curve(81) = {238};
Physical Curve(15) = {52};
Physical Curve(65) = {175};
Physical Curve(77) = {226};
Physical Curve(18) = {39};
Physical Curve(66) = {191};
Physical Curve(12) = {29};
Physical Curve(110) = {385};
Physical Curve(63) = {207};
Physical Curve(40) = {113};
Physical Curve(78) = {232};
Physical Curve(62) = {198};
Physical Curve(41) = {114};
Physical Curve(2) = {11};
Physical Curve(87) = {250};
Physical Curve(13) = {47};
Physical Curve(14) = {53};
Physical Curve(19) = {36};
Physical Curve(43) = {126};
Physical Curve(70) = {196};
Physical Curve(60) = {174};
Physical Curve(107) = {368};
Physical Curve(98) = {317};
Physical Curve(22) = {63};
Physical Curve(20) = {38};
Physical Curve(4) = {5};
Physical Curve(108) = {384};
Physical Curve(90) = {263};
Physical Curve(73) = {192};
Physical Curve(84) = {249};
Physical Curve(9) = {24};
Physical Curve(79) = {231};
Physical Curve(55) = {142};
Physical Curve(95) = {307};
Physical Curve(85) = {239};
Physical Curve(88) = {262};
Physical Curve(64) = {199};
Physical Curve(101) = {325};
Physical Curve(52) = {155};
Physical Curve(76) = {220};
Physical Curve(105) = {344};
Physical Curve(25) = {70};
Physical Curve(5) = {19};
Physical Curve(16) = {51};
Physical Curve(29) = {74};
Physical Curve(74) = {215};
Physical Curve(83) = {243};
Physical Curve(26) = {62};
Physical Curve(27) = {57};
Physical Curve(24) = {66};
Physical Curve(82) = {234};
Physical Curve(23) = {69};
Physical Curve(103) = {346};
Physical Curve(44) = {127};
Physical Curve(1) = {3};
Physical Curve(117) = {440};
Physical Curve(58) = {160};
Physical Curve(72) = {193};
Physical Curve(106) = {357};
Physical Curve(47) = {135};
Physical Curve(112) = {386};
Physical Curve(53) = {156};
Physical Curve(3) = {14};
Physical Curve(97) = {318};
Physical Curve(38) = {102};
Physical Curve(39) = {116};
Physical Curve(34) = {94};
Physical Curve(93) = {278};
Physical Curve(21) = {55};
Physical Curve(80) = {233};
Physical Curve(17) = {43};
Physical Curve(69) = {195};
Physical Curve(10) = {33};
Physical Curve(96) = {294};
Physical Curve(37) = {101};
Physical Curve(102) = {353};
Physical Curve(57) = {171};
Physical Curve(116) = {424};
Physical Curve(28) = {71};
Physical Curve(100) = {331};
Physical Curve(118) = {483};
Physical Curve(59) = {170};
Physical Curve(31) = {78};
Physical Curve(89) = {268};
Physical Curve(51) = {158};
Physical Curve(36) = {104};
Physical Curve(115) = {402};
Physical Curve(56) = {173};
Physical Curve(45) = {125};
Physical Curve(104) = {345};
Physical Curve(114) = {412};
Physical Curve(11) = {31};
Physical Curve(48) = {134};
Physical Curve(68) = {197};
Physical Curve(35) = {93};
Physical Curve(46) = {137};
Physical Curve(109) = {387};
Physical Curve(99) = {334};
Physical Curve(6) = {22};
Physical Curve(75) = {214};
Physical Curve(111) = {383};
Physical Curve(67) = {190};
Physical Curve(113) = {413};
Physical Curve(32) = {83};
Physical Curve(49) = {140};
Physical Curve(61) = {172};

///////////////////////////
// Mesh size definitions //
///////////////////////////

// The order of definition is such that those geometries
// with the coarsest defined mesh sizes are placed first
// to ensure that for shared vertices the minimum mesh size is set

DefineConstant[ entityMeshSize_1 = 50 ];

// physical entity 39
Characteristic Length{ PointsOf{Surface{74};} } = entityMeshSize_1;
// physical entity 10
Characteristic Length{ PointsOf{Surface{8, 12, 84, 94};} } = entityMeshSize_1;
// physical entity 1
Characteristic Length{ PointsOf{Surface{75};} } = entityMeshSize_1;
// physical entity 34
Characteristic Length{ PointsOf{Surface{86};} } = entityMeshSize_1;
// physical entity 5
Characteristic Length{ PointsOf{Surface{15, 82, 85};} } = entityMeshSize_1;
// physical entity 33
Characteristic Length{ PointsOf{Surface{89, 93};} } = entityMeshSize_1;
// physical entity 4
Characteristic Length{ PointsOf{Surface{7, 41};} } = entityMeshSize_1;
// physical entity 6
Characteristic Length{ PointsOf{Surface{16, 47};} } = entityMeshSize_1;
// physical entity 35
Characteristic Length{ PointsOf{Surface{13, 88};} } = entityMeshSize_1;
// physical entity 13
Characteristic Length{ PointsOf{Surface{24, 69};} } = entityMeshSize_1;
// physical entity 23
Characteristic Length{ PointsOf{Surface{11, 29, 67};} } = entityMeshSize_1;
// physical entity 36
Characteristic Length{ PointsOf{Surface{10, 63, 78};} } = entityMeshSize_1;
// physical entity 7
Characteristic Length{ PointsOf{Surface{1, 4};} } = entityMeshSize_1;
// physical entity 29
Characteristic Length{ PointsOf{Surface{3, 17, 26, 66};} } = entityMeshSize_1;
// physical entity 21
Characteristic Length{ PointsOf{Surface{5, 48, 49, 51};} } = entityMeshSize_1;
// physical entity 8
Characteristic Length{ PointsOf{Surface{2, 6, 14, 22, 31, 44, 57, 59, 60, 70, 71};} } = entityMeshSize_1;
// physical entity 37
Characteristic Length{ PointsOf{Surface{20};} } = entityMeshSize_1;
// physical entity 26
Characteristic Length{ PointsOf{Surface{21};} } = entityMeshSize_1;
// physical entity 22
Characteristic Length{ PointsOf{Surface{23, 55};} } = entityMeshSize_1;
// physical entity 24
Characteristic Length{ PointsOf{Surface{9, 19, 33, 39, 64, 72, 81};} } = entityMeshSize_1;
// physical entity 14
Characteristic Length{ PointsOf{Surface{45};} } = entityMeshSize_1;
// physical entity 30
Characteristic Length{ PointsOf{Surface{42};} } = entityMeshSize_1;
// physical entity 32
Characteristic Length{ PointsOf{Surface{46};} } = entityMeshSize_1;
// physical entity 3
Characteristic Length{ PointsOf{Surface{40, 76, 90, 91};} } = entityMeshSize_1;
// physical entity 27
Characteristic Length{ PointsOf{Surface{37, 73, 87};} } = entityMeshSize_1;
// physical entity 20
Characteristic Length{ PointsOf{Surface{36};} } = entityMeshSize_1;
// physical entity 18
Characteristic Length{ PointsOf{Surface{34};} } = entityMeshSize_1;
// physical entity 12
Characteristic Length{ PointsOf{Surface{30, 53};} } = entityMeshSize_1;
// physical entity 16
Characteristic Length{ PointsOf{Surface{28, 32, 38, 43, 61, 65, 77, 79};} } = entityMeshSize_1;
// physical entity 15
Characteristic Length{ PointsOf{Surface{68};} } = entityMeshSize_1;
// physical entity 9
Characteristic Length{ PointsOf{Surface{25};} } = entityMeshSize_1;
// physical entity 11
Characteristic Length{ PointsOf{Surface{35};} } = entityMeshSize_1;
// physical entity 40
Characteristic Length{ PointsOf{Surface{18, 83};} } = entityMeshSize_1;
// physical entity 31
Characteristic Length{ PointsOf{Surface{50};} } = entityMeshSize_1;
// physical entity 2
Characteristic Length{ PointsOf{Surface{62};} } = entityMeshSize_1;
// physical entity 17
Characteristic Length{ PointsOf{Surface{52};} } = entityMeshSize_1;
// physical entity 25
Characteristic Length{ PointsOf{Surface{54};} } = entityMeshSize_1;
// physical entity 38
Characteristic Length{ PointsOf{Surface{56, 80};} } = entityMeshSize_1;
// physical entity 19
Characteristic Length{ PointsOf{Surface{58, 92};} } = entityMeshSize_1;
// physical entity 28
Characteristic Length{ PointsOf{Surface{27};} } = entityMeshSize_1;

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
Point{99998} In Surface{75};
// Add producer to surface
Point{99999} In Surface{62};
