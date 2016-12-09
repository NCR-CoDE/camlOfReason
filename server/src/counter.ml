open Yojson.Basic

module CounterController = Controller.Make ( struct

    let my_counter = ref 0

    let get_counter () =
        !my_counter

    let increment_counter () =
        incr my_counter

    type get_json_response = {
      name: string;
      counter: int
    }

    let construct_json_response () =
      (*let counter : Yojson.Basic.json = `Int ( get_counter () ) in *)
      `Assoc [ ( "counter", `Int ( get_counter () ) ) ]

    let handle_get req =
      increment_counter () ;
      let json = construct_json_response () in
      Yojson.Basic.pretty_to_string json

  let handle_post req =
    "hello resource using post"

  let handle_put req =
    "hello resource using put"

  let handle_delete req =
    "hello resource using delete"

end
)
