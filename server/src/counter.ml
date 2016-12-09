open Yojson.Basic

module CounterController = Controller.Make ( struct

  let construct_json_response () =
    (*let counter : Yojson.Basic.json = `Int ( get_counter () ) in *)
    Yojson.Basic.pretty_to_string ( `Assoc [ ( "counter", `Int ( CounterModel.get_counter () ) ) ] )

  let handle_get req =
    CounterModel.increment_counter () ;
    construct_json_response ()

  let handle_post req =
    CounterModel.increment_counter () ;
    construct_json_response ()

  let handle_put req =
    CounterModel.set_counter 4 ;
    construct_json_response ()

  let handle_delete req =
    CounterModel.set_counter 0 ;
    construct_json_response ()

end
)
