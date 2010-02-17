open Bigarray

let sizex = 512
let sizey = 512
let maxcol = 1024

let field_file = if Array.length Sys.argv >1 then Sys.argv.(1) else "/tmp/foo"
let pnm_file = field_file ^ ".pnm"

let fd = Unix.openfile field_file [Unix.O_RDONLY] 0o640

let field = Array2.map_file fd float64 c_layout false sizex sizey

let pnm = open_out pnm_file ;;

output_string pnm "P2\n" ;
output_string pnm (string_of_int sizex) ;
output_string pnm " " ;
output_string pnm (string_of_int sizey) ;
output_string pnm "\n";
output_string pnm ((string_of_int maxcol) ^ "\n");
for i = 0 to sizex - 1 do
  for j = 0 to sizey - 1 do
    let num = truncate ((float maxcol) *. field.{i,j}) in
    let num_s = string_of_int num in
      output_string pnm num_s ;
      output_string pnm " "
  done ;
  output_string pnm "\n"
done ;;

let _ = Unix.close fd
