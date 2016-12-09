type counter
val create : unit -> counter
val increment_counter : counter -> counter
val add_counter : int -> counter -> counter
val set_counter : int -> counter -> counter
val construct_string_response : counter -> string
val construct_json_response : counter -> string
