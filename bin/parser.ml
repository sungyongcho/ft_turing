open Yojson.Safe.Util

type action = Left | Right

type transition = {
  read : string;
  to_state : string;
  write : string;
  action : action;
}

type turing_machine = {
  name : string;
  alphabet : string list;
  blank : string;
  states : string list;
  initial : string;
  finals : string list;
  transitions : (string * transition list) list;
}

let action_of_string s =
  match s with
  | "LEFT" -> Left
  | "RIGHT" -> Right
  | _ -> failwith ("Invalid action: " ^ s)

let transition_of_yojson json =
  {
    read = json |> member "read" |> to_string;
    to_state = json |> member "to_state" |> to_string;
    write = json |> member "write" |> to_string;
    action = json |> member "action" |> to_string |> action_of_string;
  }

let transitions_of_yojson states json =
  json
  |> to_assoc
  |> List.map (fun (state, transitions_json) ->
    if not (List.mem state states) then
      failwith ("Invalid state in transitions: " ^ state);
    (state, transitions_json |> to_list |> List.map transition_of_yojson))

let validate_blank_alphabet blank alphabet =
  if List.mem blank alphabet then
    ()
  else
    failwith ("blank not found in the list of alphabets")

let validate_initial_state initial states =
  if List.mem initial states then
    ()
  else
    failwith ("Initial state not found in the list of states")

let validate_final_states finals states =
 if finals = [] then
   failwith ("No final states defined");
 List.iter (fun final ->
   if not (List.mem final states) then
     failwith ("Final state not found: " ^ final))
 finals

let turing_machine_of_yojson json =
  let name = json |> member "name" |> to_string in
  let alphabet = json |> member "alphabet" |> to_list |> filter_string in
  let blank = json |> member "blank" |> to_string in
  let states = json |> member "states" |> to_list |> filter_string in
  let initial = json |> member "initial" |> to_string in
  let finals = json |> member "finals" |> to_list |> filter_string in
  let transitions = json |> member "transitions" |> transitions_of_yojson states in
  validate_blank_alphabet blank alphabet;
  validate_initial_state initial states;
  validate_final_states finals states;
  {
    name = name;
    alphabet = alphabet;
    blank = blank;
    states = states;
    initial = initial;
    finals = finals;
    transitions = transitions;
  }
