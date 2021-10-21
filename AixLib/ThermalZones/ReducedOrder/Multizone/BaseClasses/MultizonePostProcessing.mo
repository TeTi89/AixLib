﻿within AixLib.ThermalZones.ReducedOrder.Multizone.BaseClasses;
model MultizonePostProcessing
  "Calculates and outputs values of interest for multizone model"
  parameter Modelica.SIunits.Volume VAir
     "Indoor air volume of building";
  parameter Integer numZones(min=1)
    "Number of zones";
  parameter AixLib.DataBase.ThermalZones.ZoneBaseRecord zoneParam[numZones]
    "Setup for zones" annotation (choicesAllMatching=false);
  Modelica.Blocks.Math.Sum PHeaterSumCalc(nin=numZones)
    "Power consumed for heating with ideal heaters"
    annotation (Placement(transformation(extent={{58,28},{74,44}})));
  Modelica.Blocks.Math.Sum PCoolerSumCalc(nin=numZones)
    "Power consumed for cooling with ideal coolers"
    annotation (Placement(transformation(extent={{58,-14},{74,2}})));
  Modelica.Blocks.Continuous.Integrator WCooler[numZones]
    "Energy consumed for heating by ideal coolers of each room"
    annotation (Placement(transformation(extent={{24,-16},{38,-2}})));
  Modelica.Blocks.Continuous.Integrator WHeater[numZones]
    "Energy consumed for heating by ideal heaters of each room"
    annotation (Placement(transformation(extent={{24,26},{38,40}})));
  Modelica.Blocks.Math.Sum TAirAverageCalc(nin=numZones, k=zoneParam.VAir/VAir)
    "Average temperature of all zones"
    annotation (Placement(transformation(extent={{58,88},{74,104}})));

  Modelica.Blocks.Interfaces.RealInput TAir[numZones](final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit= "°C") "Air temperature of each zone"
                                   annotation (Placement(transformation(extent={{-140,80},
            {-100,120}}),           iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput TRad[numZones](
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="°C") "Radiative temperature of each zone"
                                   annotation (Placement(transformation(extent={{-140,56},
            {-100,96}}),            iconTransformation(extent={{-140,56},{-100,
            96}})));
  Modelica.Blocks.Interfaces.RealInput X_w[numZones](
    final quantity="MassFraction",
    final unit="1") "Absolute humidity in thermal zone" annotation (
      Placement(transformation(extent={{-140,28},{-100,68}}),
        iconTransformation(extent={{-140,22},{-100,62}})));
  Modelica.Blocks.Interfaces.RealInput PCooler[numZones](final quantity="HeatFlowRate",
      final unit="W")
    "Power consumed for cooling with ideal coolers by each zone" annotation (
      Placement(transformation(extent={{-140,-34},{-100,6}}),
        iconTransformation(extent={{-140,-34},{-100,6}})));
  Modelica.Blocks.Interfaces.RealInput PHeater[numZones](final quantity="HeatFlowRate",
      final unit="W")
    "Power consumed for heating ling with ideal heaters by each zone"
    annotation (Placement(transformation(extent={{-140,-6},{-100,34}}),
        iconTransformation(extent={{-140,-6},{-100,34}})));
  Modelica.Blocks.Interfaces.RealInput PelAHU(final quantity="Power", final
      unit="W") "Electrical power of AHU"
    annotation (Placement(transformation(extent={{-140,-62},{-100,-22}}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-42})));
  Modelica.Blocks.Interfaces.RealInput  PHeatAHU(final quantity="HeatFlowRate",
      final unit="W")
    "Thermal power of AHU for heating"
    annotation (
    Placement(transformation(extent={{-140,-92},{-100,-52}}),
    iconTransformation(extent={{-140,-92},{-100,-52}})));
  Modelica.Blocks.Interfaces.RealInput  PCoolAHU(final quantity="HeatFlowRate",
      final unit="W")
    "Thermal power of AHU for cooling"
    annotation (
    Placement(transformation(extent={{-140,-120},{-100,-80}}),
                                                           iconTransformation(
    extent={{-140,-120},{-100,-80}})));
  Modelica.Blocks.Continuous.Integrator WCoolAHUCalc
    "Energy consumed for cooling by AHU"
    annotation (Placement(transformation(extent={{58,-102},{74,-86}})));
  Modelica.Blocks.Continuous.Integrator WElAHUCalc
    "Electric energy consumed by AHU"
    annotation (Placement(transformation(extent={{58,-56},{74,-40}})));
  Modelica.Blocks.Continuous.Integrator WHeatAHUCalc
    "Energy consumed for heating by AHU"
    annotation (Placement(transformation(extent={{58,-78},{74,-62}})));
  Modelica.Blocks.Math.Sum WHeaterSumCalc(nin=numZones)
    "Energy consumed for heating with ideal heaters"
    annotation (Placement(transformation(extent={{58,8},{74,24}})));
  Modelica.Blocks.Math.Sum WCoolerSumCalc(nin=numZones)
    "Energy consumed for cooling with ideal coolers"
    annotation (Placement(transformation(extent={{58,-34},{74,-18}})));
  Modelica.Blocks.Interfaces.RealOutput TAirMean(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Average air temperature in building" annotation (
      Placement(transformation(extent={{100,88},{120,108}}), iconTransformation(
          extent={{100,88},{120,108}})));
  Modelica.Blocks.Interfaces.RealOutput PHeaterSum(
    final quantity="HeatFlowRate",
    final unit="W")
    "Summed heating power consumed by ideal heaters"
    annotation (Placement(transformation(extent={{100,42},{120,62}})));
  Modelica.Blocks.Interfaces.RealOutput PCoolerSum(
    final quantity="HeatFlowRate",
    final unit="W")
    "Summed cooling power consumed by ideal coolers"
    annotation (Placement(transformation(extent={{100,22},{120,42}})));
  Modelica.Blocks.Interfaces.RealOutput WHeaterSum(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Summed heating energy consumed by ideal heater"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput WCoolerSum(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Summed cooling energy consumed by ideal coolers"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Modelica.Blocks.Interfaces.RealOutput WElAHU(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Electric energy consumed by AHU"
    annotation (Placement(transformation(extent={{100,-42},{120,-22}})));
  Modelica.Blocks.Interfaces.RealOutput WHeatAHU(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Heating energy consumed by AHU"
    annotation (Placement(transformation(extent={{100,-64},{120,-44}})));
  Modelica.Blocks.Interfaces.RealOutput WCoolAHU(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Cooling energy consumed by AHU"
    annotation (Placement(transformation(extent={{100,-88},{120,-68}})));

  Utilities.Psychrometrics.Phi_pTX calcPhi[numZones]
    "Calculates relative humdity"
    annotation (Placement(transformation(extent={{-22,32},{-2,52}})));
  Modelica.Blocks.Sources.Constant constPressure[numZones](k=101325)
    annotation (Placement(transformation(extent={{-78,20},{-62,36}})));
  Modelica.Blocks.Interfaces.RealOutput TOperativeMean(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Average operative air temperature in building"
    annotation (Placement(transformation(extent={{100,72},{120,92}}),
        iconTransformation(extent={{100,82},{120,102}})));
  Modelica.Blocks.Interfaces.RealOutput RelHumidityMean(final unit="1")
    "Average relative humidity in building" annotation (Placement(
        transformation(extent={{100,56},{120,76}}), iconTransformation(extent={
            {100,82},{120,102}})));
  Modelica.Blocks.Math.Add operativeTemperatureCalc[numZones](k1=0.5, k2=0.5)
    annotation (Placement(transformation(extent={{-22,66},{-2,86}})));
  Modelica.Blocks.Math.Sum TOperativeAverageCalc(nin=numZones, k=zoneParam.VAir
        /VAir) "Average operative temperature of all zones"
    annotation (Placement(transformation(extent={{58,68},{74,84}})));
  Modelica.Blocks.Math.Sum RelHumditiyMeanCalc(nin=numZones, k=zoneParam.VAir/
        VAir) "Average relative humidity of all zones"
    annotation (Placement(transformation(extent={{58,48},{74,64}})));
equation
  connect(TAirAverageCalc.u, TAir) annotation (Line(points={{56.4,96},{56.4,100},
          {-120,100}}, color={0,0,127}));
  connect(PCoolerSumCalc.u, PCooler)
    annotation (Line(points={{56.4,-6},{-120,-6},{-120,-14}},color={0,0,127}));
  connect(PHeater, PHeaterSumCalc.u) annotation (Line(points={{-120,14},{22,14},
          {22,36},{56.4,36}},  color={0,0,127}));
  connect(PelAHU, WElAHUCalc.u) annotation (Line(points={{-120,-42},{-32,-42},{
          -32,-48},{56.4,-48}},
                            color={0,0,127}));
  connect(PHeatAHU, WHeatAHUCalc.u) annotation (Line(points={{-120,-72},{-82,
          -72},{-82,-70},{56.4,-70}},
                                 color={0,0,127}));
  connect(PCoolAHU, WCoolAHUCalc.u) annotation (Line(points={{-120,-100},{-30,
          -100},{-30,-94},{56.4,-94}},
                                 color={0,0,127}));
  connect(PHeater, WHeater.u) annotation (Line(points={{-120,14},{22.6,14},{
          22.6,33}},                color={0,0,127}));
  connect(WHeater.y, WHeaterSumCalc.u) annotation (Line(points={{38.7,33},{48,
          33},{48,16},{56.4,16}},
                              color={0,0,127}));
  connect(PCooler, WCooler.u) annotation (Line(points={{-120,-14},{-82,-14},{
          -82,-9},{22.6,-9}},
                      color={0,0,127}));
  connect(WCooler.y, WCoolerSumCalc.u) annotation (Line(points={{38.7,-9},{48,
          -9},{48,-26},{56.4,-26}},
                            color={0,0,127}));
  connect(TAirAverageCalc.y, TAirMean) annotation (Line(points={{74.8,96},{92,
          96},{92,98},{110,98}}, color={0,0,127}));
  connect(PHeaterSumCalc.y, PHeaterSum)
    annotation (Line(points={{74.8,36},{92,36},{92,52},{110,52}},
                                                  color={0,0,127}));
  connect(PCoolerSumCalc.y, PCoolerSum) annotation (Line(points={{74.8,-6},{92,
          -6},{92,32},{110,32}},
                             color={0,0,127}));
  connect(WHeaterSumCalc.y, WHeaterSum) annotation (Line(points={{74.8,16},{92,
          16},{92,10},{110,10}},
                             color={0,0,127}));
  connect(WCoolerSumCalc.y, WCoolerSum)
    annotation (Line(points={{74.8,-26},{92,-26},{92,-10},{110,-10}},
                                                color={0,0,127}));
  connect(WElAHUCalc.y, WElAHU)
    annotation (Line(points={{74.8,-48},{92,-48},{92,-32},{110,-32}},
                                                    color={0,0,127}));
  connect(WHeatAHUCalc.y, WHeatAHU)
    annotation (Line(points={{74.8,-70},{92,-70},{92,-54},{110,-54}},
                                                    color={0,0,127}));
  connect(WCoolAHUCalc.y, WCoolAHU)
    annotation (Line(points={{74.8,-94},{92,-94},{92,-78},{110,-78}},
                                                    color={0,0,127}));
  connect(constPressure.y, calcPhi.p) annotation (Line(points={{-61.2,28},{-42,
          28},{-42,34},{-23,34}}, color={0,0,127}));
  connect(TAir, calcPhi.T) annotation (Line(points={{-120,100},{-28,100},{-28,
          50},{-23,50}}, color={0,0,127}));
  connect(X_w, calcPhi.X_w) annotation (Line(points={{-120,48},{-32,48},{-32,42},
          {-23,42}}, color={0,0,127}));
  connect(TAir, operativeTemperatureCalc.u1) annotation (Line(points={{-120,100},
          {-28,100},{-28,82},{-24,82}}, color={0,0,127}));
  connect(TRad, operativeTemperatureCalc.u2) annotation (Line(points={{-120,76},
          {-72,76},{-72,70},{-24,70}}, color={0,0,127}));
  connect(operativeTemperatureCalc.y, TOperativeAverageCalc.u) annotation (Line(
        points={{-1,76},{28,76},{28,76},{56.4,76}}, color={0,0,127}));
  connect(TOperativeAverageCalc.y, TOperativeMean) annotation (Line(points={{
          74.8,76},{90,76},{90,82},{110,82}}, color={0,0,127}));
  connect(calcPhi.phi, RelHumditiyMeanCalc.u) annotation (Line(points={{-1,42},
          {15.5,42},{15.5,56},{56.4,56}}, color={0,0,127}));
  connect(RelHumditiyMeanCalc.y, RelHumidityMean) annotation (Line(points={{
          74.8,56},{88,56},{88,66},{110,66}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{34,76},{34,36},{54,56},{34,76}},
          lineColor={28,108,200},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,64},{36,48}},
          lineColor={28,108,200},
          fillColor={85,85,255},
          fillPattern=FillPattern.Solid),                                 Text(
          extent={{-88,96},{92,136}},
          lineColor={0,0,255},
          textString="%name%"),
        Rectangle(extent={{-20,-16},{22,-74}}, lineColor={28,108,200}),
        Rectangle(
          extent={{-18,-20},{20,-32}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-18,-36},{-10,-42}}, lineColor={28,108,200}),
        Ellipse(extent={{-8,-36},{0,-42}}, lineColor={28,108,200}),
        Ellipse(extent={{2,-36},{10,-42}}, lineColor={28,108,200}),
        Ellipse(extent={{12,-36},{20,-42}}, lineColor={28,108,200}),
        Ellipse(extent={{-18,-46},{-10,-52}}, lineColor={28,108,200}),
        Ellipse(extent={{-8,-46},{0,-52}}, lineColor={28,108,200}),
        Ellipse(extent={{2,-46},{10,-52}}, lineColor={28,108,200}),
        Ellipse(extent={{12,-46},{20,-52}}, lineColor={28,108,200}),
        Ellipse(extent={{-18,-54},{-10,-60}}, lineColor={28,108,200}),
        Ellipse(extent={{-18,-64},{-10,-70}}, lineColor={28,108,200}),
        Ellipse(extent={{-8,-64},{0,-70}}, lineColor={28,108,200}),
        Ellipse(extent={{-8,-54},{0,-60}}, lineColor={28,108,200}),
        Ellipse(extent={{2,-54},{10,-60}}, lineColor={28,108,200}),
        Ellipse(extent={{12,-64},{20,-70}}, lineColor={28,108,200}),
        Ellipse(extent={{2,-64},{10,-70}}, lineColor={28,108,200}),
        Ellipse(extent={{12,-54},{20,-60}}, lineColor={28,108,200})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model is used to simplify the post processing. It&apos;s purpose is to calculate and output common simulation information and KPI for later post processing. </p>
</html>"));
end MultizonePostProcessing;
