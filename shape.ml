(* --- helper types --- *)
type cubic =
    { a3 : float ;
      a2 : float ;
      a1 : float ;
      a0 : float }

(* --- real shape types --- *)
type point = Point of float * float
type spline =
    { xt : cubic ;
      yt : cubic }
type segment =
    { a : point ;
      b : point }
type shape =
    Spline of spline
  | Segment of segment

(* --- point --- *)
let point_x = function
    Point (x, _) -> x
let point_y = function
    Point (_, y) -> y

(* --- cubic --- *)
let get_cubic_point c t =
  let t2 = t *. t in
  let t3 = t *. t2 in
  let a3 = c.a3 in
  let a2 = c.a2 in
  let a1 = c.a1 in
  let a0 = c.a0 in
    a3 *. t3 +. a2 *. t2 +. a1 *. t +. a0

let create_cubic s e v w =
  { a3 =  2. *. s -. 2. *. e +.       v -. w ;
    a2 = -3. *. s +. 3. *. e -. 2. *. v +. w ;
    a1 = v ;
    a0 = s }

(* --- spline --- *)
let spline_get_x = function spl -> get_cubic_point spl.xt
let spline_get_y = function spl -> get_cubic_point spl.yt

let create_spline sp ep scv ecv =
  let sx = point_x sp in
  let sy = point_y sp in
  let ex = point_x ep in
  let ey = point_y ep in
  let scvx = point_x scv in
  let scvy = point_y scv in
  let ecvx = point_x ecv in
  let ecvy = point_y ecv in
  let cx = create_cubic sx ex scvx ecvx in
  let cy = create_cubic sy ey scvy ecvy in
    Spline ( { xt = cx; yt = cy } )


(* --- segment --- *)

let get_linear_point o1 o2 t =
    o2 *. t +. o1 *. (1.0 -. t)

let segment_get_x = function seg -> get_linear_point (point_x seg.a) (point_x seg.b)
let segment_get_y = function seg -> get_linear_point (point_y seg.a) (point_y seg.b)

let create_segment p1 p2 =
  Segment ({ a = p1; b = p2 })

(* -------------------------------------*)
let get shp t = match shp with
    Spline spl -> Point(spline_get_x spl t, spline_get_y spl t)
  | Segment seg -> Point(segment_get_x seg t, segment_get_y seg t)
