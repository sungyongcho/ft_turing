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

let turing_machine_of_yojson json =
  {
    name = json |> member "name" |> to_string;
  }
