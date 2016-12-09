(* this represents some persistence layer *)

type counter = int

let create () = 0

let get_counter counter =
  counter

let increment_counter counter =
  succ counter

let add_counter addition counter =
  counter + addition

let set_counter new_value counter =
  new_value

let construct_json_response counter =
  (*let counter : Yojson.Basic.json = `Int ( get_counter () ) in *)
  Yojson.Basic.pretty_to_string ( `Assoc [ ( "counter", `Int ( get_counter counter ) ) ] )
