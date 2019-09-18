﻿within AixLib.Systems.HydraulicModules.BaseClasses;
model PumpInterface_PumpHeadControlled
  "Pump with physics model that uses pressure head as input and replaceable controller"
  extends BasicPumpInterface;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);
  parameter AixLib.DataBase.Pumps.ControlPump.PumpBaseRecord pumpParam
    "pump parameter record" annotation (choicesAllMatching=true);

  replaceable
    AixLib.Fluid.Movers.PumpsPolynomialBased.Controls.CtrlDpVarH
    pumpController(pumpParam=pumpParam) constrainedby
    Fluid.Movers.PumpsPolynomialBased.Controls.BaseClasses.PumpController
    annotation (
    Dialog(enable=true, tab="Control Strategy"),
    Placement(transformation(extent={{-20,40},{20,80}})),
    __Dymola_choicesAllMatching=true);

  parameter Real Qnom(
    quantity="VolumeFlowRate",
    unit="m3/h",
    displayUnit="m3/h") = 0.67*max(pumpParam.maxMinSpeedCurves[:, 1]) "<html>
    Nominal volume flow rate in m³/h (~0.67*Qmax).<br />
    Qmax is taken from pumpParam.maxMinSpeedCurves.</html>" annotation (Dialog(
        tab="Control Strategy", group="Design point for dp_var control"));
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm Nnom=
      Modelica.Math.Vectors.interpolate(
      x=pumpParam.maxMinSpeedCurves[:, 1],
      y=pumpParam.maxMinSpeedCurves[:, 2],
      xi=Qnom) "<html><br />Pump speed in design point (Qnom,Hnom).<br />
    Default is maximum speed at Qnom from pumpParam.maxMinSpeedCurves.<br />
    Note that N is defined only on [nMin, nMax]. Due to power limitation<br />
    N might be smaller than nMax for higher Q.</html>" annotation (Dialog(tab="Control Strategy",
        group="Design point for dp_var control"));
  parameter Modelica.SIunits.Height Hnom=
      AixLib.Fluid.Movers.PumpsPolynomialBased.BaseClasses.polynomial2D(
      pumpParam.cHQN,
      Qnom,
      Nnom) "<html><br />Nominal pump head in m (water).<br /> 
      Will by default be calculated automatically from Qnom and Nnom.<br />
      If you change the value make sure to also set a feasible Qnom.</html>"
    annotation (Dialog(tab="Control Strategy", group=
          "Design point for dp_var control"));
  parameter Modelica.SIunits.Height H0=0.5*Hnom
    "Pump head at Q == 0 m3/h (defines left point of dp_var line)." annotation (
     Dialog(tab="Control Strategy", group="Design point for dp_var control"));

  parameter Real Qstart(
    quantity="VolumeFlowRate",
    unit="m3/h",
    displayUnit="m3/h") = Qnom "<html>Volume flow rate in m³/h at start of simulation.<br />
  Default is design point (Qnom).</html>"
    annotation (Dialog(tab="Initialization", group="Volume flow"));
  parameter Medium.MassFlowRate m_flow_start=physics.m_flow_start "<html><br />
      Start value of m_flow in port_a.m_flow<br />
      Used to initialize ports a and b and for initial checks of model.<br />
      Use it to conveniently initialize upper level models' start mass flow rate.<br />
      Default is to convert Qnom value. Disabled for user change by default.</html>"
    annotation (Dialog(
      tab="Initialization",
      group="Volume flow",
      enable=false));

  parameter Modelica.SIunits.Height Hstart=max(0,
      AixLib.Fluid.Movers.PumpsPolynomialBased.BaseClasses.polynomial2D(
      pumpParam.cHQN,
      Qstart,
      Nnom)) "<html><br />
      Start value of pump head. Will be used to initialize criticalDamping block<br />
      and pressure in ports a and b.<br />
      Default is to calculate it from Qstart and Nnom. If you change the value<br />
      make sure to also set Qstart to a suitable value.</html>"
    annotation (Dialog(tab="Initialization", group="Pressure"));
  parameter Medium.AbsolutePressure p_a_start=physics.system.p_start "<html><br />
  Start value for inlet pressure. Use it to set a defined absolute pressure<br />
  in the circuit. For example system.p_start. Also use it to initialize<br />
  upper level models properly. It will affect p_b_start.</html>"
    annotation (Dialog(tab="Initialization", group="Pressure"));
  parameter Medium.AbsolutePressure p_b_start=physics.p_b_start "<html><br />
      Start value for outlet pressure. It depends on p_a_start and Hstart.<br />
      It is deactivated for user input by default. Use it in an upper level model<br />
      for proper initialization of other pressure states in that circuit.</html>"
    annotation (Dialog(
      tab="Initialization",
      group="Pressure",
      enable=false));

  parameter Medium.Temperature T_start=physics.system.T_start
    "Start value of temperature in PartialLumpedVolume of PumpPhysics"
    annotation (Dialog(tab="Initialization"));

  // Assumptions
  parameter Boolean checkValve=false "= true to prevent reverse flow"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.SIunits.Volume V=0 "Volume inside the pump"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=physics.system.energyDynamics
    "Formulation of energy balance" annotation (choicesAllMatching=true, Dialog(
        tab="Assumptions", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=physics.system.massDynamics
    "Formulation of mass balance" annotation (choicesAllMatching=true, Dialog(
        tab="Assumptions", group="Dynamics"));

  // Power and Efficiency
  parameter Boolean calculatePower=false "calc. power consumption?"
    annotation (Dialog(tab="General", group="Power and Efficiency"));
  parameter Boolean calculateEfficiency=false
    "calc. efficency? (eta = f(H, Q, P))" annotation (Dialog(
      tab="General",
      group="Power and Efficiency",
      enable=calculate_Power));

  Fluid.Movers.PumpsPolynomialBased.PumpHeadControlled physics(
    pumpParam=pumpParam,
    Qnom=Qnom,
    Nnom=Nnom,
    redeclare package Medium = Medium,
    Qstart=Qstart,
    p_a_start=p_a_start,
    T_start=T_start,
    checkValve=checkValve,
    V=V,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    calculatePower=calculatePower,
    calculateEfficiency=calculateEfficiency,
    redeclare function efficiencyCharacteristic =
        Fluid.Movers.PumpsPolynomialBased.BaseClasses.efficiencyCharacteristic.Wilo_Formula_efficiency)
    annotation (Placement(transformation(extent={{-30,-50},{30,10}})));

equation
  connect(pumpController.pumpBus, physics.pumpBus) annotation (Line(
      points={{0,40},{0,10}},
      color={255,204,51},
      thickness=0.5));
  connect(physics.port_a, port_a) annotation (Line(points={{-30,-20},{-66,-20},{
          -66,0},{-100,0}}, color={0,127,255}));
  connect(physics.port_b, port_b) annotation (Line(points={{30,-20},{66,-20},{66,
          0},{100,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{80,-40},{322,-58}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontName="monospace",
          textString="CA: n_set"),
        Text(
          extent={{80,-60},{322,-78}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontName="monospace",
          textString="H: %Hnom% m",
          visible=true),
        Text(
          extent={{80,-80},{338,-98}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontName="monospace",
          textString="Q: %Qnom% m³/h",
          visible=true),
        Text(
          extent={{80,-20},{300,-38}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontName="monospace",
          textString="%pumpParam.pumpModelString%")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>2018-09-18 by Alexander Kümpel:<br />Renaming and extension from BasicPumpInterface.</li>
<li>2018-03-01 by Peter Matthes:<br />Improved parameter setup of pump model. Ordering in GUI, disabled some parameters that should be used not as input but rather as outputs (m_flow_start, p_a_start and p_b_start) and much more description in the parameter doc strings to help the user make better decisions.</li>
<li>2018-02-01 by Peter Matthes:<br />Fixes option choicesAllMatching=true for controller. Needs to be __Dymola_choicesAllMatching=true. Sets standard control algorithm to dp_var (<code><span style=\"color: #ff0000;\">PumpControlDeltaPvar</span></code>).</li>
<li>2018-01-30 by Peter Matthes:<br />* Renamed delivery head controlled pump model (blue) from Pump into PumpH as well as PumpPhysics into PumpPhysicsH. &quot;H&quot; stands for pump delivery head.<br />* Moved efficiencyCharacteristic package directly into BaseClasses. This is due to moving the older pump model and depencencies into the Deprecated folder.</li>
<li>2018-01-29 by Peter Matthes:<br />* Removes parameter useABCcurves as that is the default to calculate speed and is only needed in the blue pump (PumpH) to calculate power from speed and volume flow. Currently there is no other way to compute speed other than inverting function H = f(Q,N) . This can only be done with the quadratic ABC formula. Therefore, an assert statement has been implemented instead to give a warning when you want to compute power but you use more that the ABC coefficients in cHQN.<br />* Moves the energyBanlance and massBalance to the Assumptions tab as done in the PartialLumpedVolume model.<br />* Removes replaceable function for efficiency calculation. There is only one formula at the moment and no change in sight so that we can declutter the GUI.<br />* Removes parameter Nnom and replaces it with Nstart. As discussed with Wilo Nnom is not very useful and it can be replaced with a start value. The default value has been lowered to a medium speed to avoid collision with the speed/power limitation. For most pumps the maximum speed is limited for increasing volume flows to avoid excess power consumption.<br />* Increases Qnom from 0.5*Qmax to 0.67*Qmax as this would be a more realistic value.</li>
<li>2018-01-26 by Peter Matthes:<br />* Changes parameter name n_start into Nstart to be compatible/exchangeable with the speed controlled pump (red pump).<br />* Adds missing parameters to be compatible with red pump.</li>
<li>2017-11-22 by Peter Matthes:<br />Initial implementation.</li>
</ul>
</html>", info="<html>
<h4>Main equations</h4>
<p>xxx </p>
<h4>Assumption and limitations</h4>
<p>Note assumptions such as a specific definition ranges for the model, possible medium models, allowed combinations with other models etc. There might be limitations of the model such as reduced accuracy under specific circumstances. Please note all those limitations you know of so a potential user won&apos;t make too serious mistakes </p>
<h4>Typical use and important parameters</h4>
<p>xxx </p>
<h4>Options</h4>
<p>xxx </p>
<h4>Dynamics</h4>
<p>Describe which states and dynamics are present in the model and which parameters may be used to influence them. This need not be added in partial classes. </p>
<h4>Validation</h4>
<p>Describe whether the validation was done using analytical validation, comparative model validation or empirical validation. </p>
<h4>Implementation</h4>
<p>xxx </p>
<h4>References</h4>
<p>xxx </p>
</html>"));
end PumpInterface_PumpHeadControlled;
