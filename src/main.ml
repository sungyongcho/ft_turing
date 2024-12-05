(* ocaml command line argument example *)
(* https://ocaml.org/docs/cli-arguments#cli-arguments *)
let () =
  for i = 0 to Array.length Sys.argv - 1 do
    Printf.printf "[%i] %s\n" i Sys.argv.(i)
  done
