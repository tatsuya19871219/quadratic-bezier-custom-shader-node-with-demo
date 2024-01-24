# Quadratic Bézier Curve Note

## Definition

For given three control points ($P_0, P_1\ {\rm and}\ P_2$), a quadratic Bézier curve is defined by

$$B(t) = P_1 + (1-t)^2 (P_0 - P_1) + t^2 (P_2 - P_1)$$

where $t$ is a location parameter within the range $[0, 1]$.

<img src="./qbezier.png" height="256" alt="Quadratic Bézier Curve">

### Tangent vector

$$B^{\prime}(t) = - 2(1-t)(P_0 - P_1) + 2t(P_2 - P_1)$$

### Normal vector

$$B^{\prime}(t) \cdot \overrightarrow{n}(t) = 0$$

$\overrightarrow{n}(t)$ is the unit normal vector if $|\overrightarrow{n}(t)| = 1$.

## Quadratic Bézier Curve Coordinate

Let $P$ is a point in UV coordinate, the Quadratic Bézier Curve coordinate is defined as 

$$(\mathrm{Location\ parameter}, \mathrm{Minumum\ distance}) \equiv (t, d).$$

Since 

$$(P - B(t)) \cdot B^{\prime}(t) = 0$$

is the required condition for minimum distance, the mapped coordinate can be obtained by solving the equation for $t$ and finding the minimum distance $d$.


## Misc.

### Length

A length element for the curve $B(t)$ is $|B^{\prime}(t)|dt = \sqrt{B^{\prime}(t) \cdot B^{\prime}(t)}dt$.

Therefore, the curve length from 0 to $s$ is

$$L(s) = \int_0^s {|B^{\prime}(t)|dt}$$

$$L(s) = 2\int_0^s \sqrt{a t^2 + b (1-t)^2 - 2 c t(1-t)}dt$$ 

$$= 2\int_0^s \sqrt{A t^2 + B t + C}dt$$

$A = a + b + 2c$, $B = -2b - 2c$, and $C = b$
