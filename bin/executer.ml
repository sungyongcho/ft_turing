open Types
module StateSet = Set.Make(struct
  type t = string * string * int  (* (state, tape, head_position) *)
  let compare = compare
end)

let marking text =
  let marking_start = "\027[47;30m" in 
  let reset = "\027[0m" in        
  marking_start ^ text ^ reset

(* Highlight the tape at the head position *)
let highlight_char tape head_position blank =
  if head_position < 0 then
    (marking blank) ^ tape
  else if head_position >= String.length tape then
    tape ^ (marking blank)
  else
    let before = String.sub tape 0 head_position in
    let char_to_highlight = String.sub tape head_position 1 in
    let after = String.sub tape (head_position + 1) (String.length tape - head_position - 1) in
    before ^ (marking char_to_highlight) ^ after

(* Print the current state and tape *)
let print_machine_state current_state current_symbol formatted_tape =
  Printf.printf "[%s] (%s, %s)"
    formatted_tape
    current_state
    current_symbol

(* Print information about the current transition *)
let print_transition_info transition =
  Printf.printf " -> (%s, %s, %s)\n"
    transition.to_state
    transition.write
    (match transition.action with Left -> "LEFT" | Right -> "RIGHT")

    let calculate_complexity steps tape_length visits =
  if steps >= 1_000_000 then
    "Infinite"
  else
    let max_visits = List.fold_left (fun acc (_, v) -> max acc v) 0 visits in
    if steps >= tape_length && steps <= 2 * tape_length then
      "Linear (O(n))"
    else if max_visits >= 2 * tape_length then
      "Exponential (O(2^n))"
    else if max_visits >= tape_length then
      "Quadratic (O(n^2))"
    else
      "Constant (O(1))"


(* Function to display results: Total Steps, Max State Visits, and optional Time Complexity *)
let print_results step_count visits tape_length is_error =
  (* Find the state with the maximum visits *)
  let max_state, max_visits =
    List.fold_left (fun (max_s, max_c) (s, c) -> if c > max_c then (s, c) else (max_s, max_c)) ("", 0) visits
  in
  (* Calculate complexity and only print if it is not empty *)
  let complexity = calculate_complexity step_count tape_length visits in
  Printf.printf "Total Steps: %d\n" step_count;
  Printf.printf "Max State Visits: %s (%d times)\n" max_state max_visits;
  (match is_error with
  | true -> () (* Do nothing if complexity is empty *)
  | false -> Printf.printf "Time Complexity: %s\n" complexity)

(* Update the tape based on the head position and the new symbol to write *)
let update_tape tape head_position write_symbol =
  if head_position < 0 then
    write_symbol ^ tape
  else if head_position >= String.length tape then
    tape ^ write_symbol
  else
    String.init (String.length tape) (fun i ->
        if i = head_position then write_symbol.[0] else tape.[i]
      )

(* Update the head position based on the action (Left or Right) *)
let update_head_position head_position action =
  match action with
  | Left -> head_position - 1
  | Right -> head_position + 1

(* Validate that the current symbol is part of the machine's alphabet *)
let validate_symbol symbol machine =
  if not (List.mem symbol machine.alphabet) then (
    Printf.printf "Error: Invalid character '%s' encountered on the tape. Halting.\n" symbol;
    exit 1
  )
    
(* Main execution loop with steps and visits tracking *)
let rec run machine current_state tape head_position history blank_steps step_count visits =
  let max_blank_steps = 20 in (* adjustable *)
  let current_config = (current_state, tape, head_position) in

  (* Detect infinite loop *)
  if StateSet.mem current_config history then (
    Printf.printf "Error: Infinite loop detected. Halting.\n";
    print_results step_count visits (String.length tape) true;
    exit 1
  );

  (* Detect infinite run *)
  if blank_steps > max_blank_steps then (
    Printf.printf "Error: Infinite run detected. Halting.\n";
    print_results step_count visits (String.length tape) true;
    exit 1
  );

  let new_history = StateSet.add current_config history in

  let current_symbol =
    if head_position < 0 || head_position >= String.length tape then machine.blank
    else String.make 1 tape.[head_position]
  in

  (* Validate the current symbol *)
  validate_symbol current_symbol machine;

  let formatted_tape = highlight_char tape head_position machine.blank in

  (* Print the current state and tape *)
  print_machine_state current_state current_symbol formatted_tape;

  (* Update visits *)
  let updated_visits =
    let found = List.exists (fun (s, _) -> s = current_state) visits in
    if found then
      List.map (fun (s, c) -> if s = current_state then (s, c + 1) else (s, c)) visits
    else
      (current_state, 1) :: visits
  in

  (* Check if the current state is a final state *)
  if List.mem current_state machine.finals then (
    Printf.printf " -> Machine halted in final state: %s\n" current_state;
    print_results step_count visits (String.length tape) false;
    tape
  ) else (
    (* Look for a transition for the current state and symbol *)
    let state_transitions =
      try List.assoc current_state machine.transitions
      with Not_found -> []
    in

    match List.find_opt (fun t -> t.read = current_symbol) state_transitions with
    | None ->
        Printf.printf " -> No transition found for state: %s, symbol: %s\n"
          current_state current_symbol;
        print_results step_count updated_visits (String.length tape) false;
        tape
    | Some transition ->
        (* Print the transition information *)
        print_transition_info transition;

        (* Update the tape and head position *)
        let new_tape = update_tape tape head_position transition.write in
        let new_head_position = update_head_position head_position transition.action in

        (* Update blank_steps: Increment if reading blank, reset otherwise *)
        let new_blank_steps =
          if current_symbol = machine.blank && transition.to_state = current_state then
            blank_steps + 1
          else
            0
        in

        (* Continue execution with updated parameters *)
        run machine transition.to_state new_tape new_head_position new_history new_blank_steps (step_count + 1) updated_visits
  )

(* Run the Turing machine *)
let run_turing_machine machine tape =
  let initial_history = StateSet.empty in
  let initial_visits = [] in
  run machine machine.initial tape 0 initial_history 0 0 initial_visits
