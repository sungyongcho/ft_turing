let usage_msg =
  "usage: ft_turing [-h,--help] jsonfile input

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
  Arg.parse speclist anon_fun "";
  if !jsonfile = "" || !input_arg = "" then (
    prerr_endline "Missing required arguments.\n";
    prerr_endline usage_msg;
    exit 1
  );

  (* Parse and store the machine *)
  let machine_json = Yojson.Safe.from_file !jsonfile in
  let machine = Parser.turing_machine_of_yojson machine_json in

  (* print_endline ("Machine name: " ^ machine.name); *)
  Print_machine.print_turing_machine machine;

  (* Run the Turing machine *)
  let _ = Executer.run_turing_machine machine !input_arg in

  (* Exit successfully *)
  exit 0