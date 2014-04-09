within Spot.ACabc;
package Ports "AC three-phase ports abc representation"
  extends Base.Icons.Base;


partial model Port_p "AC one port 'positive', 3-phase"

  Base.Interfaces.ACabc_p term "positive terminal"
                          annotation (Placement(transformation(extent={{-110,
              -10},{-90,10}}, rotation=0)));
  annotation (
          Icon(graphics={Text(
            extent={{-100,-90},{100,-130}},
            lineColor={0,0,0},
            textString=
           "%name")}),
    Documentation(info="<html></html>"),
    Diagram(graphics));
end Port_p;

partial model Port_n "AC one port 'negative', 3-phase"

  Base.Interfaces.ACabc_n term "negative terminal"
annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
  annotation (
          Icon(graphics={Text(
            extent={{-100,-90},{100,-130}},
            lineColor={0,0,0},
            textString=
                 "%name")}),
    Documentation(info="<html></html>"),
    Diagram(graphics));
end Port_n;

partial model Port_f "AC one port 'fault', 3-phase"

  Base.Interfaces.ACabc_p term "fault terminal"
annotation (Placement(transformation(
          origin={0,-100},
          extent={{-10,-10},{10,10}},
          rotation=90)));
  annotation (
          Icon(graphics={Text(
            extent={{-100,130},{100,90}},
            lineColor={0,0,0},
            textString=
           "%name")}),
    Documentation(info="<html></html>"),
    Diagram(graphics));
end Port_f;

partial model Port_p_n "AC two port, 3-phase"

  Base.Interfaces.ACabc_p term_p "positive terminal"
annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  Base.Interfaces.ACabc_n term_n "negative terminal"
annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation
  Connections.branch(term_p.theta, term_n.theta);
  term_n.theta = term_p.theta;
  annotation (
Icon(graphics={Text(
            extent={{-100,-90},{100,-130}},
            lineColor={0,0,0},
            textString=
           "%name")}),
Documentation(info="<html>
</html>"),
Diagram(graphics));
end Port_p_n;

partial model Port_pn "AC two port 'current_in = current_out', 3-phase"
  extends Port_p_n;


equation
  term_p.i + term_n.i = zeros(3);
  annotation (
Icon(graphics),
Documentation(info="<html>
</html>"),
Diagram(graphics));
end Port_pn;

partial model Port_p_n_f "AC three port, 3-phase"
  extends Port_p_n;

  Base.Interfaces.ACabc_n term_f "fault terminal"
annotation (Placement(transformation(
          origin={0,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));

equation
  Connections.branch(term_p.theta, term_f.theta);
  term_f.theta = term_p.theta;
  annotation (
Icon(graphics),
Documentation(info="<html>
</html>"),
Diagram(graphics));
end Port_p_n_f;

partial model Yport_p "AC one port Y topology 'positive'"
  extends Port_p;

  SI.Voltage[3] v "voltage terminal to neutral";
  SI.Current[3] i "current terminal in";
  SI.Voltage v_n(final start=0) "voltage neutral";
  SI.Current i_n(final start=0) "current neutral";

equation
  v = term.v - {v_n, v_n, v_n};
  term.i = i;
  i_n = sum(term.i);
  annotation (
          Icon(graphics),
                Diagram(graphics={Line(points={{30,-16},{52,-16},{62,0},{52,16},
                {30,16}}, color={0,0,255}), Line(points={{30,0},{70,0}}, color=
                {0,0,255})}),
    Documentation(info="<html>
<p>Defines Y-topology transform of voltage and current variables.</p>
<p>Definitions</p>
<pre>
  v:     voltage across conductor
  i:     current through conductor
  v_n:   voltage neutral point
  i_n:   current neutral to ground
</pre>
<p>Relations Y-topology, (<tt>v, i</tt>: terminal to neutral point)</p>
<pre>
  v = term.v - {v_n, v_n, v_n}
  i = term.i
  i_n = sum(term.i)
</pre>
</html>"));
end Yport_p;

partial model Yport_n "AC one port Y topology 'negative'"
  extends Port_n;

  SI.Voltage[3] v "voltage terminal to neutral";
  SI.Current[3] i "current terminal in";
  SI.Voltage v_n(final start=0) "voltage neutral";
  SI.Current i_n(final start=0) "current neutral";

equation
  v = term.v - {v_n, v_n, v_n};
  term.i = i;
  i_n = sum(term.i);
  annotation (
          Icon(graphics),
                Diagram(graphics={Line(points={{-30,-16},{-52,-16},{-62,0},{-52,
                16},{-30,16}}, color={0,0,255}), Line(points={{-70,0},{-30,0}},
              color={0,0,255})}),
    Documentation(info="<html>
<p>Defines Y-topology transform of voltage and current variables.</p>
<p>Definitions</p>
<pre>
  v:     voltage across conductor
  i:     current through conductor
  v_n:   voltage neutral point
  i_n:   current neutral to ground
</pre>
<p>Relations Y-topology, (<tt>v, i</tt>: terminal to neutral point)</p>
<pre>
  v = term.v - {v_n, v_n, v_n}
  i = term.i
  i_n = sum(term.i)
</pre>
</html>"));
end Yport_n;

partial model YDport_p "AC one port Y or Delta topology 'positive'"
  extends Port_p;

  replaceable Topology.Y top "Y or Delta topology"
    annotation (                        choices(
    choice(redeclare Spot.ACabc.Ports.Topology.Y top "Y"),
    choice(redeclare Spot.ACabc.Ports.Topology.Delta top "Delta")), Placement(
          transformation(extent={{30,-20},{70,20}}, rotation=0)));
  SI.Voltage[3] v=top.v_cond "voltage conductor";
  SI.Current[3] i=top.i_cond "current conductor";
  SI.Voltage[n_n] v_n=top.v_n "voltage neutral";
  SI.Current[n_n] i_n=top.i_n "current neutral to ground";
  protected
  final parameter Integer n_n=top.n_n
                              annotation(evaluate=true);

equation
  term.v = top.v_term;
  term.i = top.i_term;
  annotation (
          Icon(graphics),
                Diagram(graphics),
    Documentation(info="<html>
<p>Defines Y- and Delta-topology transform of voltage and current variables.</p>
<p>Definitions</p>
<pre>
  v:     voltage across conductor
  i:     current through conductor
  v_n:   voltage neutral point if Y-topology
  i_n:   current neutral to ground if Y-topology
</pre>
<p>Relations Y-topology, (<tt>v, i</tt>: terminal to neutral point)</p>
<pre>
  v = term.v - {v_n, v_n, v_n}
  term.i = i
  i_n = sum(term.i)
</pre>
<p>Relations Delta-topology, (<tt>v, i</tt>: phase terminal to phase terminal)</p>
<pre>
  v_cond = v_term[{1,2,3}] - v_term[{2,3,1}]
  i_term = i_cond[{1,2,3}] - i_cond[{3,1,2}]
</pre>
</html>
"));
end YDport_p;

partial model YDport_n "AC one port Y or Delta topology 'positive'"
  extends Port_n;

  replaceable Topology.Y top "Y or Delta topology"
    annotation (                          choices(
    choice(redeclare Spot.ACabc.Ports.Topology.Y top "Y"),
    choice(redeclare Spot.ACabc.Ports.Topology.Delta top "Delta")), Placement(
          transformation(extent={{-30,-20},{-70,20}}, rotation=0)));
  SI.Voltage[3] v=top.v_cond "voltage conductor";
  SI.Current[3] i=top.i_cond "current conductor";
  SI.Voltage[n_n] v_n=top.v_n "voltage neutral";
  SI.Current[n_n] i_n=top.i_n "current neutral to ground";
  protected
  final parameter Integer n_n=top.n_n
                              annotation(evaluate=true);

equation
  term.v = top.v_term;
  term.i = top.i_term;
  annotation (
          Icon(graphics),
                Diagram(graphics),
    Documentation(info="<html>
<p>Defines Y- and Delta-topology transform of voltage and current variables.</p>
<p>Definitions</p>
<pre>
  v:     voltage across conductor
  i:     current through conductor
  v_n:   voltage neutral point if Y-topology
  i_n:   current neutral to ground if Y-topology
</pre>
<p>Relations Y-topology, (<tt>v, i</tt>: terminal to neutral point)</p>
<pre>
  v = term.v - {v_n, v_n, v_n}
  term.i = i
  i_n = sum(term.i)
</pre>
<p>Relations Delta-topology, (<tt>v, i</tt>: phase terminal to phase terminal)</p>
<pre>
  v_cond = v_term[{1,2,3}] - v_term[{2,3,1}]
  i_term = i_cond[{1,2,3}] - i_cond[{3,1,2}]
</pre>
</html>"));
end YDport_n;

partial model Y_Dport_p "AC two port, switcheable Y-Delta topology"
  extends Port_p;

  replaceable Topology.Y_Delta top "Y-Delta switcheable"
                                                      annotation (Placement(
          transformation(extent={{30,-20},{70,20}}, rotation=0)));
  SI.Voltage[3] v=top.v_cond "voltage conductor";
  SI.Current[3] i=top.i_cond "current conductor";
  Modelica.Blocks.Interfaces.BooleanInput YDcontrol "true:Y, false:Delta"
                                            annotation (Placement(
          transformation(extent={{-110,30},{-90,50}}, rotation=0)));

equation
  term.v = top.v_term;
  term.i = top.i_term;
  connect(YDcontrol, top.control) annotation (Line(points={{-100,40},{40,40},{
            40,20}}, color={255,0,255}));
  annotation (
          Icon(graphics),
                Diagram(graphics),
    Documentation(info="<html>
<p>Modification of YDport_p for switcheable Y-Delta transform.<br>
Defines Y- and Delta-topology transform of voltage and current variables.<br>
The neutral point is isolated.</p>
<p>Definitions</p>
<pre>
  v:     voltage across conductor
  i:     current through conductor
  v_n:   voltage neutral point if Y-topology
  i_n=0: current neutral to ground if Y-topology
</pre>
<p>Relations Y-topology, (<tt>v, i</tt>: terminal to neutral point)</p>
<pre>
  v = term.v - {v_n, v_n, v_n}
  term.i = i
  i_n = sum(term.i)
</pre>
<p>Relations Delta-topology, (<tt>v, i</tt>: phase terminal to phase terminal)</p>
<pre>
  v_cond = v_term[{1,2,3}] - v_term[{2,3,1}]
  i_term = i_cond[{1,2,3}] - i_cond[{3,1,2}]
</pre>
</html>"));
end Y_Dport_p;

partial model YDportTrafo_p_n
    "AC two port with Y or Delta topology for transformers"
  extends Port_p_n;

  replaceable Topology.Y top_p "p: Y or Delta topology"
    annotation (                         choices(
    choice(redeclare Spot.ACabc.Ports.Topology.Y top_p "Y"),
    choice(redeclare Spot.ACabc.Ports.Topology.Delta top_p "Delta")), Placement(
          transformation(extent={{-80,-20},{-40,20}}, rotation=0)));
  replaceable Topology.Y top_n "n: Y or Delta topology"
    annotation (                        choices(
    choice(redeclare Spot.ACabc.Ports.Topology.Y top_n "Y"),
    choice(redeclare Spot.ACabc.Ports.Topology.Delta top_n "Delta")), Placement(
          transformation(extent={{80,-20},{40,20}}, rotation=0)));

  SI.Voltage[3] v1=top_p.v_cond/w1 "voltage conductor";
  SI.Current[3] i1=top_p.i_cond*w1 "current conductor";
  SI.Voltage[n_n1] v_n1=top_p.v_n "voltage neutral";
  SI.Current[n_n1] i_n1=top_p.i_n "current neutral to ground";

  SI.Voltage[3] v2=top_n.v_cond/w2 "voltage conductor";
  SI.Current[3] i2=top_n.i_cond*w2 "current conductor";
  SI.Voltage[n_n2] v_n2=top_n.v_n "voltage neutral";
  SI.Current[n_n2] i_n2=top_n.i_n "current neutral to ground";
  protected
  constant Integer[2] scale={top_p.scale, top_n.scale};
  final parameter Integer n_n1=top_p.n_n annotation(evaluate=true);
  final parameter Integer n_n2=top_n.n_n
                                        annotation(evaluate=true);
  Real w1 "1: voltage ratio to nominal";
  Real w2 "2: voltage ratio to nominal";

equation
  term_p.v = top_p.v_term;
  term_p.i = top_p.i_term;
  term_n.v = top_n.v_term;
  term_n.i = top_n.i_term;
  annotation (
Icon(graphics),
Documentation(info="<html>
<p>Defines Y- and Delta-topology transform of voltage and current variables and contains additionally voltage and current scaling.</p>
<p>Below</p>
<pre>  term, v, i, w</pre>
<p>denote either the 'primary' or 'secondary' side</p>
<pre>
  term_p, v1, i1, w1
  term_n, v2, i2, w2
</pre>
<p>Definitions</p>
<pre>
  v:     scaled voltage across conductor
  i:     scaled current through conductor
  v_n:   voltage neutral point if Y-topology
  i_n:   current neutral to ground if Y-topology
  w:     voltage ratio to nominal (any value, but common for primary and secondary)
</pre>
<p>Relations Y-topology, (<tt>v, i</tt>: terminal to neutral point)</p>
<pre>
  v = (term.v - {v_n, v_n, v_n})/w
  term.i = i/w
  i_n = sum(term.i)
</pre>
<p>Relations Delta-topology, (<tt>v, i</tt>: phase terminal to phase terminal)</p>
<pre>
  v_cond = v_term[{1,2,3}] - v_term[{2,3,1}]
  i_term = i_cond[{1,2,3}] - i_cond[{3,1,2}]
</pre>
</html>
"),
Diagram(graphics));
end YDportTrafo_p_n;

partial model YDportTrafo_p_n_n
    "AC three port with Y or Delta topology for 3-winding transformers"

  Spot.Base.Interfaces.ACabc_p term_p "positive terminal"
                                      annotation (Placement(transformation(
            extent={{-110,-10},{-90,10}}, rotation=0)));
  Spot.Base.Interfaces.ACabc_n term_na "negative terminal a"
                                       annotation (Placement(transformation(
            extent={{90,30},{110,50}}, rotation=0)));
  Spot.Base.Interfaces.ACabc_n term_nb "negative terminal b"
                                       annotation (Placement(transformation(
            extent={{90,-50},{110,-30}}, rotation=0)));

  replaceable Topology.Y top_p "p: Y or Delta topology"
    annotation (                         choices(
    choice(redeclare Spot.ACabc.Ports.Topology.Y top_p "Y"),
    choice(redeclare Spot.ACabc.Ports.Topology.Delta top_p "Delta")), Placement(
          transformation(extent={{-80,-20},{-40,20}}, rotation=0)));
  replaceable Topology.Y top_na "na: Y or Delta topology"
    annotation (                        choices(
    choice(redeclare Spot.ACabc.Ports.Topology.Y top_na "Y"),
    choice(redeclare Spot.ACabc.Ports.Topology.Delta top_na "Delta")),
        Placement(transformation(extent={{80,20},{40,60}}, rotation=0)));
  replaceable Topology.Y top_nb "nb: Y or Delta topology"
    annotation (                        choices(
    choice(redeclare Spot.ACabc.Ports.Topology.Y top_nb "Y"),
    choice(redeclare Spot.ACabc.Ports.Topology.Delta top_nb "Delta")),
        Placement(transformation(extent={{80,-60},{40,-20}}, rotation=0)));

  SI.Voltage[3] v1=top_p.v_cond/w1 "voltage conductor";
  SI.Current[3] i1=top_p.i_cond*w1 "current conductor";
  SI.Voltage[n_n1] v_n1=top_p.v_n "voltage neutral";
  SI.Current[n_n1] i_n1=top_p.i_n "current neutral to ground";

  SI.Voltage[3] v2a=top_na.v_cond/w2a "voltage conductor";
  SI.Current[3] i2a=top_na.i_cond*w2a "current conductor";
  SI.Voltage[n_n2a] v_n2a=top_na.v_n "voltage neutral";
  SI.Current[n_n2a] i_n2a=top_na.i_n "current neutral to ground";

  SI.Voltage[3] v2b=top_nb.v_cond/w2b "voltage conductor";
  SI.Current[3] i2b=top_nb.i_cond*w2b "current conductor";
  SI.Voltage[n_n2b] v_n2b=top_nb.v_n "voltage neutral";
  SI.Current[n_n2b] i_n2b=top_nb.i_n "current neutral to ground";

  SI.Voltage[3] v0;
  protected
  constant Integer[3] scale={top_p.scale, top_na.scale, top_nb.scale};
  final parameter Integer n_n1=top_p.n_n annotation(evaluate=true);
  final parameter Integer n_n2a=top_na.n_n
                                          annotation(evaluate=true);
  final parameter Integer n_n2b=top_nb.n_n
                                          annotation(evaluate=true);
  Real w1 "1: voltage ratio to nominal";
  Real w2a "2a: voltage ratio to nominal";
  Real w2b "2b: voltage ratio to nominal";

equation
  Connections.branch(term_p.theta, term_na.theta);
  Connections.branch(term_p.theta, term_nb.theta);
  term_na.theta = term_p.theta;
  term_nb.theta = term_p.theta;

  term_p.v = top_p.v_term;
  term_p.i = top_p.i_term;
  term_na.v = top_na.v_term;
  term_na.i = top_na.i_term;
  term_nb.v = top_nb.v_term;
  term_nb.i = top_nb.i_term;
  annotation (
Icon(graphics={Text(
            extent={{-100,-90},{100,-130}},
            lineColor={0,0,0},
            textString=
           "%name")}),
Documentation(info="<html>
<p>Defines Y- and Delta-topology transform of voltage and current variables and contains additionally voltage and current scaling.</p>
<p>Below</p>
<pre>  term, v, i, w</pre>
<p>denote either the 'primary' or 'secondary_a' or 'secondary_b' side</p>
<pre>
  term_p, v1, i1, w1
  term_na, v2a, i2a, w2a
  term_nb, v2b, i2b, w2b
</pre>
<p>Definitions</p>
<pre>
  v:     scaled voltage across conductor
  i:     scaled current through conductor
  v_n:   voltage neutral point if Y-topology
  i_n:   current neutral to ground if Y-topology
  w:     voltage ratio to nominal (any value, but common for primary and secondary)
</pre>
<p>Relations Y-topology, (<tt>v, i</tt>: terminal to neutral point)</p>
<pre>
  v = (term.v - {0, 0, sqrt(3)*v_n})/w
  term.i = i/w
  i_n = sqrt(3)*term.i[3]
</pre>
<p>Relations Delta-topology, (<tt>v, i</tt>: phase terminal to phase terminal)</p>
<pre>
  v[1:2] = sqrt(3)*Rot*term.v[1:2]/w
  v[3] = 0
  term.i[1:2] = sqrt(3)*transpose(Rot)*i[1:2]/w
  term.i[3] = 0
  with Rot = rotation_30deg
</pre>
</html>
"),
Diagram(graphics));
end YDportTrafo_p_n_n;

package Topology "Topology transforms "
  extends Base.Icons.Base;


partial model TopologyBase "Topology transform base"

  parameter Integer n_n=1 "1 for Y, 0 for Delta";
  parameter Integer sh(min=-1,max=1)=0 "(-1,0,+1)*120deg phase shift"
                                                                  annotation(Evaluate=true);
  SI.Voltage[3] v_term "terminal voltage";
  SI.Current[3] i_term "terminal current";
  SI.Voltage[3] v_cond "conductor voltage";
  SI.Current[3] i_cond "conductor current";
  SI.Voltage[n_n] v_n(start=fill(0,n_n)) "voltage neutral";
  SI.Current[n_n] i_n(start=fill(0,n_n)) "current neutral to ground";

  annotation (
    defaultComponentName="Y",
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
      info="<html>
</html>
  "), Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={255,255,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{-100,-90},{100,-130}},
              lineColor={0,0,0},
              textString=
         "%name")}),
      Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics));
end TopologyBase;

model Y "Y transform"
  extends TopologyBase(final n_n=1, final sh=0);

  constant Integer scale=1 "for scaling of impedance values";

equation
  v_cond = v_term - {v_n[1], v_n[1], v_n[1]};
  i_term = i_cond;
  i_n[1] = sum(i_term);
  annotation (
    structurallyIncomplete,
    defaultComponentName="Y",
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
      info="<html>
<p><b>Structurally incomplete model</b>. Use only as component within appropriate complete model.<br>
Defines Y-topology transform of voltage and current variables.</p>
<p>Definitions</p>
<pre>
  v_term, i_term:   terminal voltage and current
  v_cond, i_cond:   voltage and current across conductor, (terminal to neutral point)
</pre>
<p>Relations, zero-component and neutral point (grounding)</p>
<pre>
  v_cond = v_term - {v_n, v_n, v_n}
  i_term = i_cond
  i_n = sum(i_term)
</pre>
<p>Note: parameter sh (phase shift) not used.</p>
</html>"),
      Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(
              points={{-60,0},{60,0}},
              color={255,0,0},
              thickness=0.5),
            Line(points={{60,0},{100,0}}, color={0,0,255}),
            Line(
              points={{-60,80},{10,80},{60,0},{10,-80},{-60,-80}},
              color={255,0,0},
              thickness=0.5),
            Line(points={{-100,80},{-60,80}}, color={0,0,255}),
            Line(points={{-100,0},{-60,0}}, color={0,0,255}),
            Line(points={{-100,-80},{-60,-80}}, color={0,0,255})}),
      Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(points={{-88,80},{-60,80}}, color={0,0,255}),
            Line(points={{-90,0},{-60,0}}, color={0,0,255}),
            Line(points={{-90,-80},{-60,-80}}, color={0,0,255}),
            Line(
              points={{-60,80},{10,80},{60,0},{10,-80},{-60,-80}},
              color={255,0,0},
              thickness=0.5),
            Line(
              points={{-60,0},{60,0}},
              color={255,0,0},
              thickness=0.5),
            Line(points={{60,0},{90,0}}, color={0,0,255})}));
end Y;

model Delta "Delta transform"
  extends TopologyBase(final n_n=0);

  constant Integer scale=3 "for scaling of impedance values";
    protected
  function perm=Base.Transforms.permutation;

equation
  v_cond = perm(-sh, v_term[{1,2,3}] - v_term[{2,3,1}]);
  i_term = perm(sh, i_cond[{1,2,3}] - i_cond[{3,1,2}]);

/*  to avoid permutations use:
  v_cond = v_term[{1,2,3}] - v_term[{2,3,1}];
  i_term = i_cond[{1,2,3}] - i_cond[{3,1,2}];
  Version with permutaions may fail at index reduction due to non-scalar equation.*/
    annotation (
      structurallyIncomplete,
      defaultComponentName="Delta",
    Window(
x=0.45,
  y=0.01,
  width=0.44,
height=0.65),
    Documentation(
    info="<html>
<p><b>Structurally incomplete model</b>. Use only as component within appropriate complete model.<br>
Defines Delta-topology transform of voltage and current variables.<br>
The neutral point is isolated.</p>
</p>Definitions</p>
<pre>
  v_term, i_term:   terminal voltage and current
  v_cond, i_cond:   voltage and current across conductor, (phase terminal to phase terminal)
</pre>
</p>Relations, zero-component<br>
<tt>v_n</tt> and <tt>i_n</tt> are not defined, as there is no neutral point.</p>
<pre>
  v_cond = v_term[{1,2,3}] - v_term[{2,3,1}]  for sh = 0
  i_term = i_cond[{1,2,3}] - i_cond[{3,1,2}]  for sh = 0
  v_cond = v_term[{3,1,2}] - v_term[{1,2,3}]  for sh = 1
  i_term = i_cond[{2,3,1}] - i_cond[{1,2,3}]  for sh = 1
  v_cond = v_term[{2,3,1}] - v_term[{3,1,2}]  for sh = -1
  i_term = i_cond[{3,1,2}] - i_cond[{2,3,1}]  for sh = -1
</pre>
</html>
"), Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(points={{-100,80},{80,80}}, color={0,0,255}),
            Line(points={{-100,0},{-60,0}}, color={0,0,255}),
            Line(points={{-100,-80},{80,-80}}, color={0,0,255}),
            Polygon(
              points={{-60,0},{80,80},{80,-80},{-60,0}},
              lineColor={255,0,0},
              lineThickness=0.5)}),
    Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(points={{-90,80},{80,80}}, color={0,0,255}),
            Line(points={{-90,0},{-60,0}}, color={0,0,255}),
            Line(points={{-90,-80},{80,-80}}, color={0,0,255}),
            Polygon(
              points={{-60,0},{80,80},{80,-80},{-60,0}},
              lineColor={255,0,0},
              lineThickness=0.5)}),
      DymolaStoredErrors);
end Delta;

model Y_Delta "Y Delta switcheble transform"
  extends TopologyBase(final n_n=1, final sh=0);

  Modelica.Blocks.Interfaces.BooleanInput control "true:Y, false:Delta"
      annotation (Placement(transformation(
            origin={-50,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));
  constant Integer scale=1 "for scaling of impedance values";
// in switcheable topology impedance defined as WINDING-impedance (i.e. Y-topology)
    protected
  parameter Real epsG=1e-5;

equation
  if control then
    v_cond = v_term - {v_n[1], v_n[1], v_n[1]};
    i_term = i_cond;
    i_n[1] = sum(i_term);
  else
    v_cond = v_term[{1,2,3}] - v_term[{2,3,1}];
    i_term = i_cond[{1,2,3}] - i_cond[{3,1,2}];
    i_n[1] = 0;
  end if;
//i_n[1] = epsG*v_n[1]; // neutral point isolated
  annotation (
    structurallyIncomplete,
    defaultComponentName="Y_Delta",
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
      info="<html>
<p><b>Structurally incomplete model</b>. Use only as component within appropriate complete model.<br>
Defines switcheable Y-Delta-topology transform of voltage and current variables.<br>
The neutral point is isolated.</p>
<p>More info see Topology.Y and Topology.Delta.</p>
</html>
  "), Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(points={{60,-5},{100,-5}}, color={0,0,255}),
            Line(
              points={{-60,70},{20,70},{60,-5},{20,-80},{-60,-80}},
              color={255,0,0},
              thickness=0.5),
            Line(
              points={{-60,-5},{60,-5}},
              color={255,0,0},
              thickness=0.5),
            Polygon(
              points={{-60,5},{80,80},{80,-70},{-60,5}},
              lineColor={255,0,0},
              pattern=LinePattern.Dot,
              lineThickness=0.5),
            Line(
              points={{-60,80},{80,80}},
              color={0,0,255},
              pattern=LinePattern.Dot),
            Line(
              points={{-60,-70},{80,-70}},
              color={0,0,255},
              pattern=LinePattern.Dot),
            Line(points={{-100,75},{-70,75}}, color={0,0,255}),
            Polygon(
              points={{-70,75},{-60,80},{-60,70},{-70,75}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-70,-75},{-60,-70},{-60,-80},{-70,-75}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-70,0},{-60,5},{-60,-5},{-70,0}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid),
            Line(points={{-100,0},{-70,0}}, color={0,0,255}),
            Line(points={{-100,-75},{-70,-75}}, color={0,0,255})}),
      Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(points={{-70,75},{-60,70}}, color={255,0,255}),
            Line(points={{-70,-75},{-60,-80}}, color={255,0,255}),
            Line(
              points={{-70,75},{-60,80}},
              color={255,0,255},
              pattern=LinePattern.Dot),
            Line(
              points={{-70,-75},{-60,-70}},
              color={255,0,255},
              pattern=LinePattern.Dot),
            Line(points={{-70,0},{-60,-5}}, color={255,0,255}),
            Line(
              points={{-70,0},{-60,5}},
              color={255,0,255},
              pattern=LinePattern.Dot),
            Text(
              extent={{-80,-10},{-60,-20}},
              lineColor={255,0,255},
              pattern=LinePattern.Dot,
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid,
              textString=
         "true"),
            Text(
              extent={{-80,20},{-60,10}},
              lineColor={255,0,255},
              pattern=LinePattern.Dot,
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid,
              textString=
         "false"),
            Line(
              points={{-60,70},{20,70},{60,-5},{20,-80},{-60,-80}},
              color={255,0,0},
              thickness=0.5),
            Line(
              points={{-60,-5},{60,-5}},
              color={255,0,0},
              thickness=0.5),
            Polygon(
              points={{-60,5},{80,80},{80,-70},{-60,5}},
              lineColor={255,0,0},
              pattern=LinePattern.Dot,
              lineThickness=0.5),
            Line(points={{60,-5},{90,-5}}, color={0,0,255}),
            Line(points={{-90,0},{-70,0}}, color={0,0,255}),
            Line(points={{-88,75},{-70,75}}, color={0,0,255}),
            Line(points={{-90,-75},{-70,-75}}, color={0,0,255}),
            Line(
              points={{-60,-70},{80,-70}},
              color={0,0,255},
              pattern=LinePattern.Dot),
            Line(
              points={{-60,80},{80,80}},
              color={0,0,255},
              pattern=LinePattern.Dot),
            Line(points={{-80,-20},{-60,-20}}, color={255,0,255}),
            Line(
              points={{-80,10},{-60,10}},
              color={255,0,255},
              pattern=LinePattern.Dot)}));
end Y_Delta;

model Y_DeltaRegular "Y Delta switcheble transform, eps-regularised"
  extends TopologyBase(final n_n=1, final sh=0);

  Modelica.Blocks.Interfaces.BooleanInput control "true:Y, false:Delta"
      annotation (Placement(transformation(
            origin={-50,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));
  constant Integer scale=1 "for scaling of impedance values";
// in switcheable topology impedance defined as WINDING-impedance (i.e. Y-topology)
    protected
  parameter SI.Conductance epsG=1e-5;
  parameter SI.Resistance epsR=1e-5;
  SI.Current[3] i_neu;
  SI.Current[3] i_del;

equation
  i_term = i_cond - i_del[{3,1,2}];
  i_cond = i_neu + i_del;
  i_n[1] = sum(i_neu);
  if control then
    v_cond = v_term - {v_n[1], v_n[1], v_n[1]} - epsR*i_neu;
    i_del = epsG*(v_term - v_term[{2,3,1}] - v_cond);
  else
    v_cond = v_term[{1,2,3}] - v_term[{2,3,1}] - epsR*i_del;
    i_neu = epsG*(v_term - v_cond - {v_n[1],v_n[1],v_n[1]});
  end if;
//i_n[1] = epsG*v_n[1]; // neutral point isolated
  annotation (
    structurallyIncomplete,
    defaultComponentName="Y_Delta",
      Window(
  x=0.45,
  y=0.01,
  width=0.44,
  height=0.65),
      Documentation(
      info="<html>
<p><b>Structurally incomplete model</b>. Use only as component within appropriate complete model.<br>
Regularised version of Y_Delta. To be used, if device is fed accross an inductive component implying a differentiable current.</p>
<p>More info see Topology.Y and Topology.Delta.</p>
</html>
  "), Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(points={{60,-5},{100,-5}}, color={0,0,255}),
            Line(
              points={{-60,70},{20,70},{60,-5},{20,-80},{-60,-80}},
              color={255,0,0},
              thickness=0.5),
            Line(
              points={{-60,-5},{60,-5}},
              color={255,0,0},
              thickness=0.5),
            Polygon(
              points={{-60,5},{80,80},{80,-70},{-60,5}},
              lineColor={255,0,0},
              pattern=LinePattern.Dot,
              lineThickness=0.5),
            Line(
              points={{-60,80},{80,80}},
              color={0,0,255},
              pattern=LinePattern.Dot),
            Line(
              points={{-60,-70},{80,-70}},
              color={0,0,255},
              pattern=LinePattern.Dot),
            Line(points={{-100,75},{-70,75}}, color={0,0,255}),
            Polygon(
              points={{-70,75},{-60,80},{-60,70},{-70,75}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-70,-75},{-60,-70},{-60,-80},{-70,-75}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-70,0},{-60,5},{-60,-5},{-70,0}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid),
            Line(points={{-100,0},{-70,0}}, color={0,0,255}),
            Line(points={{-100,-75},{-70,-75}}, color={0,0,255})}),
      Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Line(points={{-70,75},{-60,70}}, color={255,0,255}),
            Line(points={{-70,-75},{-60,-80}}, color={255,0,255}),
            Line(
              points={{-70,75},{-60,80}},
              color={255,0,255},
              pattern=LinePattern.Dot),
            Line(
              points={{-70,-75},{-60,-70}},
              color={255,0,255},
              pattern=LinePattern.Dot),
            Line(points={{-70,0},{-60,-5}}, color={255,0,255}),
            Line(
              points={{-70,0},{-60,5}},
              color={255,0,255},
              pattern=LinePattern.Dot),
            Text(
              extent={{-80,-10},{-60,-20}},
              lineColor={255,0,255},
              pattern=LinePattern.Dot,
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid,
              textString=
         "true"),
            Text(
              extent={{-80,20},{-60,10}},
              lineColor={255,0,255},
              pattern=LinePattern.Dot,
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid,
              textString=
         "false"),
            Line(
              points={{-60,70},{20,70},{60,-5},{20,-80},{-60,-80}},
              color={255,0,0},
              thickness=0.5),
            Line(
              points={{-60,-5},{60,-5}},
              color={255,0,0},
              thickness=0.5),
            Polygon(
              points={{-60,5},{80,80},{80,-70},{-60,5}},
              lineColor={255,0,0},
              pattern=LinePattern.Dot,
              lineThickness=0.5),
            Line(points={{60,-5},{90,-5}}, color={0,0,255}),
            Line(points={{-90,0},{-70,0}}, color={0,0,255}),
            Line(points={{-88,75},{-70,75}}, color={0,0,255}),
            Line(points={{-90,-75},{-70,-75}}, color={0,0,255}),
            Line(
              points={{-60,-70},{80,-70}},
              color={0,0,255},
              pattern=LinePattern.Dot),
            Line(
              points={{-60,80},{80,80}},
              color={0,0,255},
              pattern=LinePattern.Dot),
            Line(points={{-80,-20},{-60,-20}}, color={255,0,255}),
            Line(
              points={{-80,10},{-60,10}},
              color={255,0,255},
              pattern=LinePattern.Dot)}));
end Y_DeltaRegular;
annotation (preferedView="info",
  Window(
    x=0.05,
    y=0.41,
    width=0.4,
    height=0.32,
    library=1,
    autolayout=1),
  Documentation(info="<HTML>
<p>
Contains transforms for Y and Delta topology abc.
</p>
</HTML>"),
  Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics));
end Topology;
  annotation (preferedView="info",
Window(
  x=0.05,
  y=0.03,
  width=0.4,
  height=0.38,
  library=1,
  autolayout=1),
Documentation(info="<html>
<p>Electrical ports with connectors Base.Interfaces.ACabc:</p>
<p>The index notation <tt>_p_n</tt> and <tt>_pn</tt> is used for</p>
<pre>
  _p_n:     no conservation of current
  _pn:      with conservation of current
</pre>
</html>
"),
  Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics));
end Ports;
