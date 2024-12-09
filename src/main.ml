let usage_msg =
  "usage: ft_turing [-h] jsonfile input

  positional arguments:
    jsonfile        json description of the machine
    input           input of the machine

  optional arguments:
    -h, --help      show this help message and exit"

  let jsonfile = ref ""
  let input_arg = ref ""

  (* We define -h and --help manually. They just print usage_msg and exit. *)
  let speclist = [
    ("-h", Arg.Unit (fun () -> print_endline usage_msg; exit 0), " show this help message and exit");
    ("--help", Arg.Unit (fun () -> print_endline usage_msg; exit 0), " show this help message and exit");
  ]

  let anon_fun arg =
    if !jsonfile = "" then
      jsonfile := arg
    else if !input_arg = "" then
      input_arg := arg
    else (
      prerr_endline "Too many arguments.\n";
      prerr_endline usage_msg;
      exit 1
    )

  let () =
    (* Pass an empty usage message to Arg.parse, since we handle it ourselves. *)
    Arg.parse speclist anon_fun "";

    if !jsonfile = "" || !input_arg = "" then (
      prerr_endline "Missing required arguments.\n";
      prerr_endline usage_msg;
      exit 1
    );
    print_endline !jsonfile;
    print_endline !input_arg;

    (* Main functionality here *)
