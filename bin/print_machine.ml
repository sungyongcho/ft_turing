open Types

let print_transitions transitions =
  List.iter (fun (state, transitions_list) ->
      (* Printf.printf "(%s," state; *)
      List.iter (fun transition ->
          Printf.printf "(%s, %s) -> (%s, %s, %s)\n"
            state
            transition.read
            transition.to_state
            transition.write
            (match transition.action with
              | Left -> "LEFT"
              | Right -> "RIGHT")
        ) transitions_list
    ) transitions

let print_border () =
  print_endline (String.make 80 '*')
let print_centered_line content =
  let padding = (78 - String.length content) / 2 in
  let extra = if String.length content mod 2 = 1 then 1 else 0 in
  Printf.printf "*%s%s%s*\n" (String.make padding ' ') content (String.make (padding + extra) ' ')

let print_turing_machine machine =
  (* Print the header with borders and machine name *)
  print_border ();
  print_centered_line "";
  print_centered_line machine.name;
  print_centered_line "";
  print_border ();

  (* Print machine details *)
  let alphabet_str = String.concat ", " machine.alphabet in
  let states_str = String.concat ", " machine.states in
  let finals_str = String.concat ", " machine.finals in

  print_endline ("Alphabet: [ " ^ alphabet_str ^ " ]");
  print_endline ("States : [ " ^ states_str ^ " ]");
  print_endline ("Initial : " ^ machine.initial);
  print_endline ("Finals : [ " ^ finals_str ^ " ]");

  (* Print transitions *)
  print_transitions machine.transitions;

  (* Print footer border *)
  print_border ();

