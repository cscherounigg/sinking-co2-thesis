Merge "network.brep";

///////////////////////////////////
// Physical geometry definitions //
///////////////////////////////////

// -- Physical entity definitions
Physical Surface(4) = {98};
Physical Surface(11) = {97};
Physical Surface(35) = {92};
Physical Surface(1) = {91};
Physical Surface(21) = {88};
Physical Surface(7) = {82};
Physical Surface(2) = {80};
Physical Surface(27) = {76};
Physical Surface(19) = {71};
Physical Surface(8) = {65};
Physical Surface(23) = {63};
Physical Surface(3) = {13, 20, 53, 66, 73, 78, 81, 84, 85};
Physical Surface(32) = {33};
Physical Surface(33) = {12, 18};
Physical Surface(9) = {11};
Physical Surface(38) = {2, 43, 77};
Physical Surface(36) = {10};
Physical Surface(37) = {7, 19, 95};
Physical Surface(14) = {15};
Physical Surface(40) = {5};
Physical Surface(17) = {9, 23, 25, 27, 30, 31, 37, 38, 45, 47, 50, 67, 70, 72, 86, 96};
Physical Surface(30) = {4};
Physical Surface(34) = {3, 89};
Physical Surface(5) = {52};
Physical Surface(31) = {6, 8, 14, 16, 21, 29, 36, 42, 44, 54, 58, 75, 79, 93, 94};
Physical Surface(18) = {1};
Physical Surface(6) = {17, 69};
Physical Surface(12) = {22};
Physical Surface(15) = {24, 49, 59};
Physical Surface(28) = {26};
Physical Surface(13) = {28, 48, 51, 57, 61, 68, 74, 90};
Physical Surface(39) = {32, 56};
Physical Surface(10) = {60};
Physical Surface(29) = {34, 87};
Physical Surface(16) = {35, 41, 64};
Physical Surface(22) = {39};
Physical Surface(26) = {40, 83};
Physical Surface(24) = {46};
Physical Surface(25) = {55};
Physical Surface(20) = {62};

// -- Physical entity intersection definitions
Physical Curve(17) = {43};
Physical Curve(74) = {199};
Physical Curve(71) = {202};
Physical Curve(78) = {224};
Physical Curve(95) = {297};
Physical Curve(1) = {13};
Physical Curve(114) = {401};
Physical Curve(46) = {115};
Physical Curve(28) = {75};
Physical Curve(103) = {336};
Physical Curve(20) = {68};
Physical Curve(35) = {78};
Physical Curve(86) = {252};
Physical Curve(108) = {348};
Physical Curve(31) = {92};
Physical Curve(4) = {8};
Physical Curve(83) = {239};
Physical Curve(56) = {149};
Physical Curve(2) = {9};
Physical Curve(44) = {112};
Physical Curve(51) = {138};
Physical Curve(21) = {53};
Physical Curve(3) = {11};
Physical Curve(25) = {51};
Physical Curve(30) = {95};
Physical Curve(45) = {120};
Physical Curve(38) = {88};
Physical Curve(110) = {376};
Physical Curve(80) = {221};
Physical Curve(43) = {110};
Physical Curve(7) = {22};
Physical Curve(89) = {266};
Physical Curve(58) = {153};
Physical Curve(63) = {191};
Physical Curve(84) = {236};
Physical Curve(62) = {165};
Physical Curve(60) = {162};
Physical Curve(85) = {243};
Physical Curve(101) = {318};
Physical Curve(105) = {334};
Physical Curve(100) = {306};
Physical Curve(118) = {451};
Physical Curve(70) = {172};
Physical Curve(69) = {170};
Physical Curve(18) = {47};
Physical Curve(54) = {141};
Physical Curve(14) = {42};
Physical Curve(113) = {392};
Physical Curve(76) = {225};
Physical Curve(66) = {181};
Physical Curve(64) = {189};
Physical Curve(15) = {40};
Physical Curve(92) = {301};
Physical Curve(91) = {300};
Physical Curve(41) = {111};
Physical Curve(19) = {67};
Physical Curve(120) = {478};
Physical Curve(11) = {33};
Physical Curve(94) = {292};
Physical Curve(112) = {388};
Physical Curve(5) = {7};
Physical Curve(52) = {140};
Physical Curve(111) = {386};
Physical Curve(23) = {61};
Physical Curve(82) = {206};
Physical Curve(47) = {113};
Physical Curve(106) = {319};
Physical Curve(72) = {194};
Physical Curve(13) = {32};
Physical Curve(107) = {320};
Physical Curve(48) = {124};
Physical Curve(29) = {76};
Physical Curve(88) = {263};
Physical Curve(87) = {262};
Physical Curve(57) = {148};
Physical Curve(116) = {418};
Physical Curve(6) = {14};
Physical Curve(65) = {190};
Physical Curve(34) = {96};
Physical Curve(93) = {298};
Physical Curve(104) = {335};
Physical Curve(75) = {223};
Physical Curve(16) = {41};
Physical Curve(42) = {109};
Physical Curve(33) = {89};
Physical Curve(98) = {294};
Physical Curve(39) = {98};
Physical Curve(96) = {299};
Physical Curve(37) = {87};
Physical Curve(9) = {23};
Physical Curve(68) = {174};
Physical Curve(67) = {180};
Physical Curve(8) = {21};
Physical Curve(79) = {220};
Physical Curve(50) = {128};
Physical Curve(109) = {369};
Physical Curve(73) = {198};
Physical Curve(102) = {337};
Physical Curve(26) = {49};
Physical Curve(90) = {296};
Physical Curve(99) = {293};
Physical Curve(40) = {100};
Physical Curve(77) = {217};
Physical Curve(119) = {472};
Physical Curve(32) = {97};
Physical Curve(81) = {222};
Physical Curve(22) = {60};
Physical Curve(115) = {402};
Physical Curve(36) = {86};
Physical Curve(12) = {31};
Physical Curve(24) = {58};
Physical Curve(97) = {295};
Physical Curve(117) = {416};
Physical Curve(55) = {150};
Physical Curve(49) = {126};
Physical Curve(27) = {77};
Physical Curve(61) = {159};
Physical Curve(59) = {151};
Physical Curve(10) = {34};
Physical Curve(53) = {139};

///////////////////////////
// Mesh size definitions //
///////////////////////////

// The order of definition is such that those geometries
// with the coarsest defined mesh sizes are placed first
// to ensure that for shared vertices the minimum mesh size is set

DefineConstant[ entityMeshSize_1 = 50 ];

// physical entity 37
Characteristic Length{ PointsOf{Surface{7, 19, 95};} } = entityMeshSize_1;
// physical entity 21
Characteristic Length{ PointsOf{Surface{88};} } = entityMeshSize_1;
// physical entity 27
Characteristic Length{ PointsOf{Surface{76};} } = entityMeshSize_1;
// physical entity 1
Characteristic Length{ PointsOf{Surface{91};} } = entityMeshSize_1;
// physical entity 30
Characteristic Length{ PointsOf{Surface{4};} } = entityMeshSize_1;
// physical entity 35
Characteristic Length{ PointsOf{Surface{92};} } = entityMeshSize_1;
// physical entity 6
Characteristic Length{ PointsOf{Surface{17, 69};} } = entityMeshSize_1;
// physical entity 11
Characteristic Length{ PointsOf{Surface{97};} } = entityMeshSize_1;
// physical entity 40
Characteristic Length{ PointsOf{Surface{5};} } = entityMeshSize_1;
// physical entity 15
Characteristic Length{ PointsOf{Surface{24, 49, 59};} } = entityMeshSize_1;
// physical entity 33
Characteristic Length{ PointsOf{Surface{12, 18};} } = entityMeshSize_1;
// physical entity 9
Characteristic Length{ PointsOf{Surface{11};} } = entityMeshSize_1;
// physical entity 38
Characteristic Length{ PointsOf{Surface{2, 43, 77};} } = entityMeshSize_1;
// physical entity 14
Characteristic Length{ PointsOf{Surface{15};} } = entityMeshSize_1;
// physical entity 17
Characteristic Length{ PointsOf{Surface{9, 23, 25, 27, 30, 31, 37, 38, 45, 47, 50, 67, 70, 72, 86, 96};} } = entityMeshSize_1;
// physical entity 34
Characteristic Length{ PointsOf{Surface{3, 89};} } = entityMeshSize_1;
// physical entity 5
Characteristic Length{ PointsOf{Surface{52};} } = entityMeshSize_1;
// physical entity 18
Characteristic Length{ PointsOf{Surface{1};} } = entityMeshSize_1;
// physical entity 12
Characteristic Length{ PointsOf{Surface{22};} } = entityMeshSize_1;
// physical entity 4
Characteristic Length{ PointsOf{Surface{98};} } = entityMeshSize_1;
// physical entity 20
Characteristic Length{ PointsOf{Surface{62};} } = entityMeshSize_1;
// physical entity 25
Characteristic Length{ PointsOf{Surface{55};} } = entityMeshSize_1;
// physical entity 24
Characteristic Length{ PointsOf{Surface{46};} } = entityMeshSize_1;
// physical entity 26
Characteristic Length{ PointsOf{Surface{40, 83};} } = entityMeshSize_1;
// physical entity 22
Characteristic Length{ PointsOf{Surface{39};} } = entityMeshSize_1;
// physical entity 16
Characteristic Length{ PointsOf{Surface{35, 41, 64};} } = entityMeshSize_1;
// physical entity 29
Characteristic Length{ PointsOf{Surface{34, 87};} } = entityMeshSize_1;
// physical entity 10
Characteristic Length{ PointsOf{Surface{60};} } = entityMeshSize_1;
// physical entity 39
Characteristic Length{ PointsOf{Surface{32, 56};} } = entityMeshSize_1;
// physical entity 8
Characteristic Length{ PointsOf{Surface{65};} } = entityMeshSize_1;
// physical entity 28
Characteristic Length{ PointsOf{Surface{26};} } = entityMeshSize_1;
// physical entity 3
Characteristic Length{ PointsOf{Surface{13, 20, 53, 66, 73, 78, 81, 84, 85};} } = entityMeshSize_1;
// physical entity 32
Characteristic Length{ PointsOf{Surface{33};} } = entityMeshSize_1;
// physical entity 23
Characteristic Length{ PointsOf{Surface{63};} } = entityMeshSize_1;
// physical entity 19
Characteristic Length{ PointsOf{Surface{71};} } = entityMeshSize_1;
// physical entity 2
Characteristic Length{ PointsOf{Surface{80};} } = entityMeshSize_1;
// physical entity 31
Characteristic Length{ PointsOf{Surface{6, 8, 14, 16, 21, 29, 36, 42, 44, 54, 58, 75, 79, 93, 94};} } = entityMeshSize_1;
// physical entity 7
Characteristic Length{ PointsOf{Surface{82};} } = entityMeshSize_1;
// physical entity 36
Characteristic Length{ PointsOf{Surface{10};} } = entityMeshSize_1;
// physical entity 13
Characteristic Length{ PointsOf{Surface{28, 48, 51, 57, 61, 68, 74, 90};} } = entityMeshSize_1;

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
Point{99998} In Surface{91};
// Add producer to surface
Point{99999} In Surface{80};
