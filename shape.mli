type point = Point of float * float

type spline
type segment
(* type circle *)
type shape =
    Spline of spline
  | Segment of segment
(*   | Circle of circle *)

val create_segment : point -> point -> shape

(* Start point, end point, start control vector, end control vector *)
val create_spline : point -> point -> point -> point -> shape

val get : shape -> float -> point
