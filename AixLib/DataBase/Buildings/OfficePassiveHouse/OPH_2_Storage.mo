within AixLib.DataBase.Buildings.OfficePassiveHouse;
record OPH_2_Storage
  extends ZoneBaseRecord(
    n = 5,
    aowo = 0.7,
    Heater_on = true,
    Cooler_on = false,
    l_cooler = 0,
    RatioConvectiveHeatLighting = 0.5,
    zoneID = "OPH_2_Storage",
    usage = "Lager, Technik, Archiv",
    RoomArea = 502.0,
    Vair = 2008.0,
    alphaiwi = 2.27142857143,
    alphaowi = 2.19100529101,
    alphaowo = 25.0,
    g = 0.78,
    NrPeople = 0.0,
    NrPeopleMachines = 0.0,
    LightingPower = 11.3,
    h_heater = 50200,
    gsunblind = {1.0, 1.0, 1.0, 1.0, 1},
    Aw = {32.5, 5.7, 32.5, 5.7, 0},
    withWindows = true,
    weightfactorswindow = {0.137367989694, 0.0240922320386, 0.137367989694, 0.0240922320386, 0},
    weightfactorswall = {0.129329844626, 0.0227343498702, 0.129329844626, 0.0227343498702, 0.118645799557},
    weightfactorground = 0.254305367987,
    Ai = 1757.0,
    withInnerwalls = true,
    R1i = 3.77199442257e-05,
    C1i = 420369709.263,
    Ao = 567.0,
    withOuterwalls = true,
    R1o = 4.72002418185e-05,
    RRest = 0.00127087222011,
    C1o = 147705362.151);
end OPH_2_Storage;
