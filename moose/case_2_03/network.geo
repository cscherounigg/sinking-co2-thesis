Merge "network.brep";

///////////////////////////////////
// Physical geometry definitions //
///////////////////////////////////

// -- Physical entity definitions
Physical Surface(27) = {78};
Physical Surface(28) = {70};
Physical Surface(12) = {68};
Physical Surface(9) = {63, 64, 79};
Physical Surface(36) = {62, 72};
Physical Surface(6) = {61};
Physical Surface(26) = {57};
Physical Surface(33) = {55};
Physical Surface(40) = {51, 73};
Physical Surface(37) = {47, 54};
Physical Surface(1) = {46};
Physical Surface(13) = {13};
Physical Surface(5) = {15, 26};
Physical Surface(34) = {28};
Physical Surface(31) = {12, 30, 35, 52, 53, 60, 71, 74};
Physical Surface(2) = {8, 66};
Physical Surface(11) = {9, 16};
Physical Surface(15) = {17, 24, 42};
Physical Surface(3) = {6, 29};
Physical Surface(32) = {36};
Physical Surface(21) = {4, 43, 56, 58};
Physical Surface(4) = {3, 14, 22, 69};
Physical Surface(7) = {7, 11, 31, 34, 59};
Physical Surface(20) = {2};
Physical Surface(25) = {5};
Physical Surface(38) = {1, 10};
Physical Surface(10) = {18};
Physical Surface(39) = {20, 65};
Physical Surface(16) = {19, 44, 45, 48, 67, 75, 77, 80};
Physical Surface(23) = {21, 76};
Physical Surface(30) = {23};
Physical Surface(19) = {25};
Physical Surface(35) = {27};
Physical Surface(8) = {32, 49, 50};
Physical Surface(18) = {33};
Physical Surface(17) = {37};
Physical Surface(14) = {38};
Physical Surface(22) = {39};
Physical Surface(29) = {40};
Physical Surface(24) = {41};

// -- Physical entity intersection definitions
Physical Curve(19) = {62};
Physical Curve(14) = {37};
Physical Curve(63) = {202};
Physical Curve(28) = {76};
Physical Curve(42) = {111};
Physical Curve(86) = {327};
Physical Curve(31) = {97};
Physical Curve(89) = {338};
Physical Curve(53) = {153};
Physical Curve(9) = {25};
Physical Curve(24) = {78};
Physical Curve(32) = {99};
Physical Curve(38) = {124};
Physical Curve(39) = {116};
Physical Curve(90) = {339};
Physical Curve(95) = {387};
Physical Curve(48) = {131};
Physical Curve(18) = {60};
Physical Curve(64) = {203};
Physical Curve(11) = {30};
Physical Curve(13) = {34};
Physical Curve(82) = {291};
Physical Curve(15) = {45};
Physical Curve(80) = {260};
Physical Curve(2) = {11};
Physical Curve(23) = {59};
Physical Curve(56) = {163};
Physical Curve(20) = {46};
Physical Curve(1) = {1};
Physical Curve(73) = {238};
Physical Curve(83) = {295};
Physical Curve(10) = {32};
Physical Curve(54) = {162};
Physical Curve(52) = {154};
Physical Curve(84) = {306};
Physical Curve(43) = {110};
Physical Curve(76) = {274};
Physical Curve(71) = {225};
Physical Curve(12) = {26};
Physical Curve(88) = {325};
Physical Curve(29) = {81};
Physical Curve(59) = {175};
Physical Curve(7) = {12};
Physical Curve(66) = {204};
Physical Curve(94) = {359};
Physical Curve(35) = {126};
Physical Curve(47) = {134};
Physical Curve(77) = {273};
Physical Curve(49) = {136};
Physical Curve(81) = {278};
Physical Curve(22) = {58};
Physical Curve(87) = {324};
Physical Curve(58) = {174};
Physical Curve(41) = {112};
Physical Curve(93) = {360};
Physical Curve(34) = {87};
Physical Curve(68) = {206};
Physical Curve(61) = {191};
Physical Curve(3) = {10};
Physical Curve(62) = {192};
Physical Curve(40) = {114};
Physical Curve(5) = {18};
Physical Curve(92) = {358};
Physical Curve(33) = {96};
Physical Curve(8) = {14};
Physical Curve(67) = {208};
Physical Curve(91) = {348};
Physical Curve(4) = {9};
Physical Curve(25) = {79};
Physical Curve(96) = {420};
Physical Curve(37) = {119};
Physical Curve(70) = {219};
Physical Curve(45) = {100};
Physical Curve(78) = {267};
Physical Curve(65) = {201};
Physical Curve(6) = {16};
Physical Curve(46) = {135};
Physical Curve(17) = {49};
Physical Curve(69) = {220};
Physical Curve(60) = {190};
Physical Curve(57) = {176};
Physical Curve(26) = {77};
Physical Curve(85) = {326};
Physical Curve(50) = {145};
Physical Curve(72) = {229};
Physical Curve(44) = {102};
Physical Curve(51) = {144};
Physical Curve(79) = {259};
Physical Curve(27) = {80};
Physical Curve(74) = {237};
Physical Curve(55) = {161};
Physical Curve(36) = {125};
Physical Curve(21) = {61};
Physical Curve(75) = {266};
Physical Curve(16) = {65};
Physical Curve(30) = {98};

///////////////////////////
// Mesh size definitions //
///////////////////////////

// The order of definition is such that those geometries
// with the coarsest defined mesh sizes are placed first
// to ensure that for shared vertices the minimum mesh size is set

DefineConstant[ entityMeshSize_1 = 50 ];

// physical entity 7
Characteristic Length{ PointsOf{Surface{7, 11, 31, 34, 59};} } = entityMeshSize_1;
// physical entity 9
Characteristic Length{ PointsOf{Surface{63, 64, 79};} } = entityMeshSize_1;
// physical entity 38
Characteristic Length{ PointsOf{Surface{1, 10};} } = entityMeshSize_1;
// physical entity 12
Characteristic Length{ PointsOf{Surface{68};} } = entityMeshSize_1;
// physical entity 28
Characteristic Length{ PointsOf{Surface{70};} } = entityMeshSize_1;
// physical entity 1
Characteristic Length{ PointsOf{Surface{46};} } = entityMeshSize_1;
// physical entity 40
Characteristic Length{ PointsOf{Surface{51, 73};} } = entityMeshSize_1;
// physical entity 11
Characteristic Length{ PointsOf{Surface{9, 16};} } = entityMeshSize_1;
// physical entity 27
Characteristic Length{ PointsOf{Surface{78};} } = entityMeshSize_1;
// physical entity 16
Characteristic Length{ PointsOf{Surface{19, 44, 45, 48, 67, 75, 77, 80};} } = entityMeshSize_1;
// physical entity 2
Characteristic Length{ PointsOf{Surface{8, 66};} } = entityMeshSize_1;
// physical entity 15
Characteristic Length{ PointsOf{Surface{17, 24, 42};} } = entityMeshSize_1;
// physical entity 3
Characteristic Length{ PointsOf{Surface{6, 29};} } = entityMeshSize_1;
// physical entity 32
Characteristic Length{ PointsOf{Surface{36};} } = entityMeshSize_1;
// physical entity 21
Characteristic Length{ PointsOf{Surface{4, 43, 56, 58};} } = entityMeshSize_1;
// physical entity 20
Characteristic Length{ PointsOf{Surface{2};} } = entityMeshSize_1;
// physical entity 25
Characteristic Length{ PointsOf{Surface{5};} } = entityMeshSize_1;
// physical entity 10
Characteristic Length{ PointsOf{Surface{18};} } = entityMeshSize_1;
// physical entity 39
Characteristic Length{ PointsOf{Surface{20, 65};} } = entityMeshSize_1;
// physical entity 31
Characteristic Length{ PointsOf{Surface{12, 30, 35, 52, 53, 60, 71, 74};} } = entityMeshSize_1;
// physical entity 24
Characteristic Length{ PointsOf{Surface{41};} } = entityMeshSize_1;
// physical entity 29
Characteristic Length{ PointsOf{Surface{40};} } = entityMeshSize_1;
// physical entity 22
Characteristic Length{ PointsOf{Surface{39};} } = entityMeshSize_1;
// physical entity 14
Characteristic Length{ PointsOf{Surface{38};} } = entityMeshSize_1;
// physical entity 17
Characteristic Length{ PointsOf{Surface{37};} } = entityMeshSize_1;
// physical entity 18
Characteristic Length{ PointsOf{Surface{33};} } = entityMeshSize_1;
// physical entity 8
Characteristic Length{ PointsOf{Surface{32, 49, 50};} } = entityMeshSize_1;
// physical entity 35
Characteristic Length{ PointsOf{Surface{27};} } = entityMeshSize_1;
// physical entity 19
Characteristic Length{ PointsOf{Surface{25};} } = entityMeshSize_1;
// physical entity 36
Characteristic Length{ PointsOf{Surface{62, 72};} } = entityMeshSize_1;
// physical entity 23
Characteristic Length{ PointsOf{Surface{21, 76};} } = entityMeshSize_1;
// physical entity 5
Characteristic Length{ PointsOf{Surface{15, 26};} } = entityMeshSize_1;
// physical entity 34
Characteristic Length{ PointsOf{Surface{28};} } = entityMeshSize_1;
// physical entity 37
Characteristic Length{ PointsOf{Surface{47, 54};} } = entityMeshSize_1;
// physical entity 33
Characteristic Length{ PointsOf{Surface{55};} } = entityMeshSize_1;
// physical entity 4
Characteristic Length{ PointsOf{Surface{3, 14, 22, 69};} } = entityMeshSize_1;
// physical entity 13
Characteristic Length{ PointsOf{Surface{13};} } = entityMeshSize_1;
// physical entity 26
Characteristic Length{ PointsOf{Surface{57};} } = entityMeshSize_1;
// physical entity 6
Characteristic Length{ PointsOf{Surface{61};} } = entityMeshSize_1;
// physical entity 30
Characteristic Length{ PointsOf{Surface{23};} } = entityMeshSize_1;

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
Point{99998} In Surface{46};
// Add producer to surface
Point{99999} In Surface{8};
// Add producer to surface
Point{99999} In Surface{66};
