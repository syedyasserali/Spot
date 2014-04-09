within Spot.Common;
package Plasma "Plasma arcs"
  extends Base.Icons.Library;


  model ArcBreaker "Arc voltage for breakers"
    extends Partials.ArcBase;

    parameter SI.ElectricFieldStrength E "av electric field arc";
    parameter Real r(unit="1/A") "= R0/(d*Earc), R0 small signal resistance";
    SI.Distance d "contact distance";

  equation
    v = d*E*tanh(r*i);
    annotation (structurallyIncomplete, defaultComponentName = "arcBreaker1",
    Documentation(info="<html>
<p>
<b>Structurally incomplete model</b>. Use only as component within Breaker kernel.<br><br>
The 'arc voltage vs current' characteristic is a hyperbolic tangent.
</p>
</html>
"),   Icon(graphics={Line(
            points={{-100,0},{-76,-4},{-58,2},{-44,10},{-34,6},{-22,-2},{-16,-4},
                {-8,-4},{-2,0},{-2,0},{2,4},{10,6},{10,6},{16,2},{22,6},{30,4},
                {40,-2},{56,2},{76,-4},{100,0}},
            color={255,255,0},
            thickness=1)}));
  end ArcBreaker;

  model ArcFault "Arc voltage for faults"
    extends Partials.ArcBase;

    parameter SI.Voltage V "arc voltage";
    parameter Real r(unit="1/A") "= R0/V, R0 small signal resistance";

  equation
    v = V*tanh(r*i);
    annotation (structurallyIncomplete, defaultComponentName = "arcFault1",
      Documentation(
              info="<html>
<p>
<b>Structurally incomplete model</b>. Use only as component within complete Fault model.<br><br>
The 'arc voltage vs current' characteristic is a hyperbolic tangent.
</p>
</html>
"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-100,60},{100,-60}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-100,60},{100,60}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{-100,20},{100,20}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{-100,-60},{100,-60}},
            color={127,127,0},
            thickness=0.5),
          Line(
            points={{-44,60},{-42,56},{-48,52},{-50,46},{-46,42},{-48,36},{-46,
                28},{-48,20}},
            color={255,255,0},
            thickness=0.5),
          Line(
            points={{16,20},{26,10},{26,-2},{38,-10},{36,-30},{48,-38},{50,-60}},

            color={255,255,0},
            thickness=0.5)}));
  end ArcFault;

  package Partials "Partial models"
    extends Base.Icons.Partials;


    partial model ArcBase "Arc voltage base"

      SI.Voltage v;
      SI.Current i;
      annotation (
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Text(
              extent={{-100,-100},{100,-140}},
              lineColor={0,0,0},
              textString=
               "%name")}),
        Documentation(
              info="<html>
</html>
"));
    end ArcBase;
    annotation (
      Documentation(
              info="<html>
</html>
"));
  end Partials;

  annotation (preferredView="info",
Documentation(info="<html>
<p>Properties of plasma arcs for breakers and faults.</p>
</html>
"));
end Plasma;
