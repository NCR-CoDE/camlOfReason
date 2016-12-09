(* this represents some persistence layer *)

let my_counter = ref 0

let get_counter () =
    !my_counter

let increment_counter () =
    incr my_counter

let add_counter addition =
  my_counter := !my_counter + addition

let set_counter new_value =
  my_counter := new_value
