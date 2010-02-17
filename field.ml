open Bigarray

let sizex = 512
let sizey = 512

let field_file = if Array.length Sys.argv >1 then Sys.argv.(1) else "/tmp/foo"

let options = [Unix.O_RDWR; Unix.O_CREAT]
let mode = 0o640
let fd = Unix.openfile field_file options mode

let field = Array2.map_file fd float64 c_layout true sizex sizey ;;

for i = 0 to sizex - 1 do
  for j = 0 to sizey - 1 do
    field.{i,j} <- (float j) /. (float sizey)
  done ;
done ;;

let _ = Unix.close fd
